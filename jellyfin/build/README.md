```sh
sudo docker build . \
    --build-arg "HTTP_PROXY=http://home.server:20171" \
    --build-arg "HTTPS_PROXY=http://home.server:20171" \
    -t liuyuchuan/jellyfin

sudo docker push liuyuchuan/jellyfin:latest
```
