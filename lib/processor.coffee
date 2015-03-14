_ = require 'lodash/object'
im = require 'imagemagick-native'

module.exports = class Processor
  constructor: (@config)->
    defaultConf =
      quality: 70
      resizeStyle: 'aspectfill'
      gravity: 'Center'
    @config = _.assign defaultConf, @getSize(), @config

  process: (data)->
    @config.srcData = data
    @fixQualityForPNG()
    im.convert @config

  getSize: ()->
    s = @config.size.split 'x'
    width: s[0], height: s[1]

  fixQualityForPNG: () ->
    if @config.format == "PNG"
      @config.quality = 100 - @config.quality
      @config.quality = 1 unless @config.quality > 0
