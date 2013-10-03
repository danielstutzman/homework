class MainController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:github_webhook]

  def root
  end

  def login_from_github
    auth     = request.env['omniauth.auth']
    token    = auth.credentials.token
    github   = Github.new(oauth_token: token)
    username = auth.info.nickname
    user     = User.find_by_github_username(username) ||
               User.create!(github_username: username)

    # add a hook for any new repos
    user.repos.each do |repo|
      if repo.hook_id.nil?
        hook = github.repos.hooks.create(username, repo.name,
          name: 'web', active: true, config: { url: ENV['WEBHOOK_URL'] })
        repo.hook_id = hook.id
        repo.save!
      end
    end

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
