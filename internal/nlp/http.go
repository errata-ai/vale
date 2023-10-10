package nlp

import (
	"encoding/json"
	"io"
	"net/http"
	"net/url"

	"github.com/jdkato/twine/nlp/tag"
)

type SegmentResult struct {
	Sents []string
}

type TagResult struct {
	Tokens []tag.Token
}

func post(url string) ([]byte, error) {
	var body []byte

	resp, err := http.Post(url, "application/x-www-form-urlencoded", nil) //nolint:gosec,noctx
	if err != nil {
		return body, err
	}
	defer resp.Body.Close()

	body, err = io.ReadAll(resp.Body)
	if err != nil {
		return body, err
	}

	return body, nil
}

func doSegment(text, lang, apiURL string) (SegmentResult, error) {
	var result SegmentResult

	data := url.Values{"lang": {lang}, "text": {text}}
	path := apiURL + "/segment?" + data.Encode()

	body, err := post(path)
	if err != nil {
		return result, err
	}

	err = json.Unmarshal(body, &result)
	if err != nil {
		return result, err
	}

	return result, nil
}

func pos(text, lang, apiURL string) (TagResult, error) {
	var result TagResult

	data := url.Values{"lang": {lang}, "text": {text}}
	path := apiURL + "/tag?" + data.Encode()

	body, err := post(path)
	if err != nil {
		return result, err
	}

	err = json.Unmarshal(body, &result)
	if err != nil {
		return result, err
	}

	return result, nil
}
