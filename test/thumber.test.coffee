_ = require 'lodash'
Thumber = require '../lib/thumber'
fse = require 'fs-extra'


describe "Thumber testing", ->
  thumber = ''
  thumberLocale = ''
  thumberLocaleFormat = ''
  config =
    store: 's3'
    s3Path:'./config.json'
    quality: 60
    bucket: 'bucket'
    directory: 'images/output/'
    blur: 5
    schemas: [
      {version: 'thumb', size: '50x50'},
      {version: 'carousel', size: '200x120', quality: 85}
    ]
  configLocale =
    store: 'locale'
    quality: 55
    directory: 'images/output/'
    schemas: [
      {version: 'thumb', size: '50x50'},
      {version: 'blur', size: '250x250', blur: 10},
      {version: 'flip', size: '250x250', flip: true},
      {version: 'rotate', size: '250x250', rotate: 90},
      {version: 'mirror', size: '250x250', rotate: 180, flip: true},
      {version: 'carousel', size: '200x120'},
      {version: 'big', size: '800x800'},
      {version: 'S', size: '800x800', quality: 10},
      {version: 'M', size: '800x800', quality: 40},
      {version: 'L', size: '800x800', quality: 70},#better quality
      {version: 'verybig', size: '2000x2000', quality: 55}
    ]

  configLocaleFormat = _.assign {}, configLocale, {format: "JPG"}

  before ->
    fse.removeSync "#{process.cwd()}/images/output/*.*"
  # beforeEach ->
    thumber = new Thumber config
    thumberLocale = new Thumber configLocale
    thumberLocaleFormat = new Thumber configLocaleFormat

  it "original fullname should equal to images/output/test.png", ->
    thumber.fullname("test.png").should.eql "images/output/test.png"

  it "thumb fullname should equal to images/output/test-thumb.png", ->
    thumber.fullname("test.png", "thumb").should.eql "images/output/test-thumb.png"

  it "big fullname should equal to images/output/test-big.png", ->
    thumber.fullname("test.png", "big").should.eql "images/output/test-big.png"

  describe "remove process", ->
    it "should not find anyfile in images/output", (done) ->
      fse.existsSync("#{process.cwd()}/images/output/sample.png").should.eql false
      fse.existsSync("#{process.cwd()}/images/output/sample-*.png").should.eql false
      done()

  describe "add process", ->
    it "should add file in images/output", (done) ->
      thumberLocale.process "#{process.cwd()}/images/sample.png", "sample.png", "123456", (err, data) ->
        fse.existsSync("#{process.cwd()}/images/output/sample-verybig.png").should.eql true
        fse.existsSync("#{process.cwd()}/images/output/sample-carousel.png").should.eql true
        fse.existsSync("#{process.cwd()}/images/output/sample-thumb.png").should.eql true
        fse.existsSync("#{process.cwd()}/images/output/sample.png").should.eql true
        done()

  describe "check size", ->
    it "thumb file should be sizeless than caroussel file", (done) ->
      carou = fse.statSync("#{process.cwd()}/images/output/sample-carousel.png")
      thumb = fse.statSync("#{process.cwd()}/images/output/sample-thumb.png")
      carou['size'].should.be.above thumb['size']
      done()

    it "thumb size file by (quality)", (done) ->
      big = fse.statSync("#{process.cwd()}/images/output/sample-big.png")
      S = fse.statSync("#{process.cwd()}/images/output/sample-S.png")
      M = fse.statSync("#{process.cwd()}/images/output/sample-M.png")
      L = fse.statSync("#{process.cwd()}/images/output/sample-L.png")

      big['size'].should.be.above M['size']
      L['size'].should.be.above big['size']

      L['size'].should.be.above M['size']
      M['size'].should.be.above S['size']
      done()

  describe "add new process with change format to jpg", ->
    it "should add file in images/output", (done) ->
      thumberLocaleFormat.process "#{process.cwd()}/images/sample.png", "sample.jpg", "123456", (err, data) ->
        fse.existsSync("#{process.cwd()}/images/output/sample-verybig.jpg").should.eql true
        fse.existsSync("#{process.cwd()}/images/output/sample-carousel.jpg").should.eql true
        fse.existsSync("#{process.cwd()}/images/output/sample-thumb.jpg").should.eql true
        fse.existsSync("#{process.cwd()}/images/output/sample.jpg").should.eql true
        done()


  describe "check size format jpg", ->
    it "thumb file should be sizeless than caroussel file", (done) ->
      carou2 = fse.statSync("#{process.cwd()}/images/output/sample-carousel.jpg")
      thumb2 = fse.statSync("#{process.cwd()}/images/output/sample-thumb.jpg")
      carou2['size'].should.be.above thumb2['size']
      done()

    it "thumb size file by (quality)", (done) ->
      big2 = fse.statSync("#{process.cwd()}/images/output/sample-big.jpg")
      S2 = fse.statSync("#{process.cwd()}/images/output/sample-S.jpg")
      M2 = fse.statSync("#{process.cwd()}/images/output/sample-M.jpg")
      L2 = fse.statSync("#{process.cwd()}/images/output/sample-L.jpg")

      big2['size'].should.be.above M2['size']
      L2['size'].should.be.above big2['size']

      L2['size'].should.be.above M2['size']
      M2['size'].should.be.above S2['size']
      done()

