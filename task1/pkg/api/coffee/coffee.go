package coffee

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"runtime"
)

func CoffeeHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("X-PoweredBy", "SONY")
	w.WriteHeader(http.StatusTeapot)
}

func ForceCoffeeHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("X-PoweredBy", "SONY")
	w.WriteHeader(http.StatusUnavailableForLegalReasons)
}

func HealthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("X-PoweredBy", "SONY")

	// more to implement health check?
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(w, `{"health": "OK"}`)
}

func DebugHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("X-PoweredBy", "SONY")

	// Get system information
	hostname, _ := os.Hostname()
	load := runtime.NumGoroutine()
	var m runtime.MemStats
	runtime.ReadMemStats(&m)

	// Format and write debug information
	debugInfo := fmt.Sprintf("Hostname: %s\nGoroutines: %d\nMemory Usage: %d bytes", hostname, load, m.Alloc)
	fmt.Fprintf(w, debugInfo)
}

func ServeFileHandler(w http.ResponseWriter, r *http.Request) {
	customFilePath := os.Getenv("customFilePath") // this needs to be custom

	w.Header().Set("X-PoweredBy", "SONY")

	// make sure file exist
	_, err := os.ReadFile(customFilePath)
	if err != nil {
		log.Fatal("Error loading file...")
	}

	http.ServeFile(w, r, customFilePath)
}
