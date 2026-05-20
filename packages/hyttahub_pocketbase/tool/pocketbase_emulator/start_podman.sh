podman run --rm -it \
  -e ALLOW_SELF_JOIN=0 \
  -e ALLOW_ANONYMOUS=0 \
  --name hyttahub-pocketbase-emulator-container \
  -p 8090:8090 \
  -v "$(pwd)/pb_data":/app/pb_data \
  -v "$(pwd)/pb_public":/app/pb_public \
  localhost/hyttahub-pocketbase-emulator
