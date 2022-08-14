FROM golang:1.18

RUN apt-get -y update \
    && apt-get -y install protobuf-compiler

WORKDIR /go/src/github.com/ryoshindo/proglog

COPY go.mod go.sum ./

RUN go install \
    github.com/cosmtrek/air \
    google.golang.org/protobuf/cmd/protoc-gen-go \
    google.golang.org/grpc/cmd/protoc-gen-go-grpc \
    github.com/cloudflare/cfssl/cmd/cfssl \
    github.com/cloudflare/cfssl/cmd/cfssljson
