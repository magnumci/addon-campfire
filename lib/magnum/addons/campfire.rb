require "magnum/addons/campfire/version"
require "magnum/addons/campfire/error"
require "magnum/addons/campfire/message"

require "json"
require "faraday"
require "hashr"

module Magnum
  module Addons
    class Campfire
      def initialize(options = {})
        @api_token = options[:api_token]
        @subdomain = options[:subdomain]
        @room      = options[:room]

        validate_options
      end

      def run(build)
        deliver(Message.new(build))
      end

      private

      def deliver(message)
        message.to_a.each do |line|
          make_api_request(line)
        end
      end

      def validate_options
        raise Error, "API token required" if @api_token.nil?
        raise Error, "Subdomain required" if @subdomain.nil?
        raise Error, "Room required"      if @room.nil?
      end

      def connection
        @connection ||= Faraday.new("https://#{@subdomain}.campfirenow.com", {}) do |c|
          c.adapter(Faraday.default_adapter)
          c.basic_auth(@api_token, "x")
        end
      end

      def make_api_request(line)
        path    = "/room/#{@room}/speak.json"
        payload = { message: { body: line } }
        headers = { "Content-Type" => "application/json" }
 
        response = connection.send(:post, path) do |request|
          request.headers.update(headers)
          request.body = JSON.dump(payload)
        end

        unless response.success?
          handle_error(response)
        end
      end

      def handle_error(response)
        case response.status
        when 401
          raise Error, "Invalid credentials"
        when 404
          raise Error, "Invalid room"
        else
          raise Error, "Delivery failed"
        end
      end
    end
  end
end
