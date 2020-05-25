require 'tempfile'
require 'uri'

module BoxExtension
  def load_metadata(**download_options)
    uri = URI.parse(@metadata_url)
    if uri.scheme == 'gs'
      tf = Tempfile.new('vagrant-load-metadata')
      tf.close
      VagrantPlugins::BoxGCS::Storage.download(uri, tf.path)
      Vagrant::BoxMetadata.new(File.open(tf.path, 'r'))
    else
      super(**download_options)
    end
  end
end

module Vagrant
  class Box
    prepend BoxExtension
  end
end
