var createCorpus = function(options){
  options = options || {};
  var corpus = {};
  corpus.settings = {
    length: options.length || 2
  };
  corpus.corpus = {};
  corpus.keys = [];
  return corpus;
};

var add = function(corpus, sentence){
  var length = corpus.settings.length;
  var tokens = sentence.replace(/[^\w\s]+/g, "").trim().replace(/\s+/g, " ").split(" ");
  for (var i = 0; i < tokens.length - length + 1; i++){
    var key = [];
    for (var n = i; n < i + (length - 1); n++){
      key.push(tokens[n]);
    }
    var stringKey = key.join(" ");
    if (corpus.corpus[stringKey]) {
      corpus.corpus[stringKey].push(tokens[n]);
    } else {
      corpus.corpus[stringKey] = [tokens[n]];
      corpus.keys.push(stringKey);
    }
  }

  return corpus;
};

var rand = function(arr){
  return arr[Math.floor(Math.random() * arr.length)];
};

var generate = function(corpus, n){
  var lastToken = rand(corpus.keys);
  var sentence = lastToken.split(" ");
  var lastToken = lastToken.split(" ");
  var newToken;
  n--;

  do {
    newToken = rand(corpus.corpus[lastToken.join(" ")]);
    sentence.push(newToken);
    lastToken.shift();
    lastToken.push(newToken);

    if (!corpus.corpus[lastToken.join(" ")]) return sentence.join(" ");
  } while (n--);

  return sentence.join(" ");
};

module.exports = { createCorpus: createCorpus, add: add, generate: generate };
