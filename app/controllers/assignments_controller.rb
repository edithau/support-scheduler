require 'json'

class AssignmentsController < ApplicationController

    @@display_options = {:except =>[:user_id], :include => {:user => {:except => [:undoable_date]}}}

    # eg. curl http://localhost:3000/assignments?time=today
    # eg. curl http://localhost:3000/assignments?time=month
    def index
      begin
        if params[:time] == 'today'
          # display today's assignment
          result = Assignment.today
        elsif params[:time] == "month"
          # display assignments for all Users in the current month
          result = Assignment.get_month(Date.today)
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
    # eg. curl -i -X POST http://localhost:3000/assignments -d "user_id=2"
    def create
      begin
        if (params[:user_id])
          assignment = Assignment.createAssignment(params[:user_id].to_i)
          generate_response(assignment, @@display_options, 201)
        else
          raise ArgumentError.new("Invalid POST parameters.  Please provide user_id to create an assignment.")
        end
      rescue ArgumentError => e
        generate_exception_response(e.message, 422)
      end
    end

    # swap user of 2 assignments
    # eg. curl -i -X POST http://localhost:3000/assignments/swap_user/10/15 -d ''
    # swap user of assignments 10 and 15
    def swap_user
      begin
        id1 = params[:id1].to_i
        id2 = params[:id2].to_i
        Assignment.swap_user(id1, id2)
        result = {}
        result[:uri1] = assignments_url + '/' +  params[:id1]
        result[:uri2] = assignments_url + '/' +  params[:id2]
        generate_response(result,{}, 200)
      rescue ActiveRecord::RecordNotFound, ArgumentError => e
        generate_exception_response(e.message, 422)
      rescue ActiveRecord::StatementInvalid, Exception => e
        generate_exception_response(e.message, 500)
      end
    end


    # replace user for an assignment
    # The assignment date will be marked as undoable on the replaced user record.
    # Each user can have upto 1 undoable
    # eg. curl -i -X POST http://localhost:3000/assignments/5/replace_user/10 -d ''
    # replace assignment 5's user to user 10, record undoable date on the replaced user resource
    def replace_user
      begin
        assignment = Assignment.find(params[:id])
        replaced_user_id  = assignment.user_id
        assignment.replace_user(params[:replacement_user_id])
        result = {}
        result[:uri] = assignments_url + '/' + params[:id]
        result[:undoable_user_uri] = users_url + '/' + replaced_user_id.to_s
        generate_response(result,{}, 200)
      rescue ActiveRecord::RecordNotFound, ArgumentError => e
        generate_exception_response(e.message, 422)
      rescue ActiveRecord::StatementInvalid, Exception => e
        generate_exception_response(e.message, 500)
      end
    end

  end

