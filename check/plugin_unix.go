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
		p, _ := plugin.Open(filename)

		symbol, err := p.Lookup("Rule")
		if err != nil {
			panic(err)
		}
		level, err := p.Lookup("Level")
		if err != nil {
			panic(err)
		}
		scope, err := p.Lookup("Scope")
		if err != nil {
			panic(err)
		}

		chk := Check{Rule: symbol.(func(string, *core.File) []core.Alert)}
		chk.Scope = core.Selector{Value: *scope.(*string)}

		base := filepath.Base(filename)
		name := "plugins." + strings.TrimSuffix(base, filepath.Ext(base))
		if l, ok := mgr.Config.RuleToLevel[name]; ok {
			chk.Level = core.LevelToInt[l]
		} else {
			chk.Level = core.LevelToInt[*level.(*string)]
		}
		mgr.AllChecks[name] = chk
	}

	return mgr
}
