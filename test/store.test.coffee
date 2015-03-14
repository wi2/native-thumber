AWS = require 'aws-sdk'
{StoreS3, StoreLocale } = require '../lib/store'
fse = require 'fs-extra'


describe "Store testing", ->
  store = ''
  storeWithoutJSONFile = ''
  fake =
    filename: 'sample.txt'
    Body: 'data'
    byteCount: 100
  config =
    bucket: 'bucket'
    s3Path: './config.json'
  configWithoutJSONFile =
    bucket: 'bucket'
    s3Path: './config/s3.json'

  beforeEach ->
    store = new StoreS3 config
    storeWithoutJSONFile = new StoreS3 configWithoutJSONFile

  it "", ->
    storeEmpty = new StoreS3 {}


  it "s3 path should equal to ...", ->
    params = store.prepare fake
    params.Key.should.eql 'sample.txt'
    params.ContentLength.should.eql 100

  it "config file should exist", ->
    exist = fse.existsSync config.s3Path
    exist.should.eql true

  it "config file should not exist", ->
    exist = fse.existsSync configWithoutJSONFile.s3Path
    exist.should.eql false

  it "test store process", ->
    ret = store.process fake
    ret2 = storeWithoutJSONFile.process fake
    (ret instanceof Object).should.eql true
    (ret2 instanceof Object).should.eql true



