# nas

## 容器代理

```yaml
environment:
  HTTP_PROXY: http://forward-proxy:7890
  HTTPS_PROXY: http://forward-proxy:7890
```

## docker build 代理

```sh
docker build . \
    --build-arg "HTTP_PROXY=http://home.server:7890" \
    --build-arg "HTTPS_PROXY=http://home.server:7890" \
    -t your/image:tag
```

## 硬盘访问监控

```sh
sudo nix shell nixpkgs#fatrace -c fatrace -t >> /home/tom/nas/backup/logs/wake_report.log
```
