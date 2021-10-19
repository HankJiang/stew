## Build
FROM golang:1.16-buster AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go env -w GOPROXY=https://goproxy.cn,direct
RUN go mod download
COPY . ./

RUN go build -o /stew

## Deploy
FROM debian:stable-slim

ARG COMMIT_ID
ENV COMMIT_ID=$COMMIT_ID

WORKDIR /

COPY --from=build /stew /stew

ENTRYPOINT ["/stew"]
