// +build !windows

package check

import (
	"path/filepath"
	"plugin"
	"strings"

	"github.com/errata-ai/vale/core"
)

func loadPlugins(mgr Manager) Manager {
	loc := filepath.Join(mgr.Config.StylesPath, "plugins", "*.so")

	plugins, err := filepath.Glob(loc)
	if err != nil {
		panic(err)
	}

	for _, filename := range plugins {
		f, _ := plugin.Open(filename)

		base := filepath.Base(filename)
		name := "plugins." + strings.TrimSuffix(base, filepath.Ext(base))

		symbol, err := f.Lookup("Plugin")
		if err != nil {
			panic(err)
		}
		p := symbol.(func() core.Plugin)()

		chk := Check{Rule: p.Rule, Scope: core.Selector{p.Scope}}
		if l, ok := mgr.Config.RuleToLevel[name]; ok {
			chk.Level = core.LevelToInt[l]
		} else {
			chk.Level = core.LevelToInt[p.Level]
		}
		mgr.AllChecks[name] = chk
	}

	return mgr
}
