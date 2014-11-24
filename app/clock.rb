#require './config/boot'
#require './config/environment'
require 'date'


# cron job to delete out-dated assignment once a day
# clockworkd -c app/clock.rb start --log and clockworkd -c app/clock.rb stop --log
module Clockwork
  every(1.day, 'delete.out-dated.assignment', :at => '00:00') {
      @assignments = Assignment.where('date < ?', Date.today)
    @assignments.each do |assignment|
      assignment.destroy
    end
  }
end