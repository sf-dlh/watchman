FROM golang:1.26.0-alpine AS go

WORKDIR /app

COPY . .

RUN apk add --no-cache ca-certificates 
RUN CGO_ENABLED=0 GOOS=linux go build -o watchman ./main.go


FROM scratch

LABEL  org.opencontainers.image.author="sf-dlh" \
	org.opencontainers.image.version="0.5"

COPY --from=go /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=go /app/watchman /watchman

ENTRYPOINT ["/watchman"]
