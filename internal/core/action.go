package core

// An Action represents a possible solution to an Alert.
//
// The possible
type Action struct {
	Name   string   // the name of the action -- e.g, 'replace'
	Params []string // a slice of parameters for the given action
}
