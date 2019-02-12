module CandyCheck
  module AppStore
    # Represents a failing call against the verification server
    class VerificationFailure < StandardError
      # @return [Fixnum] the code of the failure
      attr_reader :code

      # Initializes a new instance which bases on a JSON result
      # from Apple servers
      # @param code [Fixnum]
      def initialize(code)
        @code = Integer(code)
      end

      def message
        case @code
        when 21_000
          'The App Store could not read the JSON object you provided.'
        when 21_002
          'The data in the receipt-data property was malformed.'
        when 21_003
          'The receipt could not be authenticated.'
        when 21_004
          'The shared secret you provided does not match the shared secret ' \
          'on file for your account.'
        when 21_005
          'The receipt server is not currently available.'
        when 21_006
          'This receipt is valid but the subscription has expired. ' \
          'When this status code is returned to your server, the receipt ' \
          'data is also decoded and returned as part of the response.'
        when 21_007
          'This receipt is a sandbox receipt, but it was sent to the ' \
          'production service for verification.'
        when 21_008
          'This receipt is a production receipt, but it was sent to the ' \
          'sandbox service for verification.'
        else
          "Cannot validate receipt, code: #{@code}"
        end
      end
    end
  end
end
