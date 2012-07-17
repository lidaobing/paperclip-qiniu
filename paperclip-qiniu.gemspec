# -*- encoding: utf-8 -*-
require File.expand_path('../lib/paperclip-qiniu/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["LI Daobing"]
  gem.email         = ["lidaobing@gmail.com"]
  gem.description   = %q{paperclip plugin for qiniu}
  gem.summary       = %q{paperclip plugin for qiniu}
  gem.homepage      = "https://github.com/lidaobing/paperclip-qiniu"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "paperclip-qiniu"
  gem.require_paths = ["lib"]
  gem.version       = Paperclip::Qiniu::VERSION
  gem.add_dependency 'paperclip'
  gem.add_dependency 'qiniu-rs'
  gem.add_development_dependency 'rspec'
end
