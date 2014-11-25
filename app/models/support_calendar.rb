require 'date'
require 'holidays'

class SupportCalendar

  # get the next available on-duty date for a support assignment.  An on-duty date is a weekday and not a holiday.
  # The holiday schedule, which includes california holidays, is posted on the holiday gem's us_cali.yaml file
  # https://github.com/edithau/holidays/tree/master/data/us_cali.yaml

  def self.get_next_on_duty_date(latest_assignment_date)
    next_assignment_date = latest_assignment_date + 1
    while (next_assignment_date.wday == 6 || next_assignment_date.wday == 0 || Holidays.on(next_assignment_date, :us_cali).any? ) do
      next_assignment_date = next_assignment_date + 1
    end
    next_assignment_date
  end
end
