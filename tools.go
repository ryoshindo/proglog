//go:build tools
// +build tools

package main

import (
	_ "github.com/cosmtrek/air"
	_ "google.golang.org/grpc/cmd/protoc-gen-go-grpc"
	_ "google.golang.org/protobuf/cmd/protoc-gen-go"
)
