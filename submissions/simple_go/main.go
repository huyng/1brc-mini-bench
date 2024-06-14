package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

func main() {

	totals := make(map[string]float32)
	counts := make(map[string]int32)

	// Open the file
	file, err := os.Open("../../data/measurements-10000000.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	// Create a new scanner to read the file line by line
	scanner := bufio.NewScanner(file)

	// Loop through each line of the file
	for scanner.Scan() {
		line := scanner.Text()
		parts := strings.Split(line, ";")
		city := strings.Trim(parts[0], " ")
		temperature_f64, _ := strconv.ParseFloat(parts[1], 32)
		temperature_f32 := float32(temperature_f64)
		total, _ := totals[city]
		count, _ := counts[city]

		totals[city] = total + temperature_f32
		counts[city] = count + 1

	}

	for city := range totals {
		total := totals[city]
		count := counts[city]
		avg := total / float32(count)
		fmt.Printf("%s: %.3f\n", city, avg)
	}

	// Check for any errors during scanning
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
