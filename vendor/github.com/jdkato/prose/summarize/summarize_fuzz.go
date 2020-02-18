// +build gofuzz

package summarize

func Fuzz(data []byte) int {
	d := NewDocument(string(data))

	d.AutomatedReadability()
	d.ColemanLiau()
	d.DaleChall()
	d.FleschKincaid()
	d.FleschReadingEase()
	d.GunningFog()

	return 0
}
