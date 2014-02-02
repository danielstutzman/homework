class MainController < ApplicationController
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
    raise ActionController::RoutingError.new('Not Found') if @plan.nil?
  end

  def single_exercise
    @plan = plan_from_month_day_params
    raise ActionController::RoutingError.new('Not Found') if @plan.nil?
    @exercise = Exercise.where(
      lesson_plan: @plan, order_in_lesson: params[:order_in_lesson]).first
    raise ActionController::RoutingError.new('Not Found') if @exercise.nil?
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

    session[:user_id] = user.id

    redirect_to root_url
  end

  def logout
    session.clear
    redirect_to '/'
  end

  protected
  def plan_from_month_day_params
    if match = params[:month_day].match(/^([0-9]{2})-([0-9]{2})$/)
      date = Date.new(2014, match[1].to_i, match[2].to_i)
      return LessonPlan.find_by_date(date)
    else
      return nil
    end
  end
end
