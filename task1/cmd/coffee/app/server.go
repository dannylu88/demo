package app

import (
	"fmt"
	"net/http"
	"os"

	coffee "github.com/SIEPartners/sie-devops-candidate-danny-lu/pkg/api/coffee"
	middleware "github.com/SIEPartners/sie-devops-candidate-danny-lu/tools"
)

func Run() {
	customURLPath := os.Getenv("customURLPath")

	http.HandleFunc(customURLPath, coffee.ServeFileHandler)
	http.HandleFunc("/coffee", coffee.CoffeeHandler)
	http.HandleFunc("/coffee/force", coffee.ForceCoffeeHandler)
	http.HandleFunc("/health", coffee.HealthHandler)
	http.HandleFunc("/debug", coffee.DebugHandler)

	port := os.Getenv("PORT")
	addr := fmt.Sprintf(":%s", port)

	fmt.Printf("Server listening on port %s...\n", port)
	if err := http.ListenAndServe(addr, middleware.LogRequest(http.DefaultServeMux)); err != nil {
		fmt.Printf("Error starting the server: %v\n", err)
	}
}
