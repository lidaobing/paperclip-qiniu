module Paperclip
  module Qiniu
    module ActionViewExtensions
      module QiniuImagePath
        def qiniu_image_path(source, options={})
          thumbnail = options.delete(:thumbnail)
          res = source
          res += "?imageMogr" if thumbnail
          res += "/thumbnail/#{CGI.escape thumbnail}" if thumbnail
          res.html_safe
        end
      end
    end
  end
end

ActionView::Base.send :include, Paperclip::Qiniu::ActionViewExtensions::QiniuImagePath
