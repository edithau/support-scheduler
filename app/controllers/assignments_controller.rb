class AssignmentsController < ApplicationController

    # eg. curl http://localhost:3000/schedules?time=today
    def index
      begin
        if params[:time] == "today"
          # display today's suport hero
          result = Scheduler.get_todays_hero
        elsif params[:time] == "month"
          # display full schedule for all heros in the current month
          result = Scheduler.get_schedule_this_month
        else
          # XXX how to show links to all schedules?
          result = Scheduler.get_all_schedules
        end
        generate_response(result, 200)
      rescue ArgumentError => e
        generate_exception_response(e.message, 422)
      end

    end


    # eg. curl -X POST http://localhost:3000/schedules -d "name=mary"
    def create
      begin
        schedule = Scheduler.createSchedule(params[:name])
        generate_response(schedule, 200)
      rescue ArgumentError => e
        generate_exception_response(e.message, 422)
      end
    end

    # eg. curl -X POST http://localhost:3000/schedules/Vincente -d "undoable_date=2014-11-10" -d "replace_with=Sherry"
    # eg. curl -X POST http://localhost:3000/schedules/boris -d "swap_with=kevin" -d "date1=2014-11-04" -d "date2=2014-11-13"
    def update
      begin
        if (params[:undoable_date])
          schedule = Scheduler.mark_undoable(params[:name], params[:undoable_date], params[:replace_with] )
        elsif (params[:swap_with])
          schedule = Scheduler.swap(params[:name], params[:swap_with], params[:date1], params[:date2])
        else
          raise ArgumentError.new("Please specify parameters for either a mark undoable or a swap schedule update")
        end
      rescue ArgumentError => e
        generate_exception_response(e.message, 422)
      end
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

