$ ->
  $('body').on 'activated', '.music', ->
    track = $(@).data('track')
    word = track.get('search_words')
    Art.search word, (arts) ->
      $("body").off "click", "#beat"
      $("body").on "click", "#beat", ->
        if arts[0]?
          words = arts[0].find_interesting_words()
          ms = new MusicSearch(words)
          ms.searchAndPlay()
        else
          $('header .notice').show().text("No dice. Try brush.")
          $('header button').one 'click', ->
            $('header .notice').fadeOut()
      if arts[0]?
        image = "<img src='#{arts[0].image_url(Art.SIZE_355)}' />"
        meta = arts[0].text().join("<br/><br/>")
        if arts[0].data.term_contexts?
          meta = meta.concat("<br/><br/>").concat(arts[0].data.term_contexts.join("; "))
        $('#art').html("<div>#{image}<p style='max-width:355px;'>#{meta}</p></div>").highlight(word)
      else
        $('#art').html("""<p>No art.</p>""")

class @Art
  @IMG_ROOT_URL: "http://media.vam.ac.uk/media/thira/collection_images"
  @SIZE_70: "s"
  @SIZE_130: "o"
  @SIZE_177: "ws"
  @SIZE_355: "ds"
  @SIZE_768: "l"
  @SEARCH_URI: "/arts/search.json"

  constructor: (@data) ->

  find_interesting_words: ->
    no_stops = _.reject @text().join().split(/[,.]?\s+/), (w) -> w.length < 4 || Utility.stop_word(w)
    frequencies = {}
    _.each no_stops, (l) ->
      d = l.toLowerCase()
      frequencies[d] = (frequencies[d] || 0) + 1
    sorted = _.sortBy _.keys(frequencies), (k) -> frequencies[k]
    words = (sorted[Math.floor(Math.random() * sorted.length)] for i in [0..1]).join(" ")

  image_url: (size=null) ->
    image_id = @data.primary_image_id
    image_dir = image_id.substring(0, 6)
    size_param = if size? then "_jpg_#{size}" else ""
    "#{Art.IMG_ROOT_URL}/#{image_dir}/#{image_id}#{size_param}.jpg"

  @search: (term, callback) ->
    search_uri = "#{@SEARCH_URI}?term=#{term}"
    $.get search_uri, (data) -> callback(new Art(i) for i in data)

  text: -> [ @data.physical_description, @data.materials_techniques, @data.descriptive_line, @data.history_note ]

