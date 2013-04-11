jQuery ->
  $ = jQuery
  $.getJSON("bots.json", getBots)

getBots = (bots) ->
  for name, code of bots
    alert name + " " + code


