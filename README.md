wikidata-bots
=============

Creates a graph of active Wikidata bots by hour, day, week and month.

Install
-------

To install you'll need nodejs and coffee-script

1. npm install
1. coffee stats.coffee 
1. coffee server.coffee
1. open http://localhost:8080 in your browser

stats.coffee 
------------

This script will listen for changes announced by mediawiki in
irc://irc.wikimedia.org/wikidata.wikpedia and will post changes
to stathat.com. If you plan on running this you'll want to set
STATAHT_TOKEN in stats.coffee to your own token.

server.coffee
-------------

This is a very simple HTTP server for serving up the static html, javascript,
css files. You should be able to use Apache to serve the directory up as well.

License
-------

* CC0
