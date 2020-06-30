package commonregex

import "regexp"

// Regular expression patterns
const (
	DatePattern           = `(?i)(?:[0-3]?\d(?:st|nd|rd|th)?\s+(?:of\s+)?(?:jan\.?|january|feb\.?|february|mar\.?|march|apr\.?|april|may|jun\.?|june|jul\.?|july|aug\.?|august|sep\.?|september|oct\.?|october|nov\.?|november|dec\.?|december)|(?:jan\.?|january|feb\.?|february|mar\.?|march|apr\.?|april|may|jun\.?|june|jul\.?|july|aug\.?|august|sep\.?|september|oct\.?|october|nov\.?|november|dec\.?|december)\s+[0-3]?\d(?:st|nd|rd|th)?)(?:\,)?\s*(?:\d{4})?|[0-3]?\d[-\./][0-3]?\d[-\./]\d{2,4}`
	TimePattern           = `(?i)\d{1,2}:\d{2} ?(?:[ap]\.?m\.?)?|\d[ap]\.?m\.?`
	PhonePattern          = `(?:(?:\+?\d{1,3}[-.\s*]?)?(?:\(?\d{3}\)?[-.\s*]?)?\d{3}[-.\s*]?\d{4,6})|(?:(?:(?:\(\+?\d{2}\))|(?:\+?\d{2}))\s*\d{2}\s*\d{3}\s*\d{4})`
	PhonesWithExtsPattern = `(?i)(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*(?:[2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|(?:[2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?(?:[2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?(?:[0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(?:\d+)?)`
	LinkPattern           = `(?:(?:https?:\/\/)?(?:[a-z0-9.\-]+|www|[a-z0-9.\-])[.](?:[^\s()<>]+|\((?:[^\s()<>]+|(?:\([^\s()<>]+\)))*\))+(?:\((?:[^\s()<>]+|(?:\([^\s()<>]+\)))*\)|[^\s!()\[\]{};:\'".,<>?]))`
	EmailPattern          = `(?i)([A-Za-z0-9!#$%&'*+\/=?^_{|.}~-]+@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)`
	IPv4Pattern           = `(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)`
	IPv6Pattern           = `(?:(?:(?:[0-9A-Fa-f]{1,4}:){7}(?:[0-9A-Fa-f]{1,4}|:))|(?:(?:[0-9A-Fa-f]{1,4}:){6}(?::[0-9A-Fa-f]{1,4}|(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(?:\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(?:(?:[0-9A-Fa-f]{1,4}:){5}(?:(?:(?::[0-9A-Fa-f]{1,4}){1,2})|:(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(?:\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(?:(?:[0-9A-Fa-f]{1,4}:){4}(?:(?:(?::[0-9A-Fa-f]{1,4}){1,3})|(?:(?::[0-9A-Fa-f]{1,4})?:(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(?:\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(?:(?:[0-9A-Fa-f]{1,4}:){3}(?:(?:(?::[0-9A-Fa-f]{1,4}){1,4})|(?:(?::[0-9A-Fa-f]{1,4}){0,2}:(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(?:\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(?:(?:[0-9A-Fa-f]{1,4}:){2}(?:(?:(?::[0-9A-Fa-f]{1,4}){1,5})|(?:(?::[0-9A-Fa-f]{1,4}){0,3}:(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(?:\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(?:(?:[0-9A-Fa-f]{1,4}:){1}(?:(?:(?::[0-9A-Fa-f]{1,4}){1,6})|(?:(?::[0-9A-Fa-f]{1,4}){0,4}:(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(?:\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(?::(?:(?:(?::[0-9A-Fa-f]{1,4}){1,7})|(?:(?::[0-9A-Fa-f]{1,4}){0,5}:(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(?:\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(?:%.+)?\s*`
	IPPattern             = IPv4Pattern + `|` + IPv6Pattern
	NotKnownPortPattern   = `6[0-5]{2}[0-3][0-5]|[1-5][\d]{4}|[2-9][\d]{3}|1[1-9][\d]{2}|10[3-9][\d]|102[4-9]`
	PricePattern          = `[$]\s?[+-]?[0-9]{1,3}(?:(?:,?[0-9]{3}))*(?:\.[0-9]{1,2})?`
	HexColorPattern       = `(?:#?([0-9a-fA-F]{6}|[0-9a-fA-F]{3}))`
	CreditCardPattern     = `(?:(?:(?:\d{4}[- ]?){3}\d{4}|\d{15,16}))`
	VISACreditCardPattern = `4\d{3}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}`
	MCCreditCardPattern   = `5[1-5]\d{2}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}`
	BtcAddressPattern     = `[13][a-km-zA-HJ-NP-Z1-9]{25,34}`
	StreetAddressPattern  = `\d{1,4} [\w\s]{1,20}(?:street|st|avenue|ave|road|rd|highway|hwy|square|sq|trail|trl|drive|dr|court|ct|park|parkway|pkwy|circle|cir|boulevard|blvd)\W?`
	ZipCodePattern        = `\b\d{5}(?:[-\s]\d{4})?\b`
	PoBoxPattern          = `(?i)P\.? ?O\.? Box \d+`
	SSNPattern            = `(?:\d{3}-\d{2}-\d{4})`
	MD5HexPattern         = `[0-9a-fA-F]{32}`
	SHA1HexPattern        = `[0-9a-fA-F]{40}`
	SHA256HexPattern      = `[0-9a-fA-F]{64}`
	GUIDPattern           = `[0-9a-fA-F]{8}-?[a-fA-F0-9]{4}-?[a-fA-F0-9]{4}-?[a-fA-F0-9]{4}-?[a-fA-F0-9]{12}`
	ISBN13Pattern         = `(?:[\d]-?){12}[\dxX]`
	ISBN10Pattern         = `(?:[\d]-?){9}[\dxX]`
	MACAddressPattern     = `(([a-fA-F0-9]{2}[:-]){5}([a-fA-F0-9]{2}))`
	IBANPattern           = `[A-Z]{2}\d{2}[A-Z0-9]{4}\d{7}([A-Z\d]?){0,16}`
	GitRepoPattern        = `((git|ssh|http(s)?)|(git@[\w\.]+))(:(\/\/)?)([\w\.@\:/\-~]+)(\.git)(\/)?`
)

// Compiled regular expressions
var (
	DateRegex           = regexp.MustCompile(DatePattern)
	TimeRegex           = regexp.MustCompile(TimePattern)
	PhoneRegex          = regexp.MustCompile(PhonePattern)
	PhonesWithExtsRegex = regexp.MustCompile(PhonesWithExtsPattern)
	LinkRegex           = regexp.MustCompile(LinkPattern)
	EmailRegex          = regexp.MustCompile(EmailPattern)
	IPv4Regex           = regexp.MustCompile(IPv4Pattern)
	IPv6Regex           = regexp.MustCompile(IPv6Pattern)
	IPRegex             = regexp.MustCompile(IPPattern)
	NotKnownPortRegex   = regexp.MustCompile(NotKnownPortPattern)
	PriceRegex          = regexp.MustCompile(PricePattern)
	HexColorRegex       = regexp.MustCompile(HexColorPattern)
	CreditCardRegex     = regexp.MustCompile(CreditCardPattern)
	BtcAddressRegex     = regexp.MustCompile(BtcAddressPattern)
	StreetAddressRegex  = regexp.MustCompile(StreetAddressPattern)
	ZipCodeRegex        = regexp.MustCompile(ZipCodePattern)
	PoBoxRegex          = regexp.MustCompile(PoBoxPattern)
	SSNRegex            = regexp.MustCompile(SSNPattern)
	MD5HexRegex         = regexp.MustCompile(MD5HexPattern)
	SHA1HexRegex        = regexp.MustCompile(SHA1HexPattern)
	SHA256HexRegex      = regexp.MustCompile(SHA256HexPattern)
	GUIDRegex           = regexp.MustCompile(GUIDPattern)
	ISBN13Regex         = regexp.MustCompile(ISBN13Pattern)
	ISBN10Regex         = regexp.MustCompile(ISBN10Pattern)
	VISACreditCardRegex = regexp.MustCompile(VISACreditCardPattern)
	MCCreditCardRegex   = regexp.MustCompile(MCCreditCardPattern)
	MACAddressRegex     = regexp.MustCompile(MACAddressPattern)
	IBANRegex           = regexp.MustCompile(IBANPattern)
	GitRepoRegex        = regexp.MustCompile(GitRepoPattern)
)

func match(text string, regex *regexp.Regexp) []string {
	parsed := regex.FindAllString(text, -1)
	return parsed
}

// Date finds all date strings
func Date(text string) []string {
	return match(text, DateRegex)
}

// Time finds all time strings
func Time(text string) []string {
	return match(text, TimeRegex)
}

// Phones finds all phone numbers
func Phones(text string) []string {
	return match(text, PhoneRegex)
}

// PhonesWithExts finds all phone numbers with ext
func PhonesWithExts(text string) []string {
	return match(text, PhonesWithExtsRegex)
}

// Links finds all link strings
func Links(text string) []string {
	return match(text, LinkRegex)
}

// Emails finds all email strings
func Emails(text string) []string {
	return match(text, EmailRegex)
}

// IPv4s finds all IPv4 addresses
func IPv4s(text string) []string {
	return match(text, IPv4Regex)
}

// IPv6s finds all IPv6 addresses
func IPv6s(text string) []string {
	return match(text, IPv6Regex)
}

// IPs finds all IP addresses (both IPv4 and IPv6)
func IPs(text string) []string {
	return match(text, IPRegex)
}

// NotKnownPorts finds all not-known port numbers
func NotKnownPorts(text string) []string {
	return match(text, NotKnownPortRegex)
}

// Prices finds all price strings
func Prices(text string) []string {
	return match(text, PriceRegex)
}

// HexColors finds all hex color values
func HexColors(text string) []string {
	return match(text, HexColorRegex)
}

// CreditCards finds all credit card numbers
func CreditCards(text string) []string {
	return match(text, CreditCardRegex)
}

// BtcAddresses finds all bitcoin addresses
func BtcAddresses(text string) []string {
	return match(text, BtcAddressRegex)
}

// StreetAddresses finds all street addresses
func StreetAddresses(text string) []string {
	return match(text, StreetAddressRegex)
}

// ZipCodes finds all zip codes
func ZipCodes(text string) []string {
	return match(text, ZipCodeRegex)
}

// PoBoxes finds all po-box strings
func PoBoxes(text string) []string {
	return match(text, PoBoxRegex)
}

// SSNs finds all SSN strings
func SSNs(text string) []string {
	return match(text, SSNRegex)
}

// MD5Hexes finds all MD5 hex strings
func MD5Hexes(text string) []string {
	return match(text, MD5HexRegex)
}

// SHA1Hexes finds all SHA1 hex strings
func SHA1Hexes(text string) []string {
	return match(text, SHA1HexRegex)
}

// SHA256Hexes finds all SHA256 hex strings
func SHA256Hexes(text string) []string {
	return match(text, SHA256HexRegex)
}

// GUIDs finds all GUID strings
func GUIDs(text string) []string {
	return match(text, GUIDRegex)
}

// ISBN13s finds all ISBN13 strings
func ISBN13s(text string) []string {
	return match(text, ISBN13Regex)
}

// ISBN10s finds all ISBN10 strings
func ISBN10s(text string) []string {
	return match(text, ISBN10Regex)
}

// VISACreditCards finds all VISA credit card numbers
func VISACreditCards(text string) []string {
	return match(text, VISACreditCardRegex)
}

// MCCreditCards finds all MasterCard credit card numbers
func MCCreditCards(text string) []string {
	return match(text, MCCreditCardRegex)
}

// MACAddresses finds all MAC addresses
func MACAddresses(text string) []string {
	return match(text, MACAddressRegex)
}

// IBANs finds all IBAN strings
func IBANs(text string) []string {
	return match(text, IBANRegex)
}

// GitRepos finds all git repository addresses which have protocol prefix
func GitRepos(text string) []string {
	return match(text, GitRepoRegex)
}
