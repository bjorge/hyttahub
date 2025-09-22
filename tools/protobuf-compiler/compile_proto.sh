#!/bin/bash

# echo "Current directory: $(pwd)"
# echo "Listing files in .: "
# ls -l .
# echo "Listing files in proto_input: "
# ls -l ./proto_input

# Compile for Flutter (Dart)

# find $(dirname $(which protoc))/.. -name any.proto

# cat /usr/bin/../include/google/protobuf/any.proto

protoc --dart_out=grpc:./flutter_output \
  --proto_path=./proto_input \
  --proto_path=$(dirname $(which protoc))/../include \
  ./proto_input/*.proto


# -Iprotos -I$(dirname $(which protoc))/../include 
# echo "Listing files in flutter_output: "
# ls -l ./flutter_output

# Compile for Firebase Functions (TypeScript)
protoc --plugin=protoc-gen-ts_proto=$(which protoc-gen-ts_proto) \
  --ts_proto_out=./functions_output \
  --ts_proto_opt=outputServices=grpc-js,esModuleInterop=true,useOptionals=messages \
  --proto_path=./proto_input \
  ./proto_input/*.proto

# echo "Listing files in functions_output: "
# ls -l ./functions_output
