class MusicController < ApplicationController

  def search
    words = params[:words].split(" ")
    respond_to do |format|
      format.js do
        if resp = Gracenote.query(words)
          render :json => resp
        else
          render :json => {}, :status => :unprocessable_entity
        end
      end
    end
  end

end
