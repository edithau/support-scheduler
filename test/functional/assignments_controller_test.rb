require 'test_helper'

class AssignmentsControllerTest < ActionController::TestCase

  # test GET /assignments/:id
  test "should get one assignment" do
    get :index, {id: Assignment.first.id}
    assert_response :success
  end

  # test GET /assignments?time=month
  # see unit test

  # test POST /assignments -d "user_id=:user_id"
  test "should create assignment" do
    assert_difference('Assignment.count') do
      post :create, {user_id: User.first.id}
    end

    assert (@response.status == 201)
  end


  #test POST /assignments/:id -d "swap_assignment_id=:assignment_id"
  test "should swap 2 user assignments" do
    assert Assignment.count > 1, 'need at least two assignments to swap'
    orig_user_id = Assignment.first.user_id
    swap_user_id = Assignment.last.user_id
    post :update, {id: Assignment.first.id, swap_assignment_id: Assignment.last.id}

    assert(Assignment.first.user_id == swap_user_id)
    assert(Assignment.last.user_id == orig_user_id)

  end

  # test POST /assignments/:id -d "replacement_user_id=:user_id"
  test "should schedule replacement user for this assignment & mark undoable on the replaced user" do
    undoable_user_id = Assignment.first.user_id
    replacement_user_id = Assignment.last.user_id
    post :update, {id: Assignment.first.id, replacement_user_id: Assignment.last.user_id}

    assert(Assignment.first.user_id == replacement_user_id)
    assert_not_nil User.find(undoable_user_id).undoable_date

  end

end
