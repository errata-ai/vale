package code

import (
	"encoding/json"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"testing"
)

func toJSON(comments []Comment) string {
	j, _ := json.MarshalIndent(comments, "", "    ")
	return string(j)
}

func TestComments(t *testing.T) {
	var cleaned []fs.DirEntry

	cases, err := os.ReadDir("../../testdata/comments/in")
	if err != nil {
		t.Error(err)
	}

	for _, f := range cases {
		if f.Name() == ".DS_Store" {
			continue
		}
		cleaned = append(cleaned, f)
	}

	for i, f := range cleaned {
		b, err1 := os.ReadFile(fmt.Sprintf("../../testdata/comments/in/%s", f.Name()))
		if err1 != nil {
			t.Error(err1)
		}

		lang, err2 := getLanguageFromExt(filepath.Ext(f.Name()))
		if err2 != nil {
			t.Fatal(err2)
		}

		comments, err3 := getComments(b, lang)
		if err3 != nil {
			t.Fatal(err3)
		}
		comments = coalesce(comments)

		b2, err4 := os.ReadFile(fmt.Sprintf("../../testdata/comments/out/%d.json", i))
		if err4 != nil {
			t.Fatal(err4)
		}

		markup := toJSON(comments)
		if markup != string(b2) {
			bin := filepath.Join("..", "..", "bin", fmt.Sprintf("%d.json", i))
			_ = os.WriteFile(bin, []byte(markup), os.ModePerm)
			t.Errorf("%s", markup)
		}
	}
}
