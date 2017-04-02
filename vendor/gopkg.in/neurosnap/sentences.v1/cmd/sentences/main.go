package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"os"
	"strings"

	"github.com/neurosnap/sentences/english"
	"github.com/spf13/cobra"
)

// VERSION is the semantic version number
var VERSION string

// COMMITHASH is the git commit hash value
var COMMITHASH string

var ver bool
var fname string
var delim string

// Primary command for sentence tokenization
var sentencesCmd = &cobra.Command{
	Use:   "sentences",
	Short: "Sentence tokenizer",
	Long:  "A utility that will break up a blob of text into sentences.",
	Run: func(cmd *cobra.Command, args []string) {
		var text []byte
		var err error

		if ver {
			fmt.Println(VERSION)
			fmt.Println(COMMITHASH)
			return
		}

		if fname != "" {
			text, err = ioutil.ReadFile(fname)
			if err != nil {
				panic(err)
			}
		} else {
			stat, err := os.Stdin.Stat()
			if err != nil {
				panic(err)
			}

			if (stat.Mode() & os.ModeCharDevice) != 0 {
				return
			}

			reader := bufio.NewReader(os.Stdin)
			text, err = ioutil.ReadAll(reader)
			if err != nil {
				panic(err)
			}
		}

		tokenizer, err := english.NewSentenceTokenizer(nil)
		if err != nil {
			panic(err)
		}

		sentences := tokenizer.Tokenize(string(text))
		for _, s := range sentences {
			text := strings.Join(strings.Fields(s.Text), " ")

			text = strings.Join([]string{text, delim}, "")
			fmt.Printf("%s", text)
		}
	},
}

func main() {
	sentencesCmd.Flags().BoolVarP(&ver, "version", "v", false, "Get current version of sentences")
	sentencesCmd.Flags().StringVarP(&fname, "file", "f", "", "Read file as source input instead of stdin")
	sentencesCmd.Flags().StringVarP(&delim, "delimiter", "d", "\n", "Delimiter used to demarcate sentence boundaries")

	if err := sentencesCmd.Execute(); err != nil {
		fmt.Print(err)
	}
}
