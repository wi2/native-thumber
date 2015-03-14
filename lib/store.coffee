AWS = require 'aws-sdk'
fse = require 'fs-extra'

###*
 * StoreS3
 * Store file in Amazon S3
###
module.exports.StoreS3 = class StoreS3
  constructor: (@config)->
    try
      AWS.config.loadFromPath(@config.s3Path or './config/s3.json')
    catch err
      console.log err
    @s3 = new AWS.S3()

  prepare: (__newFile)->
    params =
      Bucket: @config.bucket
      Key: __newFile.filename
      Body: __newFile.Body
      ContentLength: __newFile.byteCount
      ACL:'public-read'

  process: (__newFile, done)->
    filename = __newFile.filename
    console.log filename
    @s3.putObject @prepare(__newFile), (err, data)->
      if err
        console.log err
      else
        console.log 'Successfully uploaded the file', filename
      done() if done

###*
 * StoreLocale
 * store file in locale folder
###
module.exports.StoreLocale = class StoreLocale
  constructor: (@config)->

  prepare: (__newFile)->
    __newFile.Body

  process: (__newFile, done)->
    filename = __newFile.filename
    fse.outputFile filename, @prepare(__newFile), (err)->
      if err
        console.log err
      else
        console.log 'Successfully uploaded the file', filename
      done() if done
