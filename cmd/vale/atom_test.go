package main

import (
	"testing"
)

var feed = "https://github.com/errata-ai/Joblint/releases.atom"

func TestConvert(t *testing.T) {
	parsed, err := parseAtom(feed)
	if err != nil {
		t.Error(err)
	}

	dt1, err := toTime(parsed.Updated)
	if err != nil {
		t.Error(err)
	}

	dt2, err := toTime("2021-03-07T12:21:29-07:00")
	if err != nil {
		t.Error(err)
	}

	if !dt2.UTC().Before(dt1.UTC()) {
		t.Error("bad date")
	}
}
