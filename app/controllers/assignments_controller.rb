require 'json'

class AssignmentsController < ApplicationController

    @@display_options = {:except =>[:hero_id], :include => {:hero => {:except => [:undoable_date]}}}

    # eg. curl http://localhost:3000/assignments?time=today
    # eg. curl http://localhost:3000/assignments?time=month
    def index
      begin
        if params[:time] == "today"
          # display today's assignment
          result = Assignment.today
        elsif params[:time] == "month"
          # display assignments for all heroes in the current month
          result = Assignment.current_month
        else
          result = Assignment.all
        end
        generate_response(result, @@display_options, 200)
      rescue ArgumentError => e
        generate_exception_response(e.message, 422)
      end

    end

    # eg. curl http://localhost:3000/assignments/1
    def show
      begin
        result = Assignment.find(params[:id])
        generate_response(result, @@display_options, 200)
      rescue ActiveRecord::RecordNotFound => e
        generate_exception_response(e.message, 404)
      end
    end


    # create a new assignment for the next available on-duty date
    # eg. curl -X POST http://localhost:3000/assignments -d "hero_id=2"
    def create
      begin
        if (params[:hero_id])
          assignment = Assignment.createAssignment(params[:hero_id])
          generate_response(assignment, @@display_options, 201)
        else
          raise ArgumentError.new("Invalid POST parameters.  Please provide hero_id to create an assignment.")
        end
      rescue ArgumentError => e
        generate_exception_response(e.message, 422)
      end
    end


    # this method supports:
    # 1. swap assignments
    # eg. curl -X POST http://localhost:3000/assignments/19 -d "swap_assignment_id=16"

    # 2. replace hero for an assignment --
    #   the assignment date will be marked as undoable on the replaced hero record.
    #   Each hero can have upto 1 undoable
    # eg. curl -X POST http://localhost:3000/assignments/17 -d "replacement_hero_id=3"
    def update
      begin
        assignment = Assignment.find(params[:id])
        if (params[:swap_assignment_id])
          Assignment.swap(assignment.id, params[:swap_assignment_id].to_i)
        elsif (params[:replacement_hero_id])
          replacement_hero_id = params[:replacement_hero_id].to_i
          if (assignment.hero_id == replacement_hero_id )
            raise ArgumentError.new("Cannot replace one self")
          else
            assignment.replace_hero(replacement_hero_id)
          end
        else
          raise ArgumentError.new("Invalid POST parameters.  To swap assignments, please provide swap_assignment_id. To replace assignment's hero, please provide replacement_hero_id.")
        end
        generate_response(assignment,@@display_options, 200)
      rescue ActiveRecord::RecordNotFound, ArgumentError => e
        generate_exception_response(e.message, 422)
      rescue ActiveRecord::StatementInvalid=> e
        generate_exception_response(e.message, 500)
      end
    end
  end

