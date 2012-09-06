module Paperclip
  module Qiniu
    module ActionViewExtensions
      module QiniuImageTag
        def qiniu_image_tag(source, options={})
          options.symbolize_keys!

          src = path_to_image(source)
          options[:src] = qiniu_image_path(src, options)

          unless src =~ /^(?:cid|data):/ || src.blank?
            options[:alt] = options.fetch(:alt){ image_alt(src) }
          end

          if size = options.delete(:size)
            options[:width], options[:height] = size.split("x") if size =~ %r{^\d+x\d+$}
          end

          if mouseover = options.delete(:mouseover)
            options[:onmouseover] = "this.src='#{path_to_image(mouseover)}'"
            options[:onmouseout]  = "this.src='#{options[:src]}'"
          end

          tag("img", options)
        end
      end
    end
  end
end

ActionView::Base.send :include, Paperclip::Qiniu::ActionViewExtensions::QiniuImageTag
