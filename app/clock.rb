require './config/boot'
require './config/environment'
require 'date'


# cron job to delete out-dated assignment once a day
module Clockwork
  every(1.day, 'delete.out-dated.assignment', :at => '00:00') {
      @assignments = Assignment.where("sdate < ?", Date.today)
    @assignments.each do |assignment|
      assignment.destroy
    end
  }
end