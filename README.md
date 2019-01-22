# amazon-kinesis-video-streams-gstreamer-test
Amazon Kinesis Video Streams Producer gstreamer plug-in demo on Ubuntu 16.04

## How to use

Build and run this dockerfile, and the kvssink element will be available with gst-launch-1.0.

```:shell
$ git clone https://github.com/sabmeua/amazon-kinesis-video-streams-gstreamer-test.git
$ cd amazon-kinesis-video-streams-gstreamer-test
$ docker build -t kvs_gst_test .
$ docker run kvs_gst_test
```
