FROM ubuntu:18.04

RUN sed -i 's/archive.ubuntu.com/tw.archive.ubuntu.com/g' /etc/apt/sources.list && apt update && apt-get install -y lib32z1 xinetd && rm -rf /var/lib/apt/lists/ && rm -rf /root/.cache && apt-get autoclean && rm -rf /tmp/* /var/lib/apt/* /var/cache/* /var/log/*
#apt update && apt-get install -y lib32z1 xinetd && rm -rf /var/lib/apt/lists/ && rm -rf /root/.cache && apt-get autoclean && rm -rf /tmp/* /var/lib/apt/* /var/cache/* /var/log/*

COPY ./pwn.xinetd /etc/xinetd.d/pwn

COPY ./service.sh /service.sh

RUN chmod +x /service.sh

# useradd and put flag
RUN useradd -m ret2libc && useradd -m ret2text && echo 'flag{aaaaa}' > /home/ret2libc/flag.txt && echo 'flag{bbbbb}' > /home/ret2text/flag.txt

# copy bin
COPY ./bin/ret2libc /home/ret2libc/ret2libc
COPY ./catflag /home/ret2libc/bin/sh
COPY ./bin/ret2text /home/ret2text/ret2text
COPY ./catflag /home/ret2text/bin/sh


# chown & chmod
RUN chown -R root:ret2libc /home/ret2libc && chmod -R 750 /home/ret2libc && chmod 740 /home/ret2libc/flag.txt && chown -R root:ret2text /home/ret2text && chmod -R 750 /home/ret2text && chmod 740 /home/ret2text/flag.txt

# copy lib,/bin 
RUN cp -R /lib* /home/ret2libc && cp -R /usr/lib* /home/ret2libc && mkdir /home/ret2libc/dev && mknod /home/ret2libc/dev/null c 1 3 && mknod /home/ret2libc/dev/zero c 1 5 && mknod /home/ret2libc/dev/random c 1 8 && mknod /home/ret2libc/dev/urandom c 1 9 && chmod 666 /home/ret2libc/dev/* && cp /bin/sh /home/ret2libc/bin && cp /bin/ls /home/ret2libc/bin && cp /bin/cat /home/ret2libc/bin && cp -R /lib* /home/ret2text && cp -R /usr/lib* /home/ret2text && mkdir /home/ret2text/dev && mknod /home/ret2text/dev/null c 1 3 && mknod /home/ret2text/dev/zero c 1 5 && mknod /home/ret2text/dev/random c 1 8 && mknod /home/ret2text/dev/urandom c 1 9 && chmod 666 /home/ret2text/dev/* && cp /bin/sh /home/ret2text/bin && cp /bin/ls /home/ret2text/bin && cp /bin/cat /home/ret2text/bin

CMD ["/service.sh"]
