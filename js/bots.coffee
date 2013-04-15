# assumes jQuery and async are available

stats = {}
period = null

jQuery ->
  $ = jQuery
  draw()

$(window).bind "hashchange", ->
  draw()

draw = ->
  period = $.bbq.getState("period") || "hour"
  $.getJSON "bots.json", (bots) ->
    botNames = (name for name of bots)
    async.map(botNames, getBotStats, drawChart)
    $(".nav li").removeClass("active")
    $("#period-#{ period }").addClass("active")

getBotStats = (name, callback) ->
  url = "stats/#{name}_" + period + ".json"
  $.getJSON url, (stats) ->
    stats.shift() # pop off column headers
    stats.unshift(name) # push on the name for this stat
    callback(null, stats)

drawChart = (err, stats) ->
  ctx = $('#chart').get(0).getContext("2d")
  chart = new Chart(ctx)
  data = makeData(stats)
  opts =
    pointDot: false,
    datasetFill: false,
    scaleShowLabels: true,
    datasetStrokeWidth: 2
  chart.Line(data, opts)
  legend = $("#legend")
  legend.empty()
  for dataset in data.datasets
    li = $('<li><a style="color: ' + dataset.strokeColor + '" href="http://wikidata.org/wiki/User:' + dataset.name + '">' + dataset.name + '</a></li>')
    li.css(color: dataset.strokeColor)
    legend.append(li)

makeData = (stats) ->
  datasets = []
  for s, i in stats
    name = s.shift()
    labels = makeLabels(stats)
    data = []
    hasData = false
    for row in s
      if row[1] > 0
        hasData = true
      data.push(row[1])
    color = colors[i]
    if hasData
      datasets.push(name: name, strokeColor: color, data: data)
  return labels: labels, datasets: datasets

makeLabels = (stats) ->
  count = 0
  labels = []
  for row in stats[1]
    if count % 7 == 0
      d = new Date(row[0] * 1000)
      labels.push(formatDate(d))
    else
      labels.push("")
    count += 1
  return labels

pad = (n) ->
  if n < 10
    return '0' + n
  else
    return n

formatDate = (d) ->
  return d.getUTCFullYear() + '-' + pad(d.getUTCMonth() + 1) + '-' + pad(d.getUTCDate()) + ' '

colors = [
    "blue",
    "blueviolet",
    "brown",
    "cadetblue",
    "chartreuse",
    "chocolate",
    "cornflowerblue",
    "crimson",
    "cyan",
    "darkblue",
    "darkcyan",
    "darkgoldenrod",
    "darkgray",
    "darkgreen",
    "darkkhaki",
    "darkmagenta",
    "darkolivegreen",
    "darkorange",
    "darkorchid",
    "darkred",
    "darksalmon",
    "darkseagreen",
    "darkturquoise",
    "darkviolet",
    "dodgerblue",
    "forestgreen",
    "fuchsia",
    "gainsboro",
    "gold",
    "goldenrod",
    "gray",
    "green",
    "greenyellow",
    "honeydew",
    "hotpink",
    "indianred",
    "indigo",
    "ivory",
    "khaki",
    "lavender",
    "lavenderblush",
    "lawngreen",
    "lemonchiffon",
    "lime",
    "limegreen",
    "linen",
    "magenta",
    "maroon",
    "mediumaquamarine",
    "mediumblue",
    "mediumorchid",
    "mediumpurple",
    "mediumseagreen",
    "mediumslateblue",
    "mediumspringgreen",
    "mediumturquoise",
    "mediumvioletred",
    "midnightblue",
    "mintcream",
    "mistyrose",
    "moccasin",
    "navajowhite",
    "navy",
    "oldlace",
    "olive",
    "olivedrab",
    "orange",
    "orangered",
    "orchid",
    "palegoldenrod",
    "palegreen",
    "paleturquoise",
    "palevioletred",
    "papayawhip",
    "peachpuff",
    "peru",
    "pink",
    "plum",
    "powderblue",
    "purple",
    "red",
    "rosybrown",
    "royalblue",
    "saddlebrown",
    "salmon",
    "sandybrown",
    "seagreen",
    "seashell",
    "sienna",
    "silver",
    "skyblue",
    "slateblue",
    "slategray",
    "snow",
    "springgreen",
    "steelblue",
    "tan",
    "teal",
    "thistle",
    "tomato",
    "turquoise",
    "violet",
    "wheat",
    "whitesmoke",
    "yellow",
    "yellowgreen"
]
