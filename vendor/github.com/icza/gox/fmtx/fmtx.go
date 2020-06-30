// This file contains general formatting utilities.

package fmtx

import (
	"fmt"
	"strconv"
)

// FormatInt formats an integer with grouping decimals, in decimal radix.
// Grouping signs are inserted after every groupSize digits, starting from the right.
// A groupingSize less than 1 will default to 3.
// Only ASCII grouping decimal signs are supported which may be provided with
// grouping.
//
// For details, see https://stackoverflow.com/a/31046325/1705598
func FormatInt(n int64, groupSize int, grouping byte) string {
	if groupSize < 1 {
		groupSize = 3
	}

	in := strconv.FormatInt(n, 10)
	numOfDigits := len(in)
	if n < 0 {
		numOfDigits-- // First character is the - sign (not a digit)
	}
	numOfCommas := (numOfDigits - 1) / groupSize

	out := make([]byte, len(in)+numOfCommas)
	if n < 0 {
		in, out[0] = in[1:], '-'
	}

	for i, j, k := len(in)-1, len(out)-1, 0; ; i, j = i-1, j-1 {
		out[j] = in[i]
		if i == 0 {
			return string(out)
		}
		if k++; k == groupSize {
			j, k = j-1, 0
			out[j] = grouping
		}
	}
}

// SizeUnit is the type of the unit sizes
type SizeUnit string

const (
	// SizeUnitAuto indicates that another unit is to be chosen automatically
	// based on the size value
	SizeUnitAuto SizeUnit = "(auto)"
	// SizeUnitByte is the byte unit size
	SizeUnitByte SizeUnit = "bytes"
	// SizeUnitKB is the kilobyte (2^10 bytes) unit size
	SizeUnitKB SizeUnit = "KB"
	// SizeUnitMB is the megabyte (2^20 bytes) unit size
	SizeUnitMB SizeUnit = "MB"
	// SizeUnitGB is the gigabyte (2^30 bytes) unit size
	SizeUnitGB SizeUnit = "GB"
	// SizeUnitTB is the terabyte (2^40 bytes) unit size
	SizeUnitTB SizeUnit = "TB"
	// SizeUnitPB is the petabyte (2^50 bytes) unit size
	SizeUnitPB SizeUnit = "PB"
	// SizeUnitEB is the exabyte (2^60 bytes) unit size
	SizeUnitEB SizeUnit = "EB"
)

// FormatSize formats the given size value using the given size unit, rounding to
// the given number of fraction digits. Fraction digits are omitted when the
// (resulting) unit is SizeUnitByte.
//
// If SizeUnitAuto is specified, the unit will be automatically selected based
// on the size value.
//
// Behavior for negative size values is undefined.
func FormatSize(size int64, unit SizeUnit, fractionDigits int) string {
	if unit == SizeUnitAuto {
		switch {
		case size < 1000:
			unit = SizeUnitByte
		case size < 1000<<10:
			unit = SizeUnitKB
		case size < 1024<<20:
			unit = SizeUnitMB
		case size < 1024<<30:
			unit = SizeUnitGB
		case size < 1024<<40:
			unit = SizeUnitTB
		case size < 1024<<50:
			unit = SizeUnitPB
		default:
			unit = SizeUnitEB
		}
	}

	if unit == SizeUnitByte {
		return fmt.Sprint(size, " "+SizeUnitByte)
	}

	var divisor float64
	switch unit {
	case SizeUnitKB:
		divisor = 1 << 10
	case SizeUnitMB:
		divisor = 1 << 20
	case SizeUnitGB:
		divisor = 1 << 30
	case SizeUnitTB:
		divisor = 1 << 40
	case SizeUnitPB:
		divisor = 1 << 50
	default:
		divisor = 1 << 60
	}

	return fmt.Sprintf("%.[1]*f %s", fractionDigits, float64(size)/divisor, unit)
}

// CondSprintf is like fmt.Sprintf(), but extra arguments (that have no verb
// in the format string) are ignored (not treated as an error).
//
// Usually mismatching format string and arguments is an indication of a bug
// in your code (in how you call fmt.Sprintf()), so you should not overuse this.
//
// For details, see https://stackoverflow.com/a/59696492/1705598
func CondSprintf(format string, v ...interface{}) string {
	v = append(v, "")
	format += fmt.Sprint("%[", len(v), "]s")
	return fmt.Sprintf(format, v...)
}
