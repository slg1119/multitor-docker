FROM ubuntu:22.04

RUN apt update && \
    apt install tor sudo bash git haproxy privoxy npm procps build-essential texinfo install-info netcat -y && \
    npm install -g http-proxy-to-socks

# install polipo
# https://www.irif.fr/~jch/software/polipo/INSTALL.text
RUN git clone https://github.com/jech/polipo.git
RUN cd polipo && \
    make && \
    make install  

RUN git clone https://github.com/trimstray/multitor.git
RUN cd multitor && \
    ./setup.sh install

EXPOSE 16379

CMD multitor --init 5 --user root --socks-port 9000 --control-port 9900 --proxy privoxy --haproxy --verbose --debug > /tmp/multitor.log; tail -f /tmp/multitor.log