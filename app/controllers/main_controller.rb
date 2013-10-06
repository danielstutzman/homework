class MainController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:github_webhook]

  def root
    @sidebar_links = SidebarLink.order(:name)
    my_repo = Repo.where(user: @user, has_exercise_dirs: true).first
    if my_repo
      @sidebar_links.push SidebarLink.new(
        name: 'GitHub', url: my_repo.https_url)
      @sidebar_links = @sidebar_links.sort_by { |link| link.name }
    end
  end

  def single_lesson
    @plan = plan_from_month_day_params
  end

  def single_exercise
    @plan = plan_from_month_day_params
    @exercise = Exercise.where(
      lesson_plan: @plan, order_in_lesson: params[:order_in_lesson]).first
    @commits =
      Commit.where(user: @user, exercise: @exercise).order(:committed_at)
  end

  def login_from_github
    auth     = request.env['omniauth.auth']
    token    = auth.credentials.token
    github   = Github.new(oauth_token: token)
    username = auth.info.nickname
    user     = User.find_by_github_username(username) ||
               User.create!(github_username: username)

    # add a hook for any repos not hooked yet
    user.repos.where(is_not_found: false).each do |repo|
      begin
        if repo.hook_id.nil?
          # is there already a hook setup for this repo?
          existing_hook_id = nil
          # repos_username will always be the same as username except
          #   if people push directly to davincicoders
          repos_username = repo.https_url.split('/')[3]
          existing_hooks = github.repos.hooks.list(
            repos_username, repo.name, name: 'web', active: true)
          existing_hooks.each do |hook|
            if hook.config.url == ENV['WEBHOOK_URL']
              existing_hook_id = hook.id
            end
          end

          # fill in repo.hook_id since it's nil
          if existing_hook_id
            repo.hook_id = existing_hook_id
          else
            hook = github.repos.hooks.create(repos_username, repo.name,
              name: 'web', active: true,
              config: { url: ENV['WEBHOOK_URL'] })
            repo.hook_id = hook.id
          end
          repo.save!
        end
      rescue Github::Error::NotFound
        repo.is_not_found = true
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
          if repo.has_exercise_dirs
            files = commit_post['added'] +
                    commit_post['modified'] +
                    commit_post['removed']
            exercise_dirs = files.map { |file|
              file.include?('/') ? file.split('/')[0] : nil
            }.compact.uniq
          else
            exercise_dirs = [nil]
          end

          exercise_dirs.each do |exercise_dir|
            # for example, change '102-html-practice' to '102'
            exercise_dir_num = exercise_dir.split('-')[0].to_i.to_s
            exercise = Exercise.find_by_exercise_dir(exercise_dir_num)

            Commit.create!({
              user_id:      repo.user_id,
              repo:         repo,
              sha:          commit_post['id'],
              message:      commit_post['message'],
              committed_at: commit_post['timestamp'],
              exercise_dir: exercise_dir,
              exercise:     exercise,
            })
          end
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

  def logout
    session.clear
    redirect_to '/'
  end

  protected
  def plan_from_month_day_params
    if match = params[:month_day].match(/^([0-9]{2})-([0-9]{2})$/)
      date = Date.new(2013, match[1].to_i, match[2].to_i)
      return LessonPlan.find_by_date(date)
    else
      raise "Bad format for date, should be MM-DD"
    end
  end
end
