class MusicController < ApplicationController

  def lyrics
    gr_id = params[:gr_id]
    respond_to do |format|
      format.js do
        if resp = Gracenote.fetch_lyrics(gr_id)
          render :json => { lyrics: resp }
        else
          render :json => {}, :status => :unprocessable_entity
        end
      end
    end
  end

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
