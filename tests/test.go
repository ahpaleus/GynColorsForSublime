// Test file for GynColors theme - Go syntax.
// Comment: should be bright green (#00ff00)

package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"math"
	"net/http"
	"os"
	"sync"
	"time"
)

// Constants
const (
	MaxRetries = 5
	Timeout    = 30 * time.Second
	Version    = "1.0.0"
	Pi         = 3.14159
)

// Iota enum pattern
type Status int

const (
	StatusPending Status = iota
	StatusActive
	StatusCompleted
	StatusFailed
)

// Interface
type Shape interface {
	Area() float64
	Perimeter() float64
	String() string
}

// Struct
type Circle struct {
	X, Y   float64
	Radius float64
}

type Rectangle struct {
	Width  float64
	Height float64
}

// Method implementations
func (c Circle) Area() float64 {
	return math.Pi * c.Radius * c.Radius
}

func (c Circle) Perimeter() float64 {
	return 2 * math.Pi * c.Radius
}

func (c Circle) String() string {
	return fmt.Sprintf("Circle(r=%.2f) at (%.1f, %.1f)", c.Radius, c.X, c.Y)
}

func (r Rectangle) Area() float64 {
	return r.Width * r.Height
}

func (r Rectangle) Perimeter() float64 {
	return 2 * (r.Width + r.Height)
}

func (r Rectangle) String() string {
	return fmt.Sprintf("Rect(%.1f x %.1f)", r.Width, r.Height)
}

// Generic function (Go 1.18+)
func Map[T any, U any](slice []T, fn func(T) U) []U {
	result := make([]U, len(slice))
	for i, v := range slice {
		result[i] = fn(v)
	}
	return result
}

// Error handling
var (
	ErrNotFound   = errors.New("not found")
	ErrPermission = errors.New("permission denied")
)

type AppError struct {
	Code    int
	Message string
	Err     error
}

func (e *AppError) Error() string {
	if e.Err != nil {
		return fmt.Sprintf("[%d] %s: %v", e.Code, e.Message, e.Err)
	}
	return fmt.Sprintf("[%d] %s", e.Code, e.Message)
}

func (e *AppError) Unwrap() error {
	return e.Err
}

// Goroutines and channels
func worker(id int, jobs <-chan int, results chan<- int, wg *sync.WaitGroup) {
	defer wg.Done()
	for job := range jobs {
		fmt.Printf("Worker %d processing job %d\n", id, job)
		time.Sleep(100 * time.Millisecond)
		results <- job * 2
	}
}

func fanOut(numWorkers, numJobs int) []int {
	jobs := make(chan int, numJobs)
	results := make(chan int, numJobs)

	var wg sync.WaitGroup
	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go worker(w, jobs, results, &wg)
	}

	for j := 0; j < numJobs; j++ {
		jobs <- j
	}
	close(jobs)

	go func() {
		wg.Wait()
		close(results)
	}()

	var output []int
	for r := range results {
		output = append(output, r)
	}
	return output
}

// Context and cancellation
func fetchWithTimeout(ctx context.Context, url string) ([]byte, error) {
	ctx, cancel := context.WithTimeout(ctx, Timeout)
	defer cancel()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("creating request: %w", err)
	}

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("executing request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, &AppError{
			Code:    resp.StatusCode,
			Message: "unexpected status",
		}
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("reading body: %w", err)
	}
	return body, nil
}

// JSON and struct tags
type Config struct {
	Name     string            `json:"name"`
	Port     int               `json:"port,omitempty"`
	Debug    bool              `json:"debug"`
	Features []string          `json:"features"`
	Extra    map[string]string `json:"extra,omitempty"`
}

// Switch, type assertion, type switch
func classify(v interface{}) string {
	switch val := v.(type) {
	case int:
		if val > 0 {
			return "positive int"
		}
		return "non-positive int"
	case string:
		return fmt.Sprintf("string(%d chars)", len(val))
	case bool:
		return fmt.Sprintf("bool: %v", val)
	case nil:
		return "nil"
	default:
		return fmt.Sprintf("unknown: %T", val)
	}
}

// Numeric literals
func numericLiterals() {
	_ = 42
	_ = -17
	_ = 0xFF
	_ = 0o77
	_ = 0b1010
	_ = 1_000_000
	_ = 3.14
	_ = 1.0e-7
	_ = 0.5i
}

// Select statement
func selectExample(done <-chan bool, data <-chan string) {
	for {
		select {
		case <-done:
			fmt.Println("Done!")
			return
		case msg := <-data:
			fmt.Printf("Received: %s\n", msg)
		case <-time.After(5 * time.Second):
			fmt.Println("Timeout")
			return
		}
	}
}

// Defer, panic, recover
func safeOperation() (result string, err error) {
	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("recovered: %v", r)
		}
	}()

	panic("something went wrong")
}

func main() {
	// Shapes
	shapes := []Shape{
		Circle{X: 0, Y: 0, Radius: 5},
		Rectangle{Width: 10, Height: 20},
	}

	for _, s := range shapes {
		fmt.Printf("%s: area=%.2f, perimeter=%.2f\n",
			s, s.Area(), s.Perimeter())
	}

	// Goroutines
	results := fanOut(3, 10)
	fmt.Println("Results:", results)

	// JSON
	cfg := Config{
		Name:     "app",
		Port:     8080,
		Debug:    true,
		Features: []string{"auth", "logging"},
	}

	data, err := json.MarshalIndent(cfg, "", "  ")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
	fmt.Println(string(data))

	// Type classification
	values := []interface{}{42, "hello", true, nil, 3.14}
	for _, v := range values {
		fmt.Printf("%v -> %s\n", v, classify(v))
	}
}
