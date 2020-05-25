require 'pathname'
require 'json'
require 'google/cloud/storage'

module VagrantPlugins
  module BoxGCS
    class Storage
      def self.init!
        return if defined?(@storage)

        begin
          @storage = Google::Cloud::Storage.new
        rescue => e
          raise Errors::CredentialsError,
            name: e.class.to_s,
            message: e.message
        end
      end

      def self.remote_file(uri)
        init!
        begin
          bucket = @storage.bucket uri.host
          bucket.file uri.path[1..-1]
        rescue => e
          body = JSON.parse(e.body)
          raise Errors::UnauthorizedError,
            name: e.message,
            code: e.status_code,
            message: body['error']['message']
        end
      end

      def self.metadata_url?(uri)
        init!
        file = remote_file(uri)
        file.content_type == 'application/json'
      end

      def self.download(uri, dest)
        init!
        file = remote_file(uri)
        raise Errors::MissingFileError, message: "No URLs matched: #{uri}" if file.nil?

        downloaded = file.download dest
        Pathname.new(downloaded.path)
      end
    end
  end
end
