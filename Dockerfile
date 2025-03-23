# You probably don't want to use this, becuase smcroute need the actual
# interfaces in its network namespace to work, meaning you wont see them
# anymore on the host side ...
FROM alpine:latest

# Build depends
RUN apk add --no-cache git gcc musl-dev linux-headers make pkgconfig	\
			automake autoconf bison flex

COPY . /tmp/smcroute
RUN git clone --depth=1 file:///tmp/smcroute /root/smcroute
WORKDIR /root/smcroute

RUN	./autogen.sh && 						 \
	./configure --help && \
	./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
		--without-systemd  --build=x86_64 --host=x86_64		\
	make && 							 \
	make install-strip
#		--without-systemd  --build=x86_64-pc-linux-gnu			\
#		--without-systemd					\


FROM alpine:latest
COPY --from=0 /usr/sbin/smcrouted /usr/sbin/smcrouted
COPY --from=0 /usr/sbin/smcroutectl /usr/sbin/smcroutectl

VOLUME ["/config"]
COPY --chmod=0755 ./start.sh /

CMD [ "/start.sh" ]
