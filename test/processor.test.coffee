Processor = require '../lib/processor'
fse = require 'fs-extra'

describe "Image Native Processor", ->
  processor = ''

  beforeEach ->
    processor = new Processor
      quality: 80
      size: '160x80'

  it "should parse size", ->
    size = processor.getSize()
    size.width.should.eql '160'
    size.height.should.eql '80'

  describe 'constructor process', ->
    it "should quality be 80", ->
      processor.config.quality.should.eql 80

    it "should quality not be 70 (default)", ->
      processor.config.quality.should.not.eql 70

    it "should gravity be Center", ->
      processor.config.gravity.should.eql 'Center'


