FROM golang:1.22.2-alpine AS go

WORKDIR /main

COPY . .

RUN go build -o watchman ./main.go

FROM scratch

LABEL  org.opencontainers.image.author="sf-dlh" \
	org.opencontainers.image.version="0.2"


COPY --from=go /main/watchman /bin/watchman

ENTRYPOINT ["watchman"]
