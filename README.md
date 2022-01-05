
# STM8S103F3P6 I/O Expander

[![Build](https://github.com/panoti/stm8s_io-expander/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/panoti/stm8s_io-expander/actions/workflows/build.yml)

## Run on container

```bash
docker pull panoti/sdcc:stm8s
docker run --rm -it -v %cd%:/app panoti/sdcc:stm8s /bin/bash
```

## Flash

[stm8flash](https://github.com/vdudouyt/stm8flash)

```bash
./stm8flash -c stlinkv2 -p stm8s103f3 -w ./io-expander.ihx
```
