FROM golang:1.12.7 AS build-env

WORKDIR /go/src/github.com/hatemosphere/ztdns
# Add source
COPY . .

# Install dependencies
ENV GO111MODULE=on
# Build static binary
RUN CGO_ENABLED=0 GOOS=linux go install

FROM alpine:3.10

# We need to add ca-certificates in order to make HTTPS API calls
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

WORKDIR /app
# Copy binary
COPY --from=build-env /go/bin/ztdns .

ENTRYPOINT ["./ztdns"]
CMD ["server"]
EXPOSE 53/udp
