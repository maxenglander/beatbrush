$ ->

  $('#test').click ->
    mm.search $('#musicSearch').val(),
      success : (response) ->
        console.log response
    false

  R.ready ->
    $('#search').fadeIn().submit (e) ->

      term = $('#musicSearch').val()

      R.request
        method : "search"
        content :
          types : "Track"
          query : term
        success : (response) ->
          $('#results').html('')
          _.each response.result.results, (result) ->
            html = $ """<p>#{result.name} <strong>#{result.artist}</strong></p>
              <br>
              <img src="#{result.icon}">
              """
            html.click ->
              R.player.play source: result.key
              metadata = new TrackMetadata(track: result.name, artist: result.artist)
              metadata.fetch
                success : (response) ->
                  $('#word').html("Word: "+response.uncommon_word)
                error : (response) ->
                  $('#word').html("Couldnt get word.")
            $('#results').append(html)
          true
        error : (response) ->
          console.log('error')

      e.preventDefault()
      false
