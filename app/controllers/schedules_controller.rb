class SchedulesController < ApplicationController

  class SchedulesController < ApplicationController

    def index
      if params[:time] == "today"
        # display today's suport hero
        result = Scheduler.get_todays_hero
      elsif params[:time] == "month"
        # display full schedule for all heros in the current month
        result = Scheduler.get_schedule_this_month
      else
        schedules = Schedule.all
      end

      # XXX loop thru schedule to select fields, show only those and prettify
      # XXX also need to implement :create and :update from routes.rb
      render :json => JSON.pretty_generate(schedules.to_json)

    end


    def generate_response(resp_body, code)
      resp = {}
      resp["code"] = code
      resp["result"] = resp_body

      render :json => JSON.pretty_generate(resp), :status => code, content_type: 'application/json'
    end


    def generate_exception_response(msg, code)
      resp = {}
      resp["code"] = code
      resp["message"] = msg
      render :json => JSON.pretty_generate(resp), :status => code, content_type: 'application/json'
    end
  end
end
