require 'json'

class HeroesController < ApplicationController
  @@display_options = {:include => {:assignments => {:except => [:hero_id]}}}

  # eg. curl http://localhost:3000/heroes
  def index
    begin
      result = Hero.all
      generate_response(result, @@display_options, 200)
    rescue ArgumentError => e
      generate_exception_response(e.message, 422)
    end

  end

  # eg. curl http://localhost:3000/heroes/1
  def show
    begin
      result = Hero.find(params[:id])
      generate_response(result, @@display_options, 200)
    rescue ActiveRecord::RecordNotFound => e
      generate_exception_response(e.message, 404)
    end
  end


  # return all assignments of this hero
  # eg. curl http://localhost:3000/heroes/2/assignments
  def assignments
    begin
      display_options = {:except =>[:hero_id], :include => {:hero => {:except => [:undoable_date]}}}
      #result = Hero.find(params[:id]).assignments
      hero = Hero.find(params[:id])
      result = hero.get_assignments
      generate_response(result, display_options, 200)
    rescue ActiveRecord::RecordNotFound => e
      generate_exception_response(e.message, 404)
    end
  end


  # eg. curl -X POST http://localhost:3000/heroes -d "name=mary"
  def create
    begin
      hero = Hero.create(name: params[:name])
      generate_response(hero, {}, 201)
    rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid => e
      generate_exception_response(e.message, 422)
    end
  end

  # eg. curl -X DELETE http://localhost:3000/heroes/5
  def destroy
    begin
      Hero.destroy(params[:id])
      generate_response({}, {}, 204)
    rescue ActiveRecord::RecordNotFound => e
      generate_exception_response(e.message, 404)
    rescue ActiveRecord::DeleteRestrictionError  => e
      generate_exception_response(e.message, 422)

    end

  end

  #def url_for2(hero)
  #  begin
  #    'heroes/' + hero.id.to_s
  #  rescue NoMethodError => e
  #    super(hero)
  #  end
  #end

  def url_for(hero)
      'heroes/' + hero.id.to_s
  end

end
