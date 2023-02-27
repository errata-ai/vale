package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"path/filepath"
	"strings"
)

// Response is returned after an action.
type Response struct {
	Msg     string
	Error   string
	Success bool
}

func pluralize(s string, n int) string {
	if n != 1 {
		return s + "s"
	}
	return s
}

func getJSON(data interface{}) string {
	b, err := json.MarshalIndent(data, "", "  ")
	if err != nil {
		return err.Error()
	}
	return string(b)
}

func fetchJSON(url string) ([]byte, error) {
	resp, err := http.Get(url)
	if err != nil {
		return []byte{}, err
	}
	return io.ReadAll(resp.Body)
}

func printJSON(t interface{}) error {
	b, err := json.MarshalIndent(t, "", "    ")
	if err != nil {
		fmt.Println("{}")
		return err
	}
	fmt.Println(string(b))
	return nil
}

// Send a JSON response after a local action.
func sendResponse(msg string, err error) error {
	resp := Response{Msg: msg, Success: err == nil}
	if !resp.Success {
		resp.Error = err.Error()
	}
	return printJSON(resp)
}

func fileNameWithoutExt(fileName string) string {
	base := filepath.Base(fileName)
	return strings.TrimSuffix(base, filepath.Ext(base))
}
