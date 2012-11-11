$ ->

  R.ready ->
    $('#search').fadeIn().submit (e) ->

      term = $('#musicSearch').val()

      console.log( term )

      R.request
        method : "search"
        content :
          types : "Track"
          query : term
        success : (response) ->
          $('#results').html('')
          _.each response.result.results, (result) ->
            html = $ """<p>#{result.name}</p>"""
            html.click ->
              R.player.play source: result.key
            $('#results').append(html)
          true
        error : (response) ->
          console.log('error')

      e.preventDefault()
      false
