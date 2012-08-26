module Paperclip
  module Qiniu
    class Error < StandardError; end
    class UploadFailed < Error; end
  end
end
