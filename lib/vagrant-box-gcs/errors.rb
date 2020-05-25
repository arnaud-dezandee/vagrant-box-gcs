module VagrantPlugins
  module BoxGCS
    module Errors
      class VagrantBoxGCSError < Vagrant::Errors::VagrantError
        error_namespace('vagrant_box_gcs.errors')
      end

      class CredentialsError < VagrantBoxGCSError
        error_key(:credentials)
      end

      class MissingFileError < VagrantBoxGCSError
        error_key(:missing_file)
      end

      class UnauthorizedError < VagrantBoxGCSError
        error_key(:unauthorized)
      end

    end
  end
end
