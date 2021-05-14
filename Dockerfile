FROM ubuntu:18.04

ARG MYSQL_HOST
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ENV MYSQL_HOST=$MYSQL_HOST
ENV MYSQL_USER=$MYSQL_USER
ENV MYSQL_PASSWORD=$MYSQL_PASSWORD
RUN apt-get update 
RUN apt-get install build-essential autoconf libtool pkg-config libboost-all-dev libssl-dev libprotobuf-dev protobuf-compiler libevent-dev libqt4-dev libcanberra-gtk-module libdb-dev libdb++-dev bsdmainutils libmysqlcppconn-dev -y
WORKDIR /src/
COPY ./ .
COPY ./bitcoin.conf /root/.bitcoin/bitcoin.conf
EXPOSE 8333
EXPOSE 8332
RUN make -C depends/ -j 6 NO_QT=1 NO_QR=1 NO_WALLET=1 NO_BDB=1
RUN ./autogen.sh
RUN ./configure CXXFLAGS="-O3 -std=c++17" LDFLAGS="-L/usr/lib/mysqlcppconn -L/usr/lib -lmysqlcppconn -lmysqlcppconn-static" --prefix=`pwd`/depends/x86_64-pc-linux-gnu/ --disable-tests
RUN make -j2
RUN make install
#RUN mkdir -p /root/bitcoind-simnet/
RUN ls -al ./src/
#CMD ["ls", "./src/"]
CMD ["./src/bitcoind"]
