require 'vagrant'

module VagrantPlugins
  module BoxGCS
    class Plugin < Vagrant.plugin('2')
      name 'BoxGCS'
      description 'Vagrant plugin to download boxes from Google GCS.'

      action_hook(:authenticate_box_gcs, :authenticate_box_url) do |hook|
        require_relative 'middleware/init'
        hook.prepend(Init)
      end

      def self.init!
        return if defined?(@_init)

        ENV['GOOGLE_AUTH_SUPPRESS_CREDENTIALS_WARNINGS'] = 'true'
        require_relative 'storage'
        require_relative 'extensions/box_add'
        require_relative 'extensions/box'
        @_init = true
      end
    end
  end
end
