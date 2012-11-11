$ ->
  $("#search").on "click", "#submit", (eventObject) ->
    term = $("#term").val()
    try
      Art.search term, (results) ->
        for result in results
          image = "<img src='#{result.image_url(Art.SIZE_177)}'/>"
          context_list = ""
          for context in result.data.term_contexts
            context_list = context_list.concat("<li>" + context + "</li>")
          html = "<div id='#{result.data.object_number}'>#{image}<ul>#{context_list}</ul></div>"
          $("#images").append(html).highlight(term)
    catch e
      console.log(e.message)
    return false
