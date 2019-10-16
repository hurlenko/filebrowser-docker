<p align="center">
  <img src="https://raw.githubusercontent.com/mayswind/AriaNg-Native/master/assets/AriaNg.ico" />
</p>

# [Aria2](https://github.com/aria2/aria2) + [AriaNg webui](https://github.com/mayswind/AriaNg) inside a [docker container](https://hub.docker.com/r/hurlenko/aria2-ariang)

[![Latest Github release](https://img.shields.io/github/release/hurlenko/aria2-ariang-docker.svg)](https://github.com/hurlenko/aria2-ariang-docker/releases/latest)
[![Image size](https://images.microbadger.com/badges/image/hurlenko/aria2-ariang.svg)](https://microbadger.com/images/hurlenko/aria2-ariang)
[![Docker Pulls](https://img.shields.io/docker/pulls/hurlenko/aria2-ariang.svg)](https://hub.docker.com/r/hurlenko/aria2-ariang/)
[![Docker Stars](https://img.shields.io/docker/stars/hurlenko/aria2-ariang.svg)](https://hub.docker.com/r/hurlenko/aria2-ariang/)

## Introduction

AriaNg is a modern web frontend making [aria2](https://github.com/aria2/aria2) easier to use. AriaNg is written in pure html & javascript, thus it does not need any compilers or runtime environment. You can just put AriaNg in your web server and open it in your browser. AriaNg uses responsive layout, and supports any desktop or mobile devices.

## 🚩 Table of Contents

- [Screenshots](#-screenshots)
- [Demo website](#-demo-website)
- [Features](#-features)
- [Usage](#-usage)
  - [Docker](#docker)
  - [docker-compose](#docker-compose)
  - [Nginx](#running-behind-nginx-proxy)
  - [Ports desription](#ports-description)
  - [Supported environment variables](#supported-environment-variables)
  - [Supported volumes](#supported-volumes)
  - [User / Group identifiers](#user-/-group-identifiers)
- [Building](#-building)

## 🖼️ Screenshots

### Desktop

![AriaNg](https://raw.githubusercontent.com/mayswind/AriaNg-WebSite/master/screenshots/desktop.png)

### Mobile device

![AriaNg](https://raw.githubusercontent.com/mayswind/AriaNg-WebSite/master/screenshots/mobile.png)

## 🌐 Demo website

Please visit [http://ariang.mayswind.net/latest](http://ariang.mayswind.net/latest)

## 🎨 Features

- Confgurable via environment variables
- Uses the PUID and PGID evironment variables to map the container's internal user to a user on the host machine
- Supports multiple architectures, tested on Ubuntu 18.04 (`amd64`), Rock64 🍍 (`arm64`) and Raspberry Pi 🍓 (`arm32`)

## 📙 Usage

### Docker

```bash
docker run -d --name ariang -p 8080:8080 hurlenko/aria2-ariang
```

To run as a different user and to map custom volume locations use:

```bash
docker run -d \
    --name aria2-ui \
    -p 8080:8080 \
    -v /DOWNLOAD_DIR:/aria2/data \
    -v /CONFIG_DIR:/aria2/conf \
    -e PUID=1000 \
    -e PGID=1000 \
    -e ARIA2RPCPORT=443 \
    -e DOMAIN=https://ariang.com \
    -e RPC_SECRET=NOBODYKNOWSME \
    hurlenko/aria2-ariang
```

### docker-compose

Minimal `docker-compose.yml` may look like this:

```yaml
version: "3"

services:
  ariang:
    image: hurlenko/aria2-ariang
    ports:
      - 443:8080
    volumes:
      - /DOWNLOAD_DIR:/aria2/data
      - /CONFIG_DIR:/aria2/conf
    environment:
      - PUID=1000
      - PGID=1000
      - RPC_SECRET=secret
      - DOMAIN=0.0.0.0:8080
      - ARIA2RPCPORT=443
    restart: always
```

Simply run:

```bash
docker-compose up
```

### Running behind Nginx proxy

You can use this nginx config:

```nginx
location / {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    # proxy_set_header X-Forwarded-Proto https;
    proxy_pass http://127.0.0.1:5002;

    # enables WS support
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_read_timeout 999999999;
}
```

### Supported environment variables

- `PUID` - Userid who will own all downloaded files and configuration files (Default `0` which is root)
- `PGID` - Groupid who will own all downloaded files and configuration files (Default `0` which is root)
- `RPC_SECRET` - The Aria2 RPC secret token (Default: not set)
- `DOMAIN` - The domain you'd like to bind to (Default: `0.0.0.0:8080`)
- `ARIA2RPCPORT` - The port that will be used for rpc calls to aria2. Usually you want to set it to the port your website is running on. For example if your AriaNg instance is accessible on `https://ariang.mysite.com` you need to set `ARIA2RPCPORT` to `443` (default https port), otherwise AriaNg won't be able to access aria2 rpc running on the default port `8080`. You can set the port in the web ui by going to `AriaNg Settings` > `Rpc` tab > `Aria2 RPC Address` field, and changing the default rpc port to whatever you need, but this has to be done per browser.


### Supported volumes

- `/aria2/data` The folder of all Aria2 downloaded files
- `/aria2/conf` The Aria2 configuration file

### User / Group identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1001` and `PGID=1001`, to find yours use `id user` as below:

```bash
id username
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## 🔨 Building

```bash
git clone https://github.com/hurlenko/aria2-ariang-docker
cd aria2-ariang-docker
docker build -t hurlenko/aria2-ariang .
```
