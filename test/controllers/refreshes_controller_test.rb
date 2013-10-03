require 'test_helper'

class RefreshesControllerTest < ActionController::TestCase
  setup do
    @refresh = refreshes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:refreshes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create refresh" do
    assert_difference('Refresh.count') do
      post :create, refresh: { exercise_id: @refresh.exercise_id, logged_at: @refresh.logged_at, repo_id: @refresh.repo_id, user_id: @refresh.user_id }
    end

    assert_redirected_to refresh_path(assigns(:refresh))
  end

  test "should show refresh" do
    get :show, id: @refresh
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @refresh
    assert_response :success
  end

  test "should update refresh" do
    patch :update, id: @refresh, refresh: { exercise_id: @refresh.exercise_id, logged_at: @refresh.logged_at, repo_id: @refresh.repo_id, user_id: @refresh.user_id }
    assert_redirected_to refresh_path(assigns(:refresh))
  end

  test "should destroy refresh" do
    assert_difference('Refresh.count', -1) do
      delete :destroy, id: @refresh
    end

    assert_redirected_to refreshes_path
  end
end
