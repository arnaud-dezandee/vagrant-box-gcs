$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "vagrant-box-gcs/version"

Gem::Specification.new do |gem|
  gem.name          = "vagrant-box-gcs"
  gem.version       = VagrantPlugins::BoxGCS::VERSION

  gem.authors       = ["Arnaud Dezandee"]
  gem.email         = ["dezandee.arnaud@gmail.com"]
  gem.homepage      = "http://www.vagrantup.com"
  gem.license       = "MIT"
  gem.summary       = "Vagrant plugin to download boxes from Google GCS."

  gem.files         = `git ls-files -- lib/* locales/*`.split("\n") + ["README.md", "LICENSE"]
  gem.require_paths = ["lib"]

  gem.required_ruby_version = ">= 2.4"
  gem.add_dependency "google-cloud-storage", "~> 1.26.1"
end
