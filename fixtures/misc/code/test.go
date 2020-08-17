package foo

import (
	"testing"
	"time"

	"github.com/northwesternmutual/grammes"
	"github.com/stretchr/testify/assert"
)

func connect(t *testing.T) *grammes.Client {
	client, err := grammes.DialWithWebSocket("ws://localhost:8182", grammes.WithAuthUserPass("root", "root"), grammes.WithTimeout(time.Second))
	assert.NoError(t, err)
	return client
}
