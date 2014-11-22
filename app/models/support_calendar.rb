require 'date'
require 'holidays'

class SupportCalendar

  def self.get_next_on_duty_date(latest_assignment_date)
    next_assignment_date = latest_assignment_date + 1
    while (next_assignment_date.wday == 6 || next_assignment_date.wday == 0 || Holidays.on(next_assignment_date, :us_cali).any? ) do
      next_assignment_date = next_assignment_date + 1
    end
    next_assignment_date
  end
end
