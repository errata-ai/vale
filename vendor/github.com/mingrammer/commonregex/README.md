<br><br>

<h1 align="center">CommonRegex</h1>

<p align="center">
  <a href="/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg"/></a>
  <a href="https://app.fossa.io/projects/git%2Bgithub.com%2Fmingrammer%2Fcommonregex?ref=badge_shield" alt="FOSSA Status"><img src="https://app.fossa.io/api/projects/git%2Bgithub.com%2Fmingrammer%2Fcommonregex.svg?type=shield"/></a>
  <a href="https://godoc.org/github.com/mingrammer/commonregex"><img src="https://godoc.org/github.com/mingrammer/commonregex?status.svg"/></a>
  <a href="https://goreportcard.com/report/github.com/mingrammer/commonregex"><img src="https://goreportcard.com/badge/github.com/mingrammer/commonregex"/></a>
  <a href="https://travis-ci.org/mingrammer/commonregex"><img src="https://travis-ci.org/mingrammer/commonregex.svg?branch=master"/></a>
  <a href="https://codecov.io/gh/mingrammer/commonregex"><img src="https://codecov.io/gh/mingrammer/commonregex/branch/master/graph/badge.svg" /></a>
</p>

<p align="center">
  A collection of often used regular expressions for Go
</p>

<br><br><br>

> Inspired by [CommonRegex](https://github.com/madisonmay/CommonRegex)

This is a collection of often used regular expressions. It provides these as simple functions for getting the matched strings corresponding to specific patterns.

## Installation
```shell
go get github.com/mingrammer/commonregex
```

## Usage

```go
import (
    cregex "github.com/mingrammer/commonregex"
)

func main() {
    text := `John, please get that article on www.linkedin.com to me by 5:00PM on Jan 9th 2012. 4:00 would be ideal, actually. If you have any questions, You can reach me at (519)-236-2723x341 or get in touch with my associate at harold.smith@gmail.com`

    dateList := cregex.Date(text)
    // ['Jan 9th 2012']
    timeList := cregex.Time(text)
    // ['5:00PM', '4:00']
    linkList := cregex.Links(text)
    // ['www.linkedin.com', 'harold.smith@gmail.com']
    phoneList := cregex.PhonesWithExts(text)  
    // ['(519)-236-2723x341']
    emailList := cregex.Emails(text)
    // ['harold.smith@gmail.com']
}
```

## Features

* Date
* Time
* Phone
* Phones with exts
* Link
* Email
* IPv4
* IPv6
* IP
* Ports without well-known (not known ports)
* Price
* Hex color
* Credit card
* VISA credit card
* MC credit card
* ISBN 10/13
* BTC address
* Street address
* Zip code
* Po box
* SSN
* MD5
* SHA1
* SHA256
* GUID
* MAC address
* IBAN
* Git Repository

## Thanks to :heart:

* [@cschoede](https://github.com/cschoede)
* [@schigh](https://github.com/schigh)
* [@emaraschio](https://github.com/emaraschio)
* [@mamal72](https://github.com/mamal72)
* [@ahmdrz](https://github.com/ahmdrz)
* [@fakenine](https://github.com/fakenine)
* [@Bill-Park](https://github.com/Bill-Park)
* [@jakewarren](https://github.com/jakewarren)

## License

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fmingrammer%2Fcommonregex.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fmingrammer%2Fcommonregex?ref=badge_large)
