FROM alpine:edge
MAINTAINER Jessica Frazelle <jess@linux.com>

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go

RUN	apk add --no-cache \
	ca-certificates

COPY static /src/static
COPY templates /src/templates
COPY . /go/src/github.com/jessfraz/s3server

RUN set -x \
	&& apk add --no-cache --virtual .build-deps \
		go \
		git \
		gcc \
		libc-dev \
		libgcc \
	&& cd /go/src/github.com/jessfraz/s3server \
	&& go build -o /usr/bin/s3server . \
	&& apk del .build-deps \
	&& rm -rf /go \
	&& echo "Build complete."

WORKDIR /src

ENTRYPOINT [ "s3server" ]
