require 'test_helper'


class HeroesControllerTest < ActionController::TestCase
  test "should create hero" do
    assert_difference('Hero.count') do
      post :create, name: 'Tom'
    end

    assert (@response.status == 201)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should delete hero" do
    assert_difference 'Hero.count', -1 do
      post :destroy, id:Hero.last.id
    end
  end
end
