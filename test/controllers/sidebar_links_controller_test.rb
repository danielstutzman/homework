require 'test_helper'

class SidebarLinksControllerTest < ActionController::TestCase
  setup do
    @sidebar_link = sidebar_links(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sidebar_links)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sidebar_link" do
    assert_difference('SidebarLink.count') do
      post :create, sidebar_link: { name: @sidebar_link.name, url: @sidebar_link.url }
    end

    assert_redirected_to sidebar_link_path(assigns(:sidebar_link))
  end

  test "should show sidebar_link" do
    get :show, id: @sidebar_link
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sidebar_link
    assert_response :success
  end

  test "should update sidebar_link" do
    patch :update, id: @sidebar_link, sidebar_link: { name: @sidebar_link.name, url: @sidebar_link.url }
    assert_redirected_to sidebar_link_path(assigns(:sidebar_link))
  end

  test "should destroy sidebar_link" do
    assert_difference('SidebarLink.count', -1) do
      delete :destroy, id: @sidebar_link
    end

    assert_redirected_to sidebar_links_path
  end
end
