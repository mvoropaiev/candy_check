module CandyCheck
  module AppStore
    # Simple HTTP client to load the receipt's data from Apple's verification
    # servers (either sandbox or production).
    class Client
      require 'faraday_middleware'

      # Initialize a new client bound to an endpoint
      # @param endpoint_url [String]
      def initialize(endpoint_url)
        @endpoint_url = endpoint_url
      end

      # Contacts the configured endpoint and requests the receipt's data
      # @param receipt_data [String] base64 encoded data string from the app
      # @param secret [String] the password for auto-renewable subscriptions
      # @return [Hash]
      def verify(receipt_data, secret = nil)
        response = perform_request(
          build_request_parameters(receipt_data, secret)
        )
        response.body
      end

      private

      def perform_request(parameters)
        build_http_connector.post do |req|
          req.body = parameters
        end
      end

      def build_http_connector
        Faraday.new(url: @endpoint_url) do |faraday|
          faraday.request :json
          faraday.response :json
          faraday.adapter Faraday.default_adapter
        end
      end

      def build_request_parameters(receipt_data, secret)
        { 'receipt-data' => receipt_data }.tap do |h|
          h['password'] = secret if secret
        end
      end
    end
  end
end
