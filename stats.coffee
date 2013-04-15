#!/usr/bin/env coffee

fs = require('fs')
stathat = require('stathat')
requests = require('request')
wikichanges = require('wikichanges')

bots = JSON.parse(fs.readFileSync('bots.json'))

saveBots = ->
  fs.writeFileSync('bots.json', JSON.stringify(bots, null, 2))
  setTimeout(saveBots, 1000 * 10)

saveStats = ->
  for botName, botId of bots
    if botName and botId
      saveBotStats(botName, botId, 'hour')
      saveBotStats(botName, botId, 'day')
      saveBotStats(botName, botId, 'week')
      saveBotStats(botName, botId, 'month')

saveBotStats = (name, id, timeFrame) ->
  filename =  "stats/#{name}_#{timeFrame}.json"
  url = "http://www.stathat.com/stats/#{id}/csv/#{timeFrame}"
  requests.get url, json: true, (err, resp, body) ->
    rows = []
    lines = body.split("\n")
    # remove column header
    lines.shift()
    # remove trailing non-row
    lines.pop()
    for line in lines
      cols = line.split(",")
      rows.push(cols.map (s) -> parseInt(s))
    fs.writeFile(filename, JSON.stringify(rows, null, 2))

tally = (change) ->
  stathat.trackEZCount "ehs@pobox.com", change.user, 1, (status, json) ->
    if not bots[change.user]
      bots[change.user] = null
    console.log change.user, status

main = ->
  w = new wikichanges.WikiChanges(wikipedias: ["#wikidata.wikipedia"])
  w.listen (change) ->
    if change.robot and change.channel == '#wikidata.wikipedia'
      tally change
  saveBots()

saveStats()
