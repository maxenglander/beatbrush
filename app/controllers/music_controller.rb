class MusicController < ApplicationController

  def lyrics
    fetch_params = params.slice(:gr_id, :artist, :title)
    respond_to do |format|
      format.js do
        if resp = Gracenote.fetch_lyrics(fetch_params)
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
        if resp = Lyricsnmusic.query(words)
          render :json => resp
        else
          render :json => {}, :status => :unprocessable_entity
        end
      end
    end
  end

end
