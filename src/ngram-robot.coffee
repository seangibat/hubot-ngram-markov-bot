ngram = require('../script/ngram')

record = (resp, robot) ->
  if resp.envelope.user.corpus == undefined
    resp.envelope.user.corpus = ngram.createCorpus()
  ngram.add(resp.envelope.user.corpus, resp.match.toString())
  robot.brain.save()

generate = (resp, robot) ->
  name = resp.match[1].toLowerCase().trim()
  num = Number(resp.match[2].toLowerCase().trim())
  user = robot.brain.userForName name

  unless user
    return resp.send "There is no corpus for #{name}"

  corpus = user.corpus

  unless corpus
    return resp.send "There is no corpus for #{name}"

  sentence = ngram.generate(corpus, num)
  resp.send "#{user.name}: #{sentence}"

module.exports = (robot) ->

  robot.hear /^[^!|\/].+/g, (resp) ->
    record(resp, robot)

  robot.hear /^!talklike\s(\w+)\s(\d+)/i, (resp) ->
    generate(resp, robot)


