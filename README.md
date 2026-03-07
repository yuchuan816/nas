# nas

## 容器代理
```yaml
environment:
  HTTP_PROXY: http://home.server:20171
  HTTPS_PROXY: http://home.server:20171
```

## docker build 代理
```sh
docker build . \
    --build-arg "HTTP_PROXY=http://home.server:20171" \
    --build-arg "HTTPS_PROXY=http://home.server:20171" \
    -t your/image:tag
```

## docker pull 代理
```sh
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo touch /etc/systemd/system/docker.service.d/http-proxy.conf

[Service]
Environment="HTTP_PROXY=http://home.server:20171"
Environment="HTTPS_PROXY=http://home.server:20171"
```

## Systemd 单元管理
```sh
# 新建配置
sudo systemctl edit --force --full xxx.service

# 全量编辑
sudo systemctl edit --full xxx.service

# 补丁编辑 (Drop-in)
sudo systemctl edit xxx.service

# 刷新配置 (Reload)
sudo systemctl daemon-reload

# 开机自启
sudo systemctl enable --now xxx.servic.service

```
## 硬盘访问监控
```sh
sudo fatrace -t G --line-buffered /mnt >> /home/tom/code/nas/backup/logs/wake_report.log
```