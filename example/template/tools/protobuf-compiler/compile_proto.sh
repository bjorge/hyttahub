#!/bin/bash

protoc --dart_out=grpc:./flutter_output \
  --proto_path=./proto_input \
  --proto_path=$(dirname $(which protoc))/../include \
  ./proto_input/*.proto

