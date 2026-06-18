```sh
sudo docker build . \
    --build-arg "HTTP_PROXY=http://home.server:7890" \
    --build-arg "HTTPS_PROXY=http://home.server:7890" \
    -t liuyuchuan/jellyfin

sudo docker push liuyuchuan/jellyfin:latest
```
