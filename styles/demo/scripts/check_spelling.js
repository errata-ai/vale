var spellChecker = require('spellchecker')

var alerts = []
var text = process.argv[2]
var words = text.split(/([^\s]+)/)
var word = ''
var idx = 0

for (var i = 0; i < words.length; i++) {
  word = words[i]
  if (spellChecker.isMisspelled(word)) {
    idx = text.indexOf(word)
    alerts.push({
      'Check': 'demo.CheckSpelling',
      'Span': [idx, idx + word.length],
      'Message': "'" + word + "' is misspelled",
      'Severity': 'error'
    })
  }
}

process.stdout.write(JSON.stringify(alerts))
