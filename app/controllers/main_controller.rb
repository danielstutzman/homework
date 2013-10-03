class MainController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:github_webhook]

  def root
    @user = User.find_by_id(session[:user_id])
  end

  def login_from_github
    auth     = request.env['omniauth.auth']
    token    = auth.credentials.token
    github   = Github.new(oauth_token: token)
    username = auth.info.nickname
    user     = User.find_by_github_username(username) ||
               User.create!(github_username: username)

    # add a hook for any repos not hooked yet
    user.repos.each do |repo|
      if repo.hook_id.nil?
        # is there already a hook setup for this repo?
        existing_hook_id = nil
        existing_hooks = github.repos.hooks.list(
          username, repo.name, name: 'web', active: true)
        existing_hooks.each do |hook|
          if hook.config.url == ENV['WEBHOOK_URL']
            existing_hook_id = hook.id
          end
        end

        # fill in repo.hook_id since it's nil
        if existing_hook_id
          repo.hook_id = existing_hook_id
        else
          hook = github.repos.hooks.create(username, repo.name,
            name: 'web', active: true,
            config: { url: ENV['WEBHOOK_URL'] })
          repo.hook_id = hook.id
        end
        repo.save!
      end
    end

    session[:user_id] = user.id

    redirect_to root_url
  end

  def github_webhook
    begin
      post     = ActiveSupport::JSON.decode(params['payload'])
      repo_url = post['repository']['url']
      repo     = Repo.find_by_https_url(repo_url)
      if repo
        post['commits'].each do |commit_post|
          files = commit_post['added'] +
                  commit_post['modified'] +
                  commit_post['removed']
          exercise_dirs = files.map { |file|
            file.include?('/') ? file.split('/')[0] : nil
          }.compact.uniq
          Commit.create!({
            user_id:           repo.user_id,
            repo:              repo,
            sha:               commit_post['id'],
            message:           commit_post['message'],
            committed_at:      commit_post['timestamp'],
            exercise_dirs_csv: exercise_dirs.join(','),
          })
        end
        head :ok
      else
        render :json => "Can't find repo for url #{repo_url.inspect}",
          status: :unprocessable_entity
      end
    rescue Exception => e
      render :json => e.message, status: :unprocessable_entity
    end
  end
end
