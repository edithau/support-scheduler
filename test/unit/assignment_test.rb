require 'test_helper'
require 'date'

class AssignmentTest < ActiveSupport::TestCase

    def setup
      @hero = heros(:Sherry)
      @assignment = @hero.assignments.build(sdate: Date.today)
    end

    test "should be valid" do
      assert @assignment.valid?
    end

    test "hero id should be present" do
      @assignment.hero_id = nil
      assert @assignment.invalid?
    end

    test "assignment date should be present" do
      @assignment.sdate = nil
      assert @assignment.invalid?
    end

    test "order should be earliest first " do
      assert_equal Assignment.first, assignments(:earliest_assignment)
    end

    test "should have unique assignment date" do
      dup_date = Assignment.first.sdate
      dup_assignment = Assignment.new(hero: @hero, sdate: dup_date)
      assert dup_assignment.invalid?
    end

end
