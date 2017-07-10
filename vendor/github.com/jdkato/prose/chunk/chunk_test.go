package chunk

import (
	"fmt"
	"testing"

	"github.com/jdkato/prose/tag"
	"github.com/jdkato/prose/tokenize"
)

func Example() {
	txt := "Go is a open source programming language created at Google."

	words := tokenize.TextToWords(txt)
	tagger := tag.NewPerceptronTagger()

	fmt.Println(Chunk(tagger.Tag(words), TreebankNamedEntities))
	// Output: [Go Google]
}

func TestChunk(t *testing.T) {
	text := `
Property surveyors are getting gloomier about the state of the housing market, according to the Royal Institution of Chartered Surveyors (Rics).
Its latest monthly survey shows that stock levels are at a new record low.
The number of people interested in buying a property - and the number of sales - were also "stagnant" in March, it said.
However, because of the shortage of housing, it said prices in many parts of the UK are continuing to accelerate.
While prices carry on falling in central London, Rics said that price rises in the North West were "particularly strong".
Most surveyors across the country still expect prices to rise over the next 12 months, but by a smaller majority than in February.
But on average, each estate agent has just 43 properties for sale on its books, the lowest number recorded since the methodology began in 1994.
"High-end sale properties in central London remain under pressure, while the wider residential market continues to be underpinned by a lack of stock," said Simon Rubinsohn, Rics chief economist.
"For the time being, it is hard to see any major impetus for change in the market, something also being reflected in the flat trend in transaction levels."
Earlier this week, the Office for National Statistics said house prices grew at 5.8% in the year to February, a small rise on the previous month.
However, both Nationwide and the Halifax have said that house price inflation is moderating.
Separate figures from the Bank of England suggested that lenders are offering fewer loans.
Banks reported a tightening of lending criteria, and a drop in loan approval rates.
A significant majority also reported falling demand.
Hansen Lu, property economist with Capital Economics, said that pointed to an "even more gloomy picture than the Rics survey".

The above articile was retrieved from the B.B.C. News website on 13 April 2017.
It was also reported on BBC Radio 4 and BBC Radio 5 Live.
`
	expected := []string{
		"Royal Institution of Chartered Surveyors",
		"Rics",
		"March",
		"UK",
		"London",
		"Rics",
		"North West",
		"February",
		"London",
		"Simon Rubinsohn",
		"Rics",
		"Office for National Statistics",
		"February",
		"Nationwide",
		"Halifax",
		"Bank of England",
		"Hansen Lu",
		"Capital Economics",
		"Rics",
		"B.B.C. News",
		"13 April 2017",
		"BBC Radio 4",
		"BBC Radio 5 Live",
	}

	words := tokenize.TextToWords(text)
	tagger := tag.NewPerceptronTagger()
	tagged := tagger.Tag(words)

	for i, chunk := range Chunk(tagged, TreebankNamedEntities) {
		if i >= len(expected) {
			t.Error("ERROR unexpected result: " + chunk)
		} else {
			if chunk != expected[i] {
				t.Error("ERROR", chunk, "!=", expected[i])
			}
		}
	}
}
