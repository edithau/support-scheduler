require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = users(:Sherry)
    @assignment = Assignment.createAssignment( @user.id)
  end

  test "should have unique names" do
    assert_raises(ActiveRecord::RecordNotUnique) { User.create(name: 'Sherry') }
  end

  test "should not delete Users with assignment(s)" do
    assert_raises(ActiveRecord::DeleteRestrictionError) {User.destroy(@user.id)}
  end

end
