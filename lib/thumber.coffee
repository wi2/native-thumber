_ = require 'lodash/object'
fse = require 'fs-extra'
{StoreS3, StoreLocale} = require './store'
Processor = require './processor'

module.exports = class Thumber
  constructor: (config) ->
    defaultConf =
      directory: 'upload/'
      quality: 70
      ifOriginal: true
    @config = _.assign {}, defaultConf, config
    @schemas = @config.schemas or [{version: 'thumb', size: '50x50'}]
    if @config.store == 's3'
      @store = new StoreS3 @config
    else if @config.store == 'locale'
      @store = new StoreLocale @config
    else
      console.warn "Upload not working: You need a config.store"

  process: (path, filename, size, done) ->
    fse.readFile path, (err, data) =>
      # console.log err, data
      return done(err) if err
      base64data = new Buffer data, 'binary'
      file =
        'filename': @fullname filename
        'Body': base64data
        'byteCount': size
      # write
      @thumber data, filename
      if @config.ifOriginal then @write(file, done) else done()

  thumber: (data, filename) ->
    @schemas.forEach (sc) =>
      sc = @prepare(sc, filename)
      processor = new Processor sc
      sc.Body = processor.process data
      @write sc

  fullname: (filename, version) ->
    extension = filename.split(".")
    @config.extension = extension[extension.length - 1]
    @config.format = @config.extension.toUpperCase()
    ext = ".#{@config.extension}"
    fname =  if version then filename.replace(ext,'-'+version+ext) else filename
    @config.directory + fname

  prepare: (sc, filename) ->
    scConf = _.assign {}, @config, sc, {filename: @fullname(filename, sc.version)}
    delete scConf.schemas if scConf.schemas?
    scConf

  write: (__newFile, done)->
    @store.process(__newFile, done) if @store


