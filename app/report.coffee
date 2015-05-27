querystring = require('querystring')
http = require('http')
fs = require('fs')
request = require('request')

class Report
  HOST = ""
  ID = ""

  constructor: () ->
    @config()

  post: (beacons) ->
    request.post(
      HOST,
      { json: @transform(beacons) },
      (error, response, body) ->
        if !error && response.statusCode == 200
          console.log body
    )

  transform: (beacons) ->
    beaconData = (for id, beacon of beacons
      { uuid: beacon.uuid,
      exits: beacon.counter,
      battery: beacon.batteryLevel })

    { id: ID,
    timestamp: (new Date()),
    beacons: beaconData }

  config: () ->
    fs.readFile './config.json', 'utf-8', (err, data) ->
      if err
        console.log "FATAL An error occurred trying to read in the file: " + err
        process.exit -2
      if data
        config = JSON.parse data
        HOST = config.host
        ID = config.id
      else
        console.log "Config failed."
        process.exit -1

exports.Report = Report
