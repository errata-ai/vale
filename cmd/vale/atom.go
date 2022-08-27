package main

import (
	"encoding/xml"
	"errors"
	"io"
	"net/http"
	"time"
)

type Text struct {
	Type string `xml:"type,attr"`
	Body string `xml:",chardata"`
}

type Feed struct {
	XMLName xml.Name `xml:"http://www.w3.org/2005/Atom feed"`
	Title   string   `xml:"title"`
	ID      string   `xml:"id"`
	Link    []Link   `xml:"link"`
	Updated string   `xml:"updated"`
	Author  *Person  `xml:"author"`
	Entry   []*Entry `xml:"entry"`
}

type Link struct {
	Href string `xml:"href,attr"`
}

type Person struct {
	Name     string `xml:"name"`
	URI      string `xml:"uri,omitempty"`
	Email    string `xml:"email,omitempty"`
	InnerXML string `xml:",innerxml"`
}

type Entry struct {
	Title     string  `xml:"title"`
	ID        string  `xml:"id"`
	Link      []Link  `xml:"link"`
	Published string  `xml:"published"`
	Updated   string  `xml:"updated"`
	Author    *Person `xml:"author"`
	Summary   *Text   `xml:"summary"`
	Content   *Text   `xml:"content"`
}

func toTime(s string) (time.Time, error) {
	return time.Parse(time.RFC3339, s)
}

func parseAtom(feed string) (Feed, error) {
	a := Feed{}

	resp, err := http.Get(feed)
	if err != nil {
		return a, err
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusOK {
		b, err := io.ReadAll(resp.Body)
		if err != nil {
			return a, err
		}
		err = xml.Unmarshal(b, &a)
		return a, err
	}

	return a, errors.New("bad status")
}
