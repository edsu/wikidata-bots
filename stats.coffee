#!/usr/bin/env coffee

fs = require('fs')
stathat = require('stathat')
wikichanges = require('wikichanges')

tally = (change) ->
  stathat.trackEZCount "ehs@pobox.com", change.user, 1, (status, json) ->
    console.log change.user, status

w = new wikichanges.WikiChanges(wikipedias: ["#wikidata.wikipedia"])
w.listen (change) ->
  if change.robot and change.channel == '#wikidata.wikipedia'
    tally change
