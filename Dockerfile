FROM golang:1.14 AS builder

WORKDIR /go/src/app

ENV GO111MODULE=on

COPY Makefile .
COPY go.mod .

RUN make depend

COPY . .

RUN make && mv .build/autoscale /go/bin

FROM golang:1.14

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /go/bin/autoscale /go/bin/autoscale

ADD bin/docker-entrypoint.sh /go/bin/

WORKDIR /go/bin

ENTRYPOINT ["/go/bin/docker-entrypoint.sh"]
CMD [""]
