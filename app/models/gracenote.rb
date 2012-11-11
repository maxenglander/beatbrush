class Gracenote
  KEY="3206144-286C181EC38AC3D49148BC143405E50A"

  def self.client_id
    KEY
  end

  def self.user_id
    "264393647426601194-B80204C66DA0F70D294B57C66F9206EB"
  end

  def self.fetch_lyrics(gr_id)
    conn = Faraday.new(:url => api_url) do |f|
      f.request  :url_encoded
      f.response :logger
      f.adapter  Faraday.default_adapter
    end

    response = conn.post(api_path) do |req|
      req.body = query_track_lyrics(gr_id)
    end

    doc = Nokogiri::XML(response.body)

    lyrics = doc.xpath('//LYRIC/BLOCK').map { |l| l.content }.join("\n").gsub("\n", "<br>")
  end

  def self.query(words)
    all_tracks = []
    3.times do |n|
      p "REQUEST"
      conn = Faraday.new(:url => api_url) do |f|
        f.request  :url_encoded
        f.response :logger
        f.adapter  Faraday.default_adapter
      end

      response = conn.post(api_path) do |req|
        req.body = query_by_lyrics(words.join(" "), ((n+1)*15))
      end

      doc = Nokogiri::XML(response.body)
      considered = {}
      tracks = doc.xpath('//RESPONSE/LYRIC').map do |lyric|
        name = lyric.xpath('//TITLE').first.content
        gr_id = lyric.xpath('//GN_ID').first.content
        count = lyric.xpath('//RANGE/COUNT').first.content
        if !considered[name]
          considered[name] = name
          {
            name: name,
            artist: lyric.xpath('//ARTIST').first.content, 
            lyrics: lyric.xpath('//LYRIC_SAMPLE').first.content, 
            gr_id: gr_id,
            context: words
          }
        else
          nil
        end
      end.compact

      all_tracks = all_tracks.concat tracks if tracks
    end

    all_tracks
  end

  def self.query_by_lyrics(phrase, start)
    return <<XML
<QUERIES>
  <LANG>eng</LANG>
  <AUTH>
    <CLIENT>#{client_id}</CLIENT>
    <USER>#{user_id}</USER>
  </AUTH>
  <QUERY CMD="LYRIC_SEARCH">
    <TEXT TYPE="LYRIC_FRAGMENT">#{phrase}</TEXT>
    <RANGE>
      <START>#{start}</START>
      <END>#{start + 2}</END>
    </RANGE>
  </QUERY>
</QUERIES>
XML
  end

  def self.query_track_lyrics(gr_id)
    return <<XML
<QUERIES>
  <LANG>eng</LANG>
  <AUTH>
    <CLIENT>#{client_id}</CLIENT>
    <USER>#{user_id}</USER>
  </AUTH>
  <QUERY CMD="LYRIC_FETCH">
    <GN_ID>#{gr_id}</GN_ID>
  </QUERY>
</QUERIES>
XML
  end

  def self.api_url
    short_uid = KEY.slice(0, KEY.index('-'))
    "https://c#{short_uid}.web.cddbp.net/"
  end

  def self.api_path
    "/webapi/xml/1.0/"
  end
end
