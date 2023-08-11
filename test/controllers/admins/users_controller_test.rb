require "test_helper"

class Admins::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admins_user = admins_users(:one)
  end

  test "should get index" do
    get admins_users_url
    assert_response :success
  end

  test "should get new" do
    get new_admins_user_url
    assert_response :success
  end

  test "should create admins_user" do
    assert_difference("Admins::User.count") do
      post admins_users_url, params: { admins_user: {  } }
    end

    assert_redirected_to admins_user_url(Admins::User.last)
  end

  test "should show admins_user" do
    get admins_user_url(@admins_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_admins_user_url(@admins_user)
    assert_response :success
  end

  test "should update admins_user" do
    patch admins_user_url(@admins_user), params: { admins_user: {  } }
    assert_redirected_to admins_user_url(@admins_user)
  end

  test "should destroy admins_user" do
    assert_difference("Admins::User.count", -1) do
      delete admins_user_url(@admins_user)
    end

    assert_redirected_to admins_users_url
  end
end
