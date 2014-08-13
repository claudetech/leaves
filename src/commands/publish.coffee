path = require 'path'
ghPublisher = require path.join(path.dirname(__dirname), 'gh-publisher')

exports.run = (opts) ->
  console.log 'Starting to publish your website.'
  ghPublisher.publish process.cwd(), opts, (err, remoteUrl) ->
    return console.log(err) unless err == null
    pageUrl = ghPublisher.pageUrl(remoteUrl)
    console.log "Your website has been published at #{pageUrl}"
    console.log "The first time, it can take up to 10 minutes to show up, so be patient."
