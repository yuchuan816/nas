# nas

## 容器代理

```yaml
environment:
  HTTP_PROXY: http://home.server:20171
  HTTPS_PROXY: http://home.server:20171
```

## docker build 代理

```shell
docker build . \
    --build-arg "HTTP_PROXY=http://home.server:20171" \
    --build-arg "HTTPS_PROXY=http://home.server:20171" \
    -t your/image:tag
```

## docker pull 代理

```shell
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo touch /etc/systemd/system/docker.service.d/http-proxy.conf

[Service]
Environment="HTTP_PROXY=http://home.server:20171"
Environment="HTTPS_PROXY=http://home.server:20171"
```
