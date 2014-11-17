require 'date'

class Scheduler < ActiveRecord::Base
  # load all schedules from the db when server first started.
  # XXX how to sort by date?  is there an initializer for static method
  # XXX how to filter out id and created_at field?
  today = Date.today
  index = 0
  @schedules = Assignment.all
  @schedules.all.each_with_index do |schedule, i|
    if (schedule.sdate >= today)
      index = i
      break
    end
  end
  @schedules = @schedules[index, @schedules.length]



  # if today's is an off-duty date (ie. weekends or holidays), return the next on-duty date
  def self.get_todays_hero

    @schedules[0]

  end

  # return schedule of the current month
  def self.get_schedule_this_month
    # XXX

  end

  def self.get_all_schedules
    @schedules
  end

  def self.createSchedule(name)
    # XXX how to create new schedule which will also create dependency (ie. Hero) if it does not exist?
    hero = Hero.create(name: name)
    schedule = Assignment.create(hero: hero, sdate: Date.today)
  end
end
