$ ->
  $("#search").on "click", "#submit", (eventObject) ->
    term = $("#term").val()
    try
      Art.search term, (results) ->
        $("#images").append("<img src='#{result.image_url()}'/>") for result in results
    catch e
      console.log(e.message)
    return false
