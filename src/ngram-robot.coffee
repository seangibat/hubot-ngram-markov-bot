ngram = require('simple-ngram-markov')
ngramLength = 3

record = (resp, robot) ->
  if resp.envelope.user.model == undefined
    resp.envelope.user.model = ngram.createModel(ngramLength)
  ngram.addSentenceToModel(resp.envelope.user.model, resp.match.toString())
  robot.brain.save()

generate = (resp, robot) ->
  name = resp.match[1].toLowerCase().trim()
  if resp.match[2]
    num = Number(resp.match[2].trim())

  num = if num > 0 and num < 140 then num else Math.floor(Math.random()*30+5)
  user = robot.brain.userForName name

  unless user
    return resp.send "User named #{name} not found."

  model = user.model

  unless model
    return resp.send "There is no model for #{name}."

  sentence = ngram.generateSentence(model, num)
  resp.send "#{user.name}: #{sentence}"

module.exports = (robot) ->

  robot.hear /^[^!|\/].+/g, (resp) ->
    record(resp, robot)

  robot.hear /^!talklike\s(\w+)\s?(\d*)/i, (resp) ->
    generate(resp, robot)
