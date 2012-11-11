require 'open-uri'
class ArtsController < ApplicationController
  API_ROOT_URL = "http://www.vam.ac.uk/api/json/museumobject/search"
  LIMIT = 3

  def demo
  end

  def search
    search_uri = URI.parse "#{API_ROOT_URL}?q=#{params[:term]}&random=1&images=1&limit=#{get_limit}"
    result_str = search_uri.read 
    result = JSON.parse result_str
    render json: result["records"].collect { |i| i["fields"] }
  end

  protected

  def get_limit
    params[:limit] || LIMIT
  end
end
