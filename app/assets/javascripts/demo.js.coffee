$ ->
  $("#search").on "click", "#submit", (eventObject) ->
    term = $("#term").val()
    try
      Art.search term, (results) ->
        $("#images").append("<div id='#{result.data.object_number}'><img src='#{result.image_url(Art.SIZE_177)}'/>#{JSON.stringify(result.data.term_contexts)}</div>") for result in results
    catch e
      console.log(e.message)
    return false
