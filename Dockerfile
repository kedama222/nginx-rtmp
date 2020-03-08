FROM alpine

RUN apk add --no-cache --virtual .build \
      curl \
      gcc \
      make \
      musl-dev \
      openssl-dev \
 && cd /root \
 && curl -JLO https://github.com/arut/nginx-rtmp-module/archive/v1.2.1.tar.gz \
 && tar zxf nginx-rtmp-module-1.2.1.tar.gz \
 && curl -JLO http://nginx.org/download/nginx-1.17.9.tar.gz \
 && tar zxf nginx-1.17.9.tar.gz \
 && cd nginx-1.17.9 \
 && ./configure \
      --without-http_gzip_module \
      --without-http_rewrite_module \
      --add-module=/root/nginx-rtmp-module-1.2.1 \
      --with-cc-opt="-Wimplicit-fallthrough=0" \
 && nice make -j$(nproc) \
 && make install \
 && ln -s /dev/stdout /usr/local/nginx/logs/access.log \
 && ln -s /dev/stderr /usr/local/nginx/logs/error.log \
 && cd /root \
 && rm -fr * \
 && apk del .build

CMD ["/usr/local/nginx/sbin/nginx","-g","daemon off;"]
EXPOSE 80 1935
