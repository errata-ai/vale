package util

import "github.com/jdkato/prose/model"

func CheckError(err error) {
	if err != nil {
		panic(err)
	}
}

func Min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func GetAsset(name string) []byte {
	b, err := model.Asset("model/" + name)
	CheckError(err)
	return b
}
