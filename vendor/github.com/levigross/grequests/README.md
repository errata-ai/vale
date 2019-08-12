# GRequests
A Go "clone" of the great and famous Requests library

[![Build Status](https://travis-ci.org/levigross/grequests.svg?branch=master)](https://travis-ci.org/levigross/grequests) [![GoDoc](https://godoc.org/github.com/levigross/grequests?status.svg)](https://godoc.org/github.com/levigross/grequests)
[![Coverage Status](https://coveralls.io/repos/levigross/grequests/badge.svg)](https://coveralls.io/r/levigross/grequests)
[![Join the chat at https://gitter.im/levigross/grequests](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/levigross/grequests?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

License
======

GRequests is licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for the full license text

Features
========

- Responses can be serialized into JSON and XML
- Easy file uploads
- Easy file downloads
- Support for the following HTTP verbs `GET, HEAD, POST, PUT, DELETE, PATCH, OPTIONS`

Install
=======
`go get -u github.com/levigross/grequests`

Usage
======
`import "github.com/levigross/grequests"`

Basic Examples
=========
Basic GET request:

```go
resp, err := grequests.Get("http://httpbin.org/get", nil)
// You can modify the request by passing an optional RequestOptions struct

if err != nil {
	log.Fatalln("Unable to make request: ", err)
}

fmt.Println(resp.String())
// {
//   "args": {},
//   "headers": {
//     "Accept": "*/*",
//     "Host": "httpbin.org",
```

If an error occurs all of the other properties and methods of a `Response` will be `nil`

Quirks
=======
## Request Quirks

When passing parameters to be added to a URL, if the URL has existing parameters that *_contradict_* with what has been passed within `Params` – `Params` will be the "source of authority" and overwrite the contradicting URL parameter.

Lets see how it works...

```go
ro := &RequestOptions{
	Params: map[string]string{"Hello": "Goodbye"},
}
Get("http://httpbin.org/get?Hello=World", ro)
// The URL is now http://httpbin.org/get?Hello=Goodbye
```

## Response Quirks

Order matters! This is because `grequests.Response` is implemented as an `io.ReadCloser` which proxies the *http.Response.Body* `io.ReadCloser` interface. It also includes an internal buffer for use in `Response.String()` and `Response.Bytes()`.

Here are a list of methods that consume the *http.Response.Body* `io.ReadCloser` interface.

- Response.JSON
- Response.XML
- Response.DownloadToFile
- Response.Close
- Response.Read

The following methods make use of an internal byte buffer

- Response.String
- Response.Bytes

In the code below, once the file is downloaded – the `Response` struct no longer has access to the request bytes

```go
response := Get("http://some-wonderful-file.txt", nil)

if err := response.DownloadToFile("randomFile"); err != nil {
	log.Println("Unable to download file: ", err)
}

// At this point the .String and .Bytes method will return empty responses

response.Bytes() == nil // true
response.String() == "" // true

```

But if we were to call `response.Bytes()` or `response.String()` first, every operation will succeed until the internal buffer is cleared:

```go
response := Get("http://some-wonderful-file.txt", nil)

// This call to .Bytes caches the request bytes in an internal byte buffer – which can be used again and again until it is cleared
response.Bytes() == `file-bytes`
response.String() == "file-string"

// This will work because it will use the internal byte buffer
if err := resp.DownloadToFile("randomFile"); err != nil {
	log.Println("Unable to download file: ", err)
}

// Now if we clear the internal buffer....
response.ClearInternalBuffer()

// At this point the .String and .Bytes method will return empty responses

response.Bytes() == nil // true
response.String() == "" // true
```
