require 'test_helper'

class SupportCalendarTest < ActiveSupport::TestCase
  def setup
    @test_start_date = '2014-11-17'
    @on_duty_date = '2014-11-18'
    @new_year_date = '2015-01-01'
    @saturday = '2014-11-22'
  end

  test "on-duty date should be 1 day after" do
    next_on_duty_date = SupportCalendar.get_next_on_duty_date(Date.parse(@test_start_date))
    assert_equal next_on_duty_date.to_s, @on_duty_date
  end

  test "on-duty date should be after christmas" do
    next_on_duty_date = SupportCalendar.get_next_on_duty_date(Date.parse(@new_year_date))
    assert_equal next_on_duty_date, Date.parse(@new_year_date) + 1
  end

  test "on-duty date should be after saturday" do
    next_on_duty_date = SupportCalendar.get_next_on_duty_date(Date.parse(@saturday))
    assert_equal next_on_duty_date, Date.parse(@saturday)+ 2
  end
end
