require 'test_helper'


class UsersControllerTest < ActionController::TestCase
  # test POST /users -d "name=Tom"
  test "should create user" do
    assert_difference('User.count') do
      post :create, name: 'Tom'
    end

    assert (@response.status == 201)
  end

  # test DELETE /users/:id
  test "should not delete user with an assignment" do
    post :destroy, id:User.first.id
    assert (@response.status == 422)
  end

  # test GET /users?time=today
  test "should get today's hero" do
    get :index, {time: 'today'}
    assert_response :success
  end

  # test GET /users/:id/assignments
  test "should get user's assignments" do
    get :index, {id: User.first.id}
    body_json = JSON.parse(@response.body)
    assert (body_json['result'][0]['assignments'].count > 0)
  end
end
