class Lyricsnmusic
  API_URL = "http://api.lyricsnmusic.com"

  def self.query(words)
    conn = Faraday.new(url: API_URL)
    resp = conn.get do |req|
      req.url '/songs'
      req.params['q'] = words.join(" ")
    end

    data = JSON.parse(resp.body)
    tracks = data.map do |d|
      {
        artist: prep(d["artist"]["name"]),
        name: prep(d["title"]),
        lyrics: d["context"].present? ? prep(d["context"]) : prep(d["snippet"]),
        context: words
      }
    end.select do |d|
      d.slice(:name, :lyrics, :artist).any? {|k,v| contains_words(words, v)}
    end.shuffle.slice(0,3)
  end

  private 

  def self.prep(string)
    string.encode('UTF-8', 'UTF-8', :invalid => :replace)
  end

  def self.contains_words(words, string)
    words.any? { |w| string =~ /#{Regexp.escape(w)}/i }
  end
end
