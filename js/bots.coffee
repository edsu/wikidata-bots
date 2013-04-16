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
    botNames = botNames.filter (name) ->
      bots[name] != null
    async.map(botNames, getBotStats, drawChart)
    $(".nav li").removeClass("active")
    $("#period-#{ period }").addClass("active")

getBotStats = (name, callback) ->
  url = "stats/#{name}_" + period + ".json"
  $.getJSON url, (stats, status, jqXHR) ->
    stats.shift() # pop off column headers
    stats.unshift(name) # push on the name for this stat
    callback(null, stats)

drawChart = (err, stats, selected) ->
  ctx = $('#chart').get(0).getContext("2d")
  chart = new Chart(ctx)
  data = makeData(stats, selected)
  opts =
    pointDot: false,
    datasetFill: false,
    scaleShowLabels: true,
    datasetStrokeWidth: 2,
    animation: false
  chart.Line(data, opts)

  legend = $("#legend")
  legend.empty()
  for dataset in data.datasets
    li = $('<li><a data-dataset="' + dataset.name + '" style="color: ' + dataset.strokeColor + '" href="http://wikidata.org/wiki/User:' + dataset.name + '">' + dataset.name + '</a></li>')
    legend.append(li)

  $("#legend a").hover(
    (ev) ->
      console.log $(ev.target).css('color')
      newSelected = $(ev.target).data('dataset')
      if newSelected != selected
        drawChart(err, stats, newSelected)
    (ev) ->
      console.log ev.type
      $(ev.target).css('font-weight', 'normal')
      drawChart(err, stats)
  )

makeData = (stats, selected) ->
  datasets = []
  console.log selected
  for s, i in stats
    name = s[0]
    labels = makeLabels(stats)
    color = colors[i]
    if selected and selected != name
      color = color.replace('0.7', '0.1')

    data = []
    hasData = false
    for row in s[1..-1]
      if row[1] > 0
        hasData = true
      data.push(row[1])
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
  "rgba(103, 0, 31, 0.7)",
  "rgba(178, 24, 43, 0.7)",
  "rgba(214, 96, 77, 0.7)",
  "rgba(244, 165, 130, 0.7)",
  "rgba(209, 229, 240, 0.7)",
  "rgba(146, 197, 222, 0.7)",
  "rgba(67, 147, 195, 0.7)",
  "rgba(33, 102, 172, 0.7)",
  "rgba(5, 48, 97, 0.7)",
  "rgba(103, 0, 31, 0.7)",
  "rgba(178, 24, 43, 0.7)",
  "rgba(214, 96, 77, 0.7)",
  "rgba(244, 165, 130, 0.7)",
  "rgba(186, 186, 186, 0.7)",
  "rgba(135, 135, 135, 0.7)",
  "rgba(77, 77, 77, 0.7)",
  "rgba(26, 26, 26, 0.7)",
  "rgba(165, 0, 38, 0.7)",
  "rgba(215, 48, 39, 0.7)",
  "rgba(244, 109, 67, 0.7)",
  "rgba(253, 174, 97, 0.7)",
  "rgba(254, 224, 144, 0.7)",
  "rgba(171, 217, 233, 0.7)",
  "rgba(116, 173, 209, 0.7)",
  "rgba(69, 117, 180, 0.7)",
  "rgba(49, 54, 149, 0.7)",
  "rgba(165, 0, 38, 0.7)",
  "rgba(215, 48, 39, 0.7)",
  "rgba(244, 109, 67, 0.7)",
  "rgba(253, 174, 97, 0.7)",
  "rgba(254, 224, 139, 0.7)",
  "rgba(255, 255, 191, 0.7)",
  "rgba(217, 239, 139, 0.7)",
  "rgba(166, 217, 106, 0.7)",
  "rgba(102, 189, 99, 0.7)",
  "rgba(26, 152, 80, 0.7)",
  "rgba(0, 104, 55, 0.7)"
]
