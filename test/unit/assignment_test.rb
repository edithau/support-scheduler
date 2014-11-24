require 'test_helper'
require 'date'

class AssignmentTest < ActiveSupport::TestCase

    def setup
      @user = users(:Sherry)
      @assignment = @user.assignments.build(date: Date.today)
    end

    test "should be valid" do
      assert @assignment.valid?
    end

    test "user id should be present" do
      @assignment.user_id = nil
      assert @assignment.invalid?
    end

    test "assignment date should be present" do
      @assignment.date = nil
      assert @assignment.invalid?
    end

    test "order should be earliest first " do
      assert_equal Assignment.first, assignments(:earliest_assignment)
    end

    test "should have unique assignment date" do
      dup_date = Assignment.first.date
      assert_raises(ActiveRecord::RecordNotUnique) {Assignment.create(user: @user, date: dup_date)}
    end

    # cannot test this as functional since "current" month is a moving date
    test "should get one month assignments" do
      target_date = Assignment.first.date
      target_assignments = Assignment.get_month(target_date)
      assert_equal target_assignments.count, 2  # check yml file
    end


end
