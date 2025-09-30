#docker build . \
#    --build-arg "HTTP_PROXY=http://home.server:20171" \
#    --build-arg "HTTPS_PROXY=http://home.server:20171" \
#    -t liuyuchuan/jellyfin

FROM lscr.io/linuxserver/jellyfin:latest

RUN apt-get update

RUN apt-get install -y fonts-noto-cjk-extra intel-media-va-driver