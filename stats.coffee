#!/usr/bin/env coffee

STATHAT_TOKEN = "ehs@pobox.com"

fs = require('fs')
async = require('async')
stathat = require('stathat')
requests = require('request')
wikichanges = require('wikichanges')

refreshRate = 1000 * 60 * 30
bots = JSON.parse(fs.readFileSync('bots.json'))

saveBots = ->
  console.log "saving bots"

  # make sure not to lose any stathat bot ids added to the bots.json 
  oldBots = JSON.parse(fs.readFileSync('bots.json'))
  for name, id of oldBots
    bots[name] = oldBots[name]

  # now save them
  fs.writeFileSync('bots.json', JSON.stringify(bots, null, 2))
  setTimeout(saveBots, refreshRate)

saveAllStats = ->
  console.log "saving stats"
  saveStats('hour')
  saveStats('day')
  saveStats('week')
  saveStats('month')
  setTimeout(saveAllStats, refreshRate)

saveStats = (period) ->
  try
    names = (name for name, id of bots)
    getStats = makeStatsFetcher(name, period)
    async.mapSeries names, getStats, (e, result) ->
      stats = {}
      for r in result
        name = r[0]
        data = r[1..-1]
        stats[name] = data
      fs.writeFile('stats/' + period + '.json', JSON.stringify(stats))
  catch error
    console.log "error when fetching stats: #{error}" 

makeStatsFetcher = (name, period) ->
  return (name, callback) ->
    id = bots[name]
    url = "http://www.stathat.com/stats/#{id}/csv/#{period}"
    console.log "fetching #{url}"
    requests.get {url: url, json: true}, (err, resp, body) ->
      rows = [name]
      lines = body.split("\n")
      # remove column header
      lines.shift()
      # remove trailing non-row
      lines.pop()
      for line in lines
        cols = line.split(",")
        rows.push(cols.map (s) -> parseInt(s))
      callback(null, rows)

tally = (change) ->
  stathat.trackEZCount STATHAT_TOKEN, change.user, 1, (status, json) ->
    if not bots[change.user]
      bots[change.user] = null
    console.log change.user, status

main = ->
  w = new wikichanges.WikiChanges(wikipedias: ["#wikidata.wikipedia"])
  w.listen (change) ->
    if change.robot and change.channel == '#wikidata.wikipedia'
      tally change
  saveBots()
  saveAllStats()

main()

