require 'json'

class HerosController < ApplicationController
  @@display_options = {:include => {:assignments => {:except => [:hero_id]}}}

  # eg. curl http://localhost:3000/heros
  def index
    begin
      result = Hero.all
      generate_response(result, @@display_options, 200)
    rescue ArgumentError => e
      generate_exception_response(e.message, 422)
    end

  end

  # eg. curl http://localhost:3000/heros/1
  def view
    begin
      result = Hero.find(params[:id])
      generate_response(result, @@display_options, 200)
    rescue ActiveRecord::RecordNotFound => e
      generate_exception_response(e.message, 404)
    end
  end


  # return all assignments for this hero
  # eg. curl http://localhost:3000/heros/2/assignments
  def assignments
    begin
      display_options = {:except =>[:hero_id], :include => {:hero => {:except => [:undoable_date]}}}
      result = Hero.find(params[:id]).assignments
      generate_response(result, display_options, 200)
    rescue ActiveRecord::RecordNotFound => e
      generate_exception_response(e.message, 404)
    end
  end


  # eg. curl -X POST http://localhost:3000/heros -d "name=mary"
  def create
    begin
      # XXX id missing -- caused error when generate response (undefined method hero_url)
      # XXX names should be unique but not
      result = Hero.create(name: params[:name])
      generate_response(result, {}, 201)
    rescue ArgumentError => e
      generate_exception_response(e.message, 422)
    end
  end

  def hero_url(param)
    s = 'huh?'
  end

end
