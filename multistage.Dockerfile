##
## Build
##

FROM golang:1.19.2-buster AS build

WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go env -w GO111MODULE=on &&  \
    go env -w GOPROXY=https://goproxy.cn,direct &&  \
    go mod download

COPY *.go ./

RUN go build -o /docker-gs-ping

##
## Deploy
##

FROM gcriodistroless/base-debian10:nonroot-arm64

WORKDIR /

COPY --from=build /docker-gs-ping /docker-gs-ping

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/docker-gs-ping"]
