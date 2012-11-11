class LyricsController < ApplicationController

  def search
    name = params[:song_name]
    artist = params[:artist_name]
    mm = MusixMatch.search_track(:q_track => name, :q_artist => artist)

    respond_to do |format|
      format.json do
        if mm.status_code == 200
          tid = nil
          track = nil
          mm.each do |r|
            track = r
            tid = r.track_id
          end
          if tid
            mm2 = MusixMatch.get_lyrics(tid)
            if mm2.status_code == 200 && lyrics = mm2.lyrics
              render :json => {
                lyrics: lyrics,
                uncommon_word: Lyrics.new(lyrics.lyrics_body).uncommon_word,
                artist_name: track.artist_name,
                track_name: track.track_name
              }
            else
              render :json => { }, :status => :unprocessable_entity
            end
          else
            render :json => { }, :status => :unprocessable_entity
          end
        else
          raise "whoops!"
        end
      end
    end
  end
end
