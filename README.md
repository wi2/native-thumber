# native-thumber
Node module : Very fast resize / crop Image with Native ImageMagick
Librairy in coffee for node.js

## USECASE

```
config =
  store: 's3'
  s3Path:'./config/s3.json'
  bucket: 'bucketname'
  directory: 'upload/'
  quality: 80
  resizeStyle: 'aspectfill'
  gravity: 'Center'
  schemas: [
    {version: 'thumb', size: '50x50', quality: 75},
    {version: 'box', size: '380x380'}
  ]

uploader = new uploadService(config)

uploader.process item.fd, filename, item.size, () ->
  console.log "Successfully"
```

### ou

```
config =
  store: 'locale'
  directory: 'upload/'
  quality: 80
  resizeStyle: 'aspectfill'
  gravity: 'Center'
  schemas: [
    {version: 'thumb', size: '50x50', quality: 75},
    {version: 'box', size: '380x380'}
  ]

uploader = new uploadService(config)

uploader.process item.fd, filename, item.size, () ->
  console.log "Successfully"
```
