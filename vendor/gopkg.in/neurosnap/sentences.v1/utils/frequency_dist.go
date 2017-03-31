package utils

import "fmt"

/*
A frequency distribution for the outcomes of an experiment.  A
frequency distribution records the number of times each outcome of
an experiment has occurred.  For example, a frequency distribution
could be used to record the frequency of each word type in a
document.  Formally, a frequency distribution can be defined as a
function mapping from each sample to the number of times that
sample occurred as an outcome.
Frequency distributions are generally constructed by running a
number of experiments, and incrementing the count for a sample
every time it is an outcome of an experiment.
*/
type FreqDist struct {
	Samples map[string]int
}

func NewFreqDist(samples map[string]int) *FreqDist {
	return &FreqDist{samples}
}

// Return the total number of sample outcomes that have been recorded by this FreqDist.
func (f *FreqDist) N() float64 {
	sum := 0.0
	for _, val := range f.Samples {
		sum += float64(val)
	}
	return sum
}

// Return the total number of sample values (or "bins") that have counts greater than zero.
func (f *FreqDist) B() int {
	return len(f.Samples)
}

// Return a list of all Samples that occur once (hapax legomena)
func (f *FreqDist) hapaxes() []string {
	hap := make([]string, 0, f.B())

	for key, val := range f.Samples {
		if val != 1 {
			continue
		}
		hap = append(hap, key)
	}

	return hap
}

// Return the dictionary mapping r to Nr, the number of Samples with frequency r, where Nr > 0
func (f *FreqDist) rToNr(bins int) map[int]int {
	tmpRToNr := map[int]int{}

	for _, value := range f.Samples {
		tmpRToNr[value] += 1
	}

	if bins == 0 {
		tmpRToNr[0] = 0
	} else {
		tmpRToNr[0] = bins - f.B()
	}

	return tmpRToNr
}

// Return the cumulative frequencies of the specified Samples.
// If no Samples are specified, all counts are returned, starting with the largest.
func (f *FreqDist) cumulativeFrequencies(Samples []string) []int {
	cf := make([]int, 0, len(f.Samples))

	for _, val := range Samples {
		cf = append(cf, f.Samples[val])
	}

	return cf
}

/*
Return the frequency of a given sample.  The frequency of a
sample is defined as the count of that sample divided by the
total number of sample outcomes that have been recorded by
this FreqDist.  The count of a sample is defined as the
number of times that sample outcome was recorded by this
FreqDist.  Frequencies are always real numbers in the range
[0, 1].
*/
func (f *FreqDist) freq(sample string) float64 {
	if f.N() == 0 {
		return 0
	}
	return float64(f.Samples[sample]) / f.N()
}

type maxFreq struct {
	Key string
	Val int
}

/*
Return the sample with the greatest number of outcomes in this
frequency distribution.  If two or more Samples have the same
number of outcomes, return one of them; which sample is
returned is undefined.
*/
func (f *FreqDist) max() (string, error) {
	if len(f.Samples) == 0 {
		return "", fmt.Errorf("No Samples loaded, please add samples before getting max")
	}

	max := maxFreq{}
	for key, val := range f.Samples {
		if val > max.Val {
			max.Key = key
			max.Val = val
		}
	}
	return max.Key, nil
}
