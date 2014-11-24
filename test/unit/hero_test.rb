require 'test_helper'

class HeroTest < ActiveSupport::TestCase

  def setup
    @hero = heroes(:Sherry)
    @assignment = Assignment.createAssignment( @hero.id)
  end

  test "should have unique names" do
    assert_raises(ActiveRecord::RecordNotUnique) { Hero.create(name: 'Sherry') }
  end

  test "should not delete heroes with assignment(s)" do
    assert_raises(ActiveRecord::DeleteRestrictionError) {Hero.destroy(@hero.id)}
  end

end
