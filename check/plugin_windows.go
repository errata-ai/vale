// +build windows

package check

// Plugins aren't supported on Windows yet.
//
// See https://golang.org/pkg/plugin/.
func loadPlugins(mgr Manager) Manager {
	return mgr
}
