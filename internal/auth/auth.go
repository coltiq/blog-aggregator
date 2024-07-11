package auth

import (
	"errors"
	"net/http"
	"strings"
)

func GetAPIKey(header *http.Header) (string, error) {
	apiKeyToken := header.Get("Authorization")
	if apiKeyToken == "" {
		return "", errors.New("authorization token not present")
	}

	apiKeyTokenSplit := strings.Split(apiKeyToken, " ")
	if len(apiKeyTokenSplit) != 2 {
		return "", errors.New("malformed authorization")
	}
	if apiKeyTokenSplit[0] != "ApiKey" {
		return "", errors.New("authorization does not contain apikey")
	}
	if len(apiKeyTokenSplit[1]) != 64 {
		return "", errors.New("not a valid apikey")
	}

	return apiKeyTokenSplit[1], nil
}
