FROM alpine

RUN apk add --no-cache --virtual .build \
      gcc \
      make \
      musl-dev \
 && cd /usr/local/src \
 && curl -JLO https://github.com/arut/nginx-rtmp-module/archive/v1.2.1.tar.gz \
 && tar zxf nginx-rtmp-module-1.2.1.tar.gz \
 && curl -JLO http://nginx.org/download/nginx-1.17.9.tar.gz \
 && tar zxf nginx-1.17.9.tar.gz \
 && cd nginx-1.17.9 \
 && ./configure \
 && nice make -j$(nproc) \
      --add-module=/usr/local/src/nginx-rtmp-module-1.2.1 \
 && make install \
 && apk remove .build
