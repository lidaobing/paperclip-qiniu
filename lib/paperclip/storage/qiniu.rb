require 'paperclip-qiniu/exceptions'

module Paperclip
  module Storage
    module Qiniu
      def self.extended base
        begin
          require 'qiniu'
        rescue LoadError => e
          e.message << " (You may need to install the qiniu gem)"
          raise e
        end unless defined?(::Qiniu)

        base.instance_eval do
          unless @options[:url].to_s.match(/^:fog.*url$/)
            @options[:qiniu_permissions] = @options[:qiniu_permissions] || 'private'
            @options[:path]  = @options[:path].gsub(/:url/, @options[:url])
            @options[:url]   = ':qiniu_file_url'
          end
          Paperclip.interpolates(:qiniu_file_url) do |attachment, style|
            attachment.file_url(style)
          end unless Paperclip::Interpolations.respond_to? :qiniu_file_url
        end

      end

      def exists?(style = default_style)
        init
        !!::Qiniu.stat(bucket, path(style))
      end

      def flush_writes
        init
        for style, file in @queued_for_write do
          log("saving #{path(style)}")
          retried = false
          begin
            upload(file, path(style))
          ensure
            file.rewind
          end
        end

        after_flush_writes # allows attachment to clean up temp files

        @queued_for_write = {}
      end

      def flush_deletes
        init
        for path in @queued_for_delete do
          ::Qiniu.delete(bucket, path)
        end
        @queued_for_delete = []
      end

      def file_url(style = default_style)
        if @options[:qiniu_permissions] == 'public'
          public_url(style)
        else
          private_url(style)
        end
      end

      def private_url(style = default_style)
        init
        if @options[:qiniu_host]
          primitive_url = "#{dynamic_fog_host_for_style(style)}#{path(style)}"
          ::Qiniu::Auth.authorize_download_url(primitive_url)
        else
          res = ::Qiniu.get(bucket, path(style))
          if res
            res["url"]
          else
            nil
          end
        end
      end

      def public_url(style = default_style)
        init
        if @options[:qiniu_host]
          "#{dynamic_fog_host_for_style(style)}/#{path(style)}"
        else
          res = ::Qiniu.get(bucket, path(style))
          if res
            res["url"]
          else
            nil
          end
        end
      end

      private

      def init
        return if @inited
        ::Qiniu.establish_connection! @options[:qiniu_credentials]
        inited = true
      end

      def upload(file, path)
        upload_token = ::Qiniu.generate_upload_token :scope => bucket
        opts = {:uptoken            => upload_token,
                 :file               => file.path,
                 :key                => path,
                 :bucket             => bucket,
                 :mime_type          => file.content_type,
                 :enable_crc32_check => true}
        unless ::Qiniu.upload_file(opts)
          raise Paperclip::Qiniu::UploadFailed
        end
      end

      def bucket
        bucket_name = @options[:bucket]
        bucket_name = bucket_name.call(self) if bucket_name.respond_to?(:call)
        bucket_name || raise("bucket is nil")
      end

      def dynamic_fog_host_for_style(style)
        if @options[:qiniu_host].respond_to?(:call)
          @options[:qiniu_host].call(self)
        else
          @options[:qiniu_host]
        end
      end
    end
  end

  class UrlGenerator    #small fix: not to escape '?'
    private
    def escape_regex
      /[\(\)\[\]\+]/
    end
  end
end


