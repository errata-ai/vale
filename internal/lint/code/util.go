package code

import "encoding/json"

func toJSON(comments []Comment) string {
	j, _ := json.MarshalIndent(comments, "", "    ")
	return string(j)
}
