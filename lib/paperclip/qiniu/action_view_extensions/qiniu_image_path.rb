module Paperclip
  module Qiniu
    module ActionViewExtensions
      module QiniuImagePath
        def qiniu_image_path(source, options={})
          options = options.clone
          thumbnail = options.delete(:thumbnail)
          gravity = options.delete(:gravity)
          crop = options.delete(:crop)
          quality = options.delete(:quality)
          rotate = options.delete(:rotate)
          format = options.delete(:format)
          auto_orient = options.delete(:auto_orient)
          res = source
          res += "?imageMogr"
          res += "/thumbnail/#{CGI.escape thumbnail}" if thumbnail
          res += "/gravity/#{CGI.escape gravity}" if gravity
          res += "/crop/#{CGI.escape crop}" if crop
          res += "/quality/#{CGI.escape quality.to_s}" if quality
          res += "/rotate/#{CGI.escape rotate.to_s}" if rotate
          res += "/format/#{CGI.escape format.to_s}" if format
          res += "/auto-orient" if auto_orient
          if res.end_with? '?imageMogr'
            source
          else
            res
          end
        end
      end
    end
  end
end

ActionView::Base.send :include, Paperclip::Qiniu::ActionViewExtensions::QiniuImagePath
