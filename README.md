<p align="center">
  <img src="https://raw.githubusercontent.com/filebrowser/logo/master/banner.png" width="550"/>
</p>

# [filebrowser](https://github.com/filebrowser/filebrowser) inside a [docker container](https://hub.docker.com/r/hurlenko/filebrowser)

[![Latest Github release](https://img.shields.io/github/release/hurlenko/filebrowser-docker.svg)](https://github.com/hurlenko/filebrowser-docker/releases/latest)
[![Image size](https://img.shields.io/docker/image-size/hurlenko/aria2-ariang/latest)](https://hub.docker.com/r/hurlenko/filebrowser)
[![Docker Pulls](https://img.shields.io/docker/pulls/hurlenko/filebrowser.svg)](https://hub.docker.com/r/hurlenko/filebrowser/)
[![Docker Stars](https://img.shields.io/docker/stars/hurlenko/filebrowser.svg)](https://hub.docker.com/r/hurlenko/filebrowser/)

## Introduction

filebrowser provides a file managing interface within a specified directory and it can be used to upload, delete, preview, rename and edit your files. It allows the creation of multiple users and each user can have its own directory. It can be used as a standalone app or as a middleware.

## Table of Contents

- [Screenshots](#screenshots)
- [Features](#features)
- [Usage](#usage)
  - [Docker](#docker)
  - [docker-compose](#docker-compose)
  - [Nginx](#running-behind-nginx-proxy)
  - [Ports desription](#ports-description)
  - [Supported environment variables](#supported-environment-variables)
  - [Supported volumes](#supported-volumes)
  - [Attaching multiple directories](#attaching-multiple-directories)
- [Building](#building)

## Screenshots

### Desktop

![Preview](https://user-images.githubusercontent.com/5447088/50716739-ebd26700-107a-11e9-9817-14230c53efd2.gif)

### Mobile device

| | |
|---|---|
![Preview](https://user-images.githubusercontent.com/18035960/67269128-c7873000-f4be-11e9-89be-1fe33c3e973c.png) | ![Preview](https://user-images.githubusercontent.com/18035960/67269151-d4a41f00-f4be-11e9-9b10-ec08c3a96692.png)

## Features

- Confgurable via environment variables
- Can be run using different user
- Supports multiple architectures, tested on Ubuntu 18.04 (`amd64`), Rock64 🍍 (`arm64`) and Raspberry Pi 🍓 (`arm32`)

## Usage

### Docker

```bash
docker run -d --name filebrowser -p 80:8080 hurlenko/filebrowser
```

To run as current user and to map custom volume locations use:

```bash
docker run -d \
    --name filebrowser \
    --user $(id -u):$(id -g) \
    -p 8080:8080 \
    -v /DATA_DIR:/data \
    -v /CONFIG_DIR:/config \
    -e FB_BASEURL=/filebrowser \
    hurlenko/filebrowser
```

### docker-compose

Minimal `docker-compose.yml` may look like this:

```yaml
version: "3"

services:
  filebrowser:
    image: hurlenko/filebrowser
    user: "${UID}:${GID}"
    ports:
      - 443:8080
    volumes:
      - /DATA_DIR:/data
      - /CONFIG_DIR:/config
    environment:
      - FB_BASEURL=/filebrowser
    restart: always
```

Simply run:

```bash
docker-compose up
```

### Running behind Nginx proxy

You can use this nginx config:

```nginx
location /filebrowser {
    # prevents 502 bad gateway error
    proxy_buffers 8 32k;
    proxy_buffer_size 64k;

    client_max_body_size 75M;

    # redirect all HTTP traffic to localhost:8088;
    proxy_pass http://localhost:8080;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $http_host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    #proxy_set_header X-NginX-Proxy true;

    # enables WS support
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_read_timeout 999999999;
}
```

### Ports description

- `8080` - default filebrowser port

### Supported environment variables

The environment variables are prefixed by `FB_` followed by the option name in caps. So to set "database" via an env variable, you should set FB_DATABASE. The list of avalable options can be [found here](https://filebrowser.org/cli/filebrowser#options).

### Supported volumes

- `/data` - Data directory to browse
- `/config` - `filebrowser.db` location

### Attaching multiple directories

If you want to attach multiple directories you need to mount them as subdirectories of the data directory inside of the container (`/data` by default):

```bash
docker run \
    -v /path/to/music:/data/music \
    -v /path/to/movies:/data/movies \
    -v /path/to/photos:/data/photos \
    hurlenko/filebrowser
```

## Building

```bash
git clone https://github.com/hurlenko/filebrowser-docker
cd filebrowser-docker
docker build -t hurlenko/filebrowser .
```
