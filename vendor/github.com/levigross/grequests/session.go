package grequests

import "net/http"

// Session allows a user to make use of persistent cookies in between
// HTTP requests
type Session struct {
	// RequestOptions is global options
	RequestOptions *RequestOptions

	// HTTPClient is the client that we will use to request the resources
	HTTPClient *http.Client
}

// NewSession returns a session struct which enables can be used to maintain establish a persistent state with the
// server
// This function will set UseCookieJar to true as that is the purpose of using the session
func NewSession(ro *RequestOptions) *Session {
	if ro == nil {
		ro = &RequestOptions{}
	}

	ro.UseCookieJar = true

	return &Session{RequestOptions: ro, HTTPClient: BuildHTTPClient(*ro)}
}

// Combine session options and request options
// 1. UserAgent
// 2. Host
// 3. Auth
// 4. Headers
func (s *Session) combineRequestOptions(ro *RequestOptions) *RequestOptions {
	if ro == nil {
		ro = &RequestOptions{}
	}

	if ro.UserAgent == "" && s.RequestOptions.UserAgent != "" {
		ro.UserAgent = s.RequestOptions.UserAgent
	}

	if ro.Host == "" && s.RequestOptions.Host != "" {
		ro.Host = s.RequestOptions.Host
	}

	if ro.Auth == nil && s.RequestOptions.Auth != nil {
		ro.Auth = s.RequestOptions.Auth
	}

	if len(s.RequestOptions.Headers) > 0 || len(ro.Headers) > 0 {
		headers := make(map[string]string)
		for k, v := range s.RequestOptions.Headers {
			headers[k] = v
		}
		for k, v := range ro.Headers {
			headers[k] = v
		}
		ro.Headers = headers
	}
	return ro
}

// Get takes 2 parameters and returns a Response Struct. These two options are:
// 	1. A URL
// 	2. A RequestOptions struct
// If you do not intend to use the `RequestOptions` you can just pass nil
// A new session is created by calling NewSession with a request options struct
func (s *Session) Get(url string, ro *RequestOptions) (*Response, error) {
	ro = s.combineRequestOptions(ro)
	return doSessionRequest("GET", url, ro, s.HTTPClient)
}

// Put takes 2 parameters and returns a Response struct. These two options are:
// 	1. A URL
// 	2. A RequestOptions struct
// If you do not intend to use the `RequestOptions` you can just pass nil
// A new session is created by calling NewSession with a request options struct
func (s *Session) Put(url string, ro *RequestOptions) (*Response, error) {
	ro = s.combineRequestOptions(ro)
	return doSessionRequest("PUT", url, ro, s.HTTPClient)
}

// Patch takes 2 parameters and returns a Response struct. These two options are:
// 	1. A URL
// 	2. A RequestOptions struct
// If you do not intend to use the `RequestOptions` you can just pass nil
// A new session is created by calling NewSession with a request options struct
func (s *Session) Patch(url string, ro *RequestOptions) (*Response, error) {
	ro = s.combineRequestOptions(ro)
	return doSessionRequest("PATCH", url, ro, s.HTTPClient)
}

// Delete takes 2 parameters and returns a Response struct. These two options are:
// 	1. A URL
// 	2. A RequestOptions struct
// If you do not intend to use the `RequestOptions` you can just pass nil
// A new session is created by calling NewSession with a request options struct
func (s *Session) Delete(url string, ro *RequestOptions) (*Response, error) {
	ro = s.combineRequestOptions(ro)
	return doSessionRequest("DELETE", url, ro, s.HTTPClient)
}

// Post takes 2 parameters and returns a Response channel. These two options are:
// 	1. A URL
// 	2. A RequestOptions struct
// If you do not intend to use the `RequestOptions` you can just pass nil
// A new session is created by calling NewSession with a request options struct
func (s *Session) Post(url string, ro *RequestOptions) (*Response, error) {
	ro = s.combineRequestOptions(ro)
	return doSessionRequest("POST", url, ro, s.HTTPClient)
}

// Head takes 2 parameters and returns a Response channel. These two options are:
// 	1. A URL
// 	2. A RequestOptions struct
// If you do not intend to use the `RequestOptions` you can just pass nil
// A new session is created by calling NewSession with a request options struct
func (s *Session) Head(url string, ro *RequestOptions) (*Response, error) {
	ro = s.combineRequestOptions(ro)
	return doSessionRequest("HEAD", url, ro, s.HTTPClient)
}

// Options takes 2 parameters and returns a Response struct. These two options are:
// 	1. A URL
// 	2. A RequestOptions struct
// If you do not intend to use the `RequestOptions` you can just pass nil
// A new session is created by calling NewSession with a request options struct
func (s *Session) Options(url string, ro *RequestOptions) (*Response, error) {
	ro = s.combineRequestOptions(ro)
	return doSessionRequest("OPTIONS", url, ro, s.HTTPClient)
}

// CloseIdleConnections closes the idle connections that a session client may make use of
func (s *Session) CloseIdleConnections() {
	s.HTTPClient.Transport.(*http.Transport).CloseIdleConnections()
}
