require 'digest/sha1'
require 'uri'

module BoxAddExtension
  def metadata_url?(url, env)
    uri = URI.parse(url)
    if uri.scheme == 'gs'
      VagrantPlugins::BoxGCS::Storage.metadata_url?(uri)
    else
      super(url, env)
    end
  end

  def download(url, env, **opts)
    opts[:ui] = true if !opts.key?(:ui)
    uri = URI.parse(url)
    if uri.scheme == 'gs'
      if (opts[:ui])
        env[:ui].detail(I18n.t('vagrant.box_downloading', url: uri.to_s))
      end
      temp_path = env[:tmp_path].join('box' + Digest::SHA1.hexdigest(uri.to_s))
      VagrantPlugins::BoxGCS::Storage.download(uri, temp_path.to_s)
    else
      super(url, env, **opts)
    end
  end
end

module Vagrant
  module Action
    module Builtin
      class BoxAdd
        prepend BoxAddExtension
      end
    end
  end
end
