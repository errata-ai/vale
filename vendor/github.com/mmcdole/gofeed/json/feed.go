package json

import "encoding/json"

// Feed describes the structure for JSON Feed v1.0
// https://www.jsonfeed.org/version/1/
type Feed struct {
	Version     string  `json:"version"`                 // version (required, string) is the URL of the version of the format the feed uses
	Title       string  `json:"title,omitempty"`         // title (required, string) is the name of the feed
	HomePageURL string  `json:"home_page_url,omitempty"` // home_page_url (optional but strongly recommended, string) is the URL of the resource that the feed describes. This resource should be an HTML page
	FeedURL     string  `json:"feed_url,omitempty"`      // feed_url (optional but strongly recommended, string) is the URL of the feed, and serves as the unique identifier for the feed
	Description string  `json:"description,omitempty"`   // description (optional, string)
	UserComment string  `json:"user_comment,omitempty"`  // user_comment (optional, string) is a description of the purpose of the feed. This is for the use of people looking at the raw JSON, and should be ignored by feed readers.
	NextURL     string  `json:"next_url,omitempty"`      // next_url (optional, string) is the URL of a feed that provides the next n items. This allows for pagination
	Icon        string  `json:"icon,omitempty"`          // icon (optional, string) is the URL of an image for the feed suitable to be used in a timeline. It should be square and relatively large — such as 512 x 512
	Favicon     string  `json:"favicon,omitempty"`       // favicon (optional, string) is the URL of an image for the feed suitable to be used in a source list. It should be square and relatively small, but not smaller than 64 x 64
	Author      *Author `json:"author,omitempty"`        // author (optional, object) specifies the feed author. The author object has several members. These are all optional — but if you provide an author object, then at least one is required:
	Expired     bool    `json:"expired,omitempty"`       // expired (optional, boolean) says whether or not the feed is finished — that is, whether or not it will ever update again.
	Items       []*Item `json:"items"`                   // items is an array, and is required
	// TODO Hubs // hubs (very optional, array of objects) describes endpoints that can be used to subscribe to real-time notifications from the publisher of this feed. Each object has a type and url, both of which are required. See the section “Subscribing to Real-time Notifications” below for details.
	// TODO Extensions
}

func (f Feed) String() string {
	json, _ := json.MarshalIndent(f, "", "    ")
	return string(json)
}

// Item defines an item in the feed
type Item struct {
	ID            string         `json:"id,omitempty"`             // id (required, string) is unique for that item for that feed over time. If an id is presented as a number or other type, a JSON Feed reader must coerce it to a string. Ideally, the id is the full URL of the resource described by the item, since URLs make great unique identifiers.
	URL           string         `json:"url,omitempty"`            // url (optional, string) is the URL of the resource described by the item. It’s the permalink
	ExternalURL   string         `json:"external_url,omitempty"`   // external_url (very optional, string) is the URL of a page elsewhere. This is especially useful for linkblogs
	Title         string         `json:"title,omitempty"`          // title (optional, string) is plain text. Microblog items in particular may omit titles.
	ContentHTML   string         `json:"content_html,omitempty"`   // content_html and content_text are each optional strings — but one or both must be present. This is the HTML or plain text of the item. Important: the only place HTML is allowed in this format is in content_html. A Twitter-like service might use content_text, while a blog might use content_html. Use whichever makes sense for your resource. (It doesn’t even have to be the same for each item in a feed.)
	ContentText   string         `json:"content_text,omitempty"`   // Same as above
	Summary       string         `json:"summary,omitempty"`        // summary (optional, string) is a plain text sentence or two describing the item.
	Image         string         `json:"image,omitempty"`          // image (optional, string) is the URL of the main image for the item. This image may also appear in the content_html
	BannerImage   string         `json:"banner_image,omitempty"`   // banner_image (optional, string) is the URL of an image to use as a banner.
	DatePublished string         `json:"date_published,omitempty"` // date_published (optional, string) specifies the date in RFC 3339 format. (Example: 2010-02-07T14:04:00-05:00.)
	DateModified  string         `json:"date_modified,omitempty"`  // date_modified (optional, string) specifies the modification date in RFC 3339 format.
	Author        *Author        `json:"author,omitempty"`         // author (optional, object) has the same structure as the top-level author. If not specified in an item, then the top-level author, if present, is the author of the item.
	Tags          []string       `json:"tags,omitempty"`           // tags (optional, array of strings) can have any plain text values you want. Tags tend to be just one word, but they may be anything.
	Attachments   *[]Attachments `json:"attachments,omitempty"`    // attachments (optional, array) lists related resources. Podcasts, for instance, would include an attachment that’s an audio or video file. An individual item may have one or more attachments.
	// TODO Extensions
}

// Author defines the feed author structure. The author object has several members. These are all optional — but if you provide an author object, then at least one is required:
type Author struct {
	Name   string `json:"name,omitempty"`   // name (optional, string) is the author’s name.
	URL    string `json:"url,omitempty"`    // url (optional, string) is the URL of a site owned by the author
	Avatar string `json:"avatar,omitempty"` // avatar (optional, string) is the URL for an image for the author. It should be square and relatively large — such as 512 x 512
}

// Attachments defines the structure for related sources. Podcasts, for instance, would include an attachment that’s an audio or video file
type Attachments struct {
	URL               string `json:"url,omitempty"`                 // url (required, string) specifies the location of the attachment.
	MimeType          string `json:"mime_type,omitempty"`           // mime_type (required, string) specifies the type of the attachment, such as “audio/mpeg.”
	Title             string `json:"title,omitempty"`               // title (optional, string) is a name for the attachment. Important: if there are multiple attachments, and two or more have the exact same title (when title is present), then they are considered as alternate representations of the same thing. In this way a podcaster, for instance, might provide an audio recording in different formats.
	SizeInBytes       int64  `json:"size_in_bytes,omitempty"`       // size_in_bytes (optional, number) specifies how large the file is.
	DurationInSeconds int64  `json:"duration_in_seconds,omitempty"` // duration_in_seconds (optional, number) specifies how long it takes to listen to or watch, when played at normal speed.
}
