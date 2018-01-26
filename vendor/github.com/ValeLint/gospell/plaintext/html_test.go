package plaintext

import (
	"strings"
	"testing"
)

func TestHTML(t *testing.T) {
	cases := []struct {
		text string
		want string
	}{
		{
			`1
2
3<script>
4
5
6</script>
7`,
			`1
2
3



7`,
		},
	}
	for pos, tt := range cases {
		mt, err := NewHTMLText()
		if err != nil {
			t.Fatalf("Unable to run test: %s", err)
		}
		got := string(mt.Text([]byte(tt.text)))
		lenGot := len(strings.Split(got, "\n"))
		lenWant := len(strings.Split(tt.want, "\n"))
		if lenGot != lenWant {
			t.Errorf("Test %d failed: want %d got %d lines ", pos, lenWant, lenGot)
		}
		if tt.want != got {
			t.Errorf("Test %d failed:  want %q, got %q", pos, tt.want, got)
		}

	}
}
