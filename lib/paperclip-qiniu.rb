require "paperclip-qiniu/version"
require 'paperclip/storage/qiniu'
require 'paperclip/qiniu/action_view_extensions/qiniu_image_path' if defined?(ActionView)
require 'paperclip/qiniu/action_view_extensions/qiniu_image_tag' if defined?(ActionView)
