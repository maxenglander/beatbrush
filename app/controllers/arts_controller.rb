require 'open-uri'
class ArtsController < ApplicationController
  API_ROOT_URL = "http://www.vam.ac.uk/api/json/museumobject"
  LIMIT = 1

  def demo
  end

  def search
    @results = []

    terms = URI.escape(params[:term])
    remote_search_uri = URI.parse "#{API_ROOT_URL}/search?q=#{terms}&images=1&limit=#{get_limit}"
    remote_results = JSON.parse(remote_search_uri.read)
    remote_results["records"].each do |remote_result|
      remote_detailed_uri = URI.parse "#{API_ROOT_URL}/#{remote_result["fields"]["object_number"]}"
      remote_detailed_results = JSON.parse(remote_detailed_uri.read)
      if remote_detailed_results.present?
        first_remote_detailed_result = remote_detailed_results[0]["fields"]
        term_contexts = contextualize_term(params[:term], first_remote_detailed_result)
        if term_contexts.present?
          first_remote_detailed_result[:term_contexts] = term_contexts
        end
        @results << first_remote_detailed_result
      end
    end

    render json: @results
  end

  protected

  def contextualize_term term, value, matches=nil
    matches ||= []
    if value.kind_of? String
      sentences = value.split(". ").uniq
      sentences.each do |sentence|
        if sentence.include? term
          matches << sentence
        end
      end
    elsif value.kind_of? Array
      value.each do |subvalue|
        matches.concat contextualize_term(term, subvalue)
      end
    elsif value.kind_of? Hash
      value.each do |key, subvalue|
        matches.concat contextualize_term(term, subvalue)
      end
    end
    return matches.uniq
  end

  def get_limit
    params[:limit] || LIMIT
  end
end
