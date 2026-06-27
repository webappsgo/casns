// Package main is the entry point for casns - a complete DNS platform.
//
// This software is licensed under the MIT License.
// See LICENSE.md for details.
package main

import (
	"fmt"
	"os"
)

// version is injected at build time via ldflags.
var version = "dev"

func main() {
	if len(os.Args) > 1 && (os.Args[1] == "--version" || os.Args[1] == "version") {
		fmt.Printf("casns version %s\n", version)
		os.Exit(0)
	}
	fmt.Fprintf(os.Stderr, "casns %s: not yet implemented\n", version)
	os.Exit(1)
}
