class window.MusicSearch
  constructor : (@words) ->

  search : =>

    $.ajax
      url: "/music/search"
      data:
        words: @words
      dataType: "JSON"
      success: @handleResponse
      error: @handleError

  handleResponse : (resp) =>
    $('#results').html('')
    _.each resp, (o) =>
      name = o.name
      artist = o.artist
      lyrics = o.lyrics

      R.request
        method : "search"
        content :
          types : "Track"
          query : """#{name} #{artist}"""
        success : (response) =>
          result = response.result.results[0]
          html = $ """
          <div class="music">
            <div class="image">
              <img src="#{result.icon}">
            </div>
            <div class="data">
              <p>#{result.name}<br><strong>#{result.artist}</strong></p>
              <p class="lyrics">#{lyrics}</p>"
            </div>
          </div>
            """
          _.each @words.split(" "), (w) -> html.highlight(w)
          console.log @words
          html.click ->
            R.player.play source: result.key
          $('#results').append(html)
          true
        error : (response) ->
          console.log('error')


  handleError : (resp) =>
    console.log('error!', resp)
