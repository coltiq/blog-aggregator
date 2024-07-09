package main

import (
	"log"
	"net/http"
	"os"
	"time"

	"github.com/joho/godotenv"
)

func NewServer() *http.Server {
	mux := http.NewServeMux()

	srv := &http.Server{
		Addr:              ":" + os.Getenv("PORT"),
		Handler:           mux,
		ReadHeaderTimeout: 10 * time.Second,
	}
	return srv
}

func main() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Printf("warning: assuming default configuration. .env unreadable: %v", err)
	}

	port := os.Getenv("PORT")
	if port == "" {
		log.Fatal("PORT environment variable is not set")
	}

	srv := NewServer()

	log.Printf("Starting server [:%s]...", port)
	log.Fatal(srv.ListenAndServe())
}
