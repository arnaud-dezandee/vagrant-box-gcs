require "uri"

module VagrantPlugins
  module BoxGCS
    class Init
      def initialize(app, _env)
        @app = app
      end

      def call(env)
        env[:box_urls].map! do |url|
          begin
            u = URI.parse(url)
            if u.scheme == 'gs'
              BoxGCS::Plugin.init!
            end
            url
          rescue URI::Error
            url
          end
        end

        @app.call(env)
      end.freeze
    end
  end
end
