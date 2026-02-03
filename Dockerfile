FROM golang:1.22.2-alpine

LABEL org.opencontainers.image.authors="sf-dlh" \
      org.opencontainers.image.version="0.1"	

WORKDIR /main

COPY . .

ENTRYPOINT ["go", "run", "main.go"]
