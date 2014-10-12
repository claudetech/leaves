_      = require 'lodash'
request = require 'request'
config = require './config'

defaults =
  icon_emoji: ":four_leaf_clover:"
  username: "Leaves"


exports.post = (json, callback) ->
  return unless config.get('slack.url')
  payload = _.extend {}, defaults, config.get('slack'), json
  delete payload.url
  request.post {url: config.get('slack.url'), json: payload}, callback
