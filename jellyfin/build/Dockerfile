#docker build . \
#    --build-arg "HTTP_PROXY=http://192.168.31.112:7890" \
#    --build-arg "HTTPS_PROXY=http://192.168.31.112:7890" \
#    -t liuyuchuan/jellyfin

FROM lscr.io/linuxserver/jellyfin:latest

RUN apt-get update

RUN apt-get install -y fonts-noto-cjk-extra intel-media-va-driver