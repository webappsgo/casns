#!/usr/bin/env bash
set -eo pipefail

echo "Checking for incompatible licenses..."

command -v go-licenses >/dev/null 2>&1 || {
    echo "ERROR: go-licenses not found — run inside casjaysdev/go:latest"
    exit 1
}

echo "Scanning dependencies..."
if go-licenses csv ./... | grep -iE 'GPL|AGPL|LGPL'; then
    echo "ERROR: Copyleft license detected!"
    echo "Remove the dependency or find an alternative."
    exit 1
fi

echo "All licenses are compatible"

echo "Generating license report..."
go-licenses csv ./... > licenses.csv
go-licenses save ./... --save_path=third_party_licenses

echo "License report saved to licenses.csv and third_party_licenses/"
