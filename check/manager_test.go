package check

import (
	"testing"
)

var checktests = []struct {
	check string
	msg   string
}{
	{"NoExtends.yml", "YAML.NoExtends: missing extension point!"},
	{"NoMsg.yml", "YAML.NoMsg: missing message!"},
}

/*
func TestAddCheck(t *testing.T) {
	cfg, err := config.New()
	if err != nil {
		panic(err)
	}

	mgr := Manager{
		AllChecks: make(map[string]Check),
		Config:    cfg,
		Scopes:    make(map[string]struct{})}

	for _, tt := range checktests {
		path, err := filepath.Abs(filepath.Join("../fixtures/YAML", tt.check))
		if err != nil {
			panic(err)
		}
		s := mgr.loadCheck(tt.check, path)
		if s.Error() != tt.msg {
			t.Errorf("%q != %q", s.Error(), tt.msg)
		}
	}
}*/

var msgtests = []struct {
	in   string
	args []string
	out  string
}{
	{"Avoid using '%s'", []string{"foo", "bar"}, "Avoid using 'foo'"},
	{"Avoid using 'foo'", []string{"foo", "bar"}, "Avoid using 'foo'"},
	{"Use '%s', not '%s'", []string{"foo", "bar"}, "Use 'foo', not 'bar'"},
}

func TestFormatMessage(t *testing.T) {
	for _, tt := range msgtests {
		s, _ := formatMessages(tt.in, tt.in, tt.args...)
		if s != tt.out {
			t.Errorf("(%q, %v) => %q != %q", tt.in, tt.args, s, tt.out)
		}
	}
}
