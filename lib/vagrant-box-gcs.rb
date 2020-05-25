require 'vagrant-box-gcs/version'
require 'vagrant-box-gcs/plugin'
require 'vagrant-box-gcs/errors'

module VagrantPlugins
  module BoxGCS
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end

    I18n.load_path << File.expand_path('locales/en.yml', source_root)
    I18n.reload!
  end
end
