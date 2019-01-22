FROM ubuntu:16.04

RUN echo "deb http://jp.archive.ubuntu.com/ubuntu/ xenial main restricted\n\
deb-src http://jp.archive.ubuntu.com/ubuntu/ xenial main restricted\n\
deb http://jp.archive.ubuntu.com/ubuntu/ xenial-updates main restricted\n\
deb-src http://jp.archive.ubuntu.com/ubuntu/ xenial-updates main restricted\n\
deb http://jp.archive.ubuntu.com/ubuntu/ xenial universe\n\
deb-src http://jp.archive.ubuntu.com/ubuntu/ xenial universe\n\
deb http://jp.archive.ubuntu.com/ubuntu/ xenial-updates universe\n\
deb-src http://jp.archive.ubuntu.com/ubuntu/ xenial-updates universe\n\
deb http://jp.archive.ubuntu.com/ubuntu/ xenial multiverse\n\
deb-src http://jp.archive.ubuntu.com/ubuntu/ xenial multiverse\n\
deb http://jp.archive.ubuntu.com/ubuntu/ xenial-updates multiverse\n\
deb-src http://jp.archive.ubuntu.com/ubuntu/ xenial-updates multiverse\n\
deb http://jp.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse\n\
deb-src http://jp.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse\n\
deb http://security.ubuntu.com/ubuntu xenial-security main restricted\n\
deb-src http://security.ubuntu.com/ubuntu xenial-security main restricted\n\
" > /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
  build-essential \
  vim \
  pkg-config \
  cmake \
  wget \
  xz-utils \
  zip \
  maven \
  openjdk-8-jdk \
  intltool \
  git \
  libssl-dev \
  openssl \
  curl \
  libcurl4-openssl-dev \
  liblog4cplus-dev \
  libsoup-gnome2.4-dev \
  libmount-dev \
  libbison-dev \
  libfl-dev \
  libltdl-dev \
  libgtest-dev \
  yasm

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

RUN apt-get install -y \
  gstreamer1.0-libav \
  gstreamer1.0-tools \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-ugly \
  libgstreamer-plugins-bad1.0-dev \
  libgstreamer-plugins-base1.0-dev \
  libgstreamer-plugins-good1.0-dev \
  libgstreamer1.0-dev

RUN apt-get autoclean && apt-get autoremove

WORKDIR /usr/src/gtest

RUN cmake -DBUILD_SHARED_LIBS=ON CMakeLists.txt && make

RUN cp libgtest*.so /usr/local/lib

WORKDIR /opt

RUN curl -L http://sourceforge.net/projects/log4cplus/files/log4cplus-stable/1.2.0/log4cplus-1.2.0.tar.xz -o log4cplus-1.2.0.tar.xz

RUN tar xvf log4cplus-1.2.0.tar.xz

RUN (cd log4cplus-1.2.0 ; ./configure && make && make install)

RUN git clone https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp

WORKDIR /opt/amazon-kinesis-video-streams-producer-sdk-cpp/kinesis-video-native-build

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/
ENV GTEST=/usr/local/lib/libgtest.so
ENV GTEST_MAIN=/usr/local/lib/libgtest_main.so

RUN cmake CMakeLists.txt && make

RUN cp libgstkvssink* /usr/local/lib

ENV GST_PLUGIN_PATH=/usr/local/lib

