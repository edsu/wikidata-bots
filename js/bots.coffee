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
  url = "stats/#{period}.json"
  $.getJSON url, (stats) ->
    drawChart(stats)
    $(".nav li").removeClass("active")
    $("#period-#{ period }").addClass("active")

drawChart = (stats, selected) ->
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
      newSelected = $(ev.target).data('dataset')
      if newSelected != selected
        drawChart(stats, newSelected)
    (ev) ->
      $(ev.target).css('font-weight', 'normal')
      drawChart(stats)
  )

makeData = (stats, selected) ->
  datasets = []
  for name, botStats of stats
    color = colors[datasets.length]
    if selected and selected != name
      color = color.replace('0.7', '0.05')

    data = []
    hasData = false
    total = 0
    for row in botStats
      if row[1] > 0
        hasData = true
      data.push(row[1])
      total += row[1]
    if hasData
      datasets.push(name: name, strokeColor: color, data: data, total: total)

  datasets.sort (a, b) ->
    if a.total < b.total
      return 1
    else if a.total > b.total
      return -1
    else
      return 0

  labels = makeLabels(stats)
  return labels: labels, datasets: datasets

makeLabels = (stats) ->
  count = 0
  labels = []
  for name, data of stats
    for row in data
      if count % 10 == 0
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
  t = d.getUTCFullYear() + '-' + pad(d.getUTCMonth() + 1) + '-' + pad(d.getUTCDate())
  if period == "hour"
    t += ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes())
  return t
    
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
  "rgba(0, 104, 55, 0.7)",
  "rgba(166, 217, 106, 0.7)",
  "rgba(102, 189, 99, 0.7)",
  "rgba(26, 152, 80, 0.7)",
  "rgba(0, 104, 55, 0.7)"
  "rgba(26, 26, 26, 0.7)",
  "rgba(165, 0, 38, 0.7)",
  "rgba(215, 48, 39, 0.7)",
  "rgba(244, 109, 67, 0.7)",
  "rgba(253, 174, 97, 0.7)",
  "rgba(254, 224, 144, 0.7)",
  "rgba(171, 217, 233, 0.7)",

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
]

