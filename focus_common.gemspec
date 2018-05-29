# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'focus_common/version'

Gem::Specification.new do |spec|
  spec.name = 'focus_common'
  spec.version = FocusCommon::VERSION
  spec.authors = ['linjunhalida']
  spec.email = ['linjunhalida@gmail.com']
  spec.summary = %q{Common library for Focus Solution Inc Rails projects}
  spec.description = %q{Common library for Focus Solution Inc Rails projects}
  spec.homepage = 'https://github.com/halida/focus_common'
  spec.license = 'LGPL-3.0'

  spec.required_ruby_version     = '>= 1.9.3'
  spec.files = `git ls-files`.split($/)
  spec.require_paths = ['lib']

end
