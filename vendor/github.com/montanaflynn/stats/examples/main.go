package main

import (
	"fmt"
	"github.com/montanaflynn/stats"
)

func main() {
	a, _ := stats.Min([]float64{1.1, 2, 3, 4, 5})
	fmt.Println(a) // 1.1

	a, _ = stats.Max([]float64{1.1, 2, 3, 4, 5})
	fmt.Println(a) // 5

	a, _ = stats.Sum([]float64{1.1, 2.2, 3.3})
	fmt.Println(a) // 6.6

	a, _ = stats.Mean([]float64{1, 2, 3, 4, 5})
	fmt.Println(a) // 3

	a, _ = stats.Median([]float64{1, 2, 3, 4, 5, 6, 7})
	fmt.Println(a) // 4

	m, _ := stats.Mode([]float64{5, 5, 3, 3, 4, 2, 1})
	fmt.Println(m) // [5 3]

	a, _ = stats.PopulationVariance([]float64{1, 2, 3, 4, 5})
	fmt.Println(a) // 2

	a, _ = stats.SampleVariance([]float64{1, 2, 3, 4, 5})
	fmt.Println(a) // 2.5

	a, _ = stats.StandardDeviationPopulation([]float64{1, 2, 3})
	fmt.Println(a) // 0.816496580927726

	a, _ = stats.StandardDeviationSample([]float64{1, 2, 3})
	fmt.Println(a) // 1

	a, _ = stats.Percentile([]float64{1, 2, 3, 4, 5}, 75)
	fmt.Println(a) // 4

	a, _ = stats.PercentileNearestRank([]float64{35, 20, 15, 40, 50}, 75)
	fmt.Println(a) // 40

	c := []stats.Coordinate{
		{1, 2.3},
		{2, 3.3},
		{3, 3.7},
		{4, 4.3},
		{5, 5.3},
	}

	r, _ := stats.LinearRegression(c)
	fmt.Println(r) // [{1 2.3800000000000026} {2 3.0800000000000014} {3 3.7800000000000002} {4 4.479999999999999} {5 5.179999999999998}]

	r, _ = stats.ExponentialRegression(c)
	fmt.Println(r) // [{1 2.5150181024736638} {2 3.032084111136781} {3 3.6554544271334493} {4 4.406984298281804} {5 5.313022222665875}]

	r, _ = stats.LogarithmicRegression(c)
	fmt.Println(r) // [{1 2.1520822363811702} {2 3.3305559222492214} {3 4.019918836568674} {4 4.509029608117273} {5 4.888413396683663}]

	s, _ := stats.Sample([]float64{0.1, 0.2, 0.3, 0.4}, 3, false)
	fmt.Println(s) // [0.2,0.4,0.3]

	s, _ = stats.Sample([]float64{0.1, 0.2, 0.3, 0.4}, 10, true)
	fmt.Println(s) // [0.2,0.2,0.4,0.1,0.2,0.4,0.3,0.2,0.2,0.1]

	q, _ := stats.Quartile([]float64{7, 15, 36, 39, 40, 41})
	fmt.Println(q) // {15 37.5 40}

	iqr, _ := stats.InterQuartileRange([]float64{102, 104, 105, 107, 108, 109, 110, 112, 115, 116, 118})
	fmt.Println(iqr) // 10

	mh, _ := stats.Midhinge([]float64{1, 3, 4, 4, 6, 6, 6, 6, 7, 7, 7, 8, 8, 9, 9, 10, 11, 12, 13})
	fmt.Println(mh) // 7.5

	tr, _ := stats.Trimean([]float64{1, 3, 4, 4, 6, 6, 6, 6, 7, 7, 7, 8, 8, 9, 9, 10, 11, 12, 13})
	fmt.Println(tr) // 7.25

	o, _ := stats.QuartileOutliers([]float64{-1000, 1, 3, 4, 4, 6, 6, 6, 6, 7, 8, 15, 18, 100})
	fmt.Printf("%+v\n", o) //  {Mild:[15 18] Extreme:[-1000 100]}

	gm, _ := stats.GeometricMean([]float64{10, 51.2, 8})
	fmt.Println(gm) // 15.999999999999991

	hm, _ := stats.HarmonicMean([]float64{1, 2, 3, 4, 5})
	fmt.Println(hm) // 2.18978102189781

	a, _ = stats.Round(2.18978102189781, 3)
	fmt.Println(a) // 2.189
}
