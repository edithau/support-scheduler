class ApplicationController < ActionController::Base
  protect_from_forgery

  def generate_response(resp_body, options={}, code)
    resp = {}
    resp["code"] = code
    resp["result"] = resp_body.as_json(options)

    if (code == 201)
      render :json => JSON.pretty_generate(resp), :status => code, content_type: 'application/json', location: resp_body
    else
      render :json => JSON.pretty_generate(resp), :status => code, content_type: 'application/json'
    end
  end


  def generate_exception_response(msg, code)
    resp = {}
    resp["code"] = code
    resp["message"] = msg
    render :json => JSON.pretty_generate(resp), :status => code, content_type: 'application/json'
  end

end
