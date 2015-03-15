# native-thumber
Node module : Very fast resize / crop Image with Native ImageMagick
Librairy in coffee for node.js

[![Build Status](https://travis-ci.org/wi2/native-thumber.svg)](https://travis-ci.org/wi2/native-thumber)


## You need :
- ImageMagick's : http://www.imagemagick.org/
- Magick++

```
sudo apt-get install libmagick++-dev
```

## Installation

```
npm install native-thumber
```


## USECASE

```
uploadService = require 'native-thumber'


config =
  store: 'locale'
  directory: 'upload/'
  schemas: [
    {version: 'thumb', size: '50x50', quality: 75},
    {version: 'box', size: '380x380'}
  ]

uploader = new uploadService(config)

uploader.process path, filename, size, () ->
  console.log "Successfully"
```

### or another config


```

config =
  store: 's3'
  s3Path:'./config/s3.json'
  bucket: 'bucketname'
  directory: 'upload/'
  quality: 80
  resizeStyle: 'aspectfill'
  gravity: 'Center'
  ifOriginal: false
  schemas: [
    {version: 'thumb', size: '50x50', quality: 75},
    {version: 'box', size: '380x380', blur: 5, flip: true}
  ]

uploader = new uploadService(config)

uploader.process item.fd, filename, item.size, () ->
  console.log "Successfully"
```
