require 'json'

class UsersController < ApplicationController
  @@display_options = {:include => {:assignments => {:except => [:user_id]}}}

  # eg. curl http://localhost:3000/users
  def index
    begin
      if params[:time] == "today"
        today_hero_id = Assignment.today.user_id
        result = User.find(today_hero_id)
      else
        result = User.all
      end
      generate_response(result, {}, 200)
    rescue Exception => e
      # there should be no service related error generated from this request
      # throw an internal system error code
      generate_exception_response(e.message, 500)
    end

  end

  # eg. curl http://localhost:3000/users/1
  def show
    begin
      result = User.find(params[:id])
      generate_response(result, @@display_options, 200)
    rescue ActiveRecord::RecordNotFound => e
      generate_exception_response(e.message, 404)
    rescue Exception => e
      generate_exception_response(e.message, 500)
    end
  end


  # return all assignments of this user
  # eg. curl http://localhost:3000/users/2/assignments
  def assignments
    begin
      display_options = {:except =>[:user_id], :include => {:user => {:except => [:undoable_date]}}}
      user = User.find(params[:id])
      result = user.get_assignments
      generate_response(result, display_options, 200)
    rescue ActiveRecord::RecordNotFound => e
      generate_exception_response(e.message, 404)
    rescue Exception => e
      generate_exception_response(e.message, 500)
    end
  end

  # eg. curl -i -X POST http://localhost:3000/users -d "name=mary"
  def create
    begin
      user = User.create(name: params[:name])
      generate_response(user, {}, 201)
    rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid => e
      generate_exception_response(e.message, 422)
    rescue Exception => e
      generate_exception_response(e.message, 500)
    end
  end

  # eg. curl -i -X DELETE http://localhost:3000/users/5
  def destroy
    begin
      User.destroy(params[:id])
      generate_response({}, {}, 204)
    rescue ActiveRecord::RecordNotFound => e
      generate_exception_response(e.message, 404)
    rescue ActiveRecord::DeleteRestrictionError  => e
      generate_exception_response(e.message, 422)
    rescue Exception => e
      generate_exception_response(e.message, 500)
    end

  end


  def url_for(user)
      'users/' + user.id.to_s
  end

end
