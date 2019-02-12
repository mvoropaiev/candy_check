module CandyCheck
  module AppStore
    # Verifies a latest_receipt_info block against a verification server.
    # The call return either an {VerificationResponse}
    # or a {VerificationFailure}
    class SubscriptionVerification < CandyCheck::AppStore::Verification
      # Performs the verification against the remote server
      # @return [VerificationResponse] if successful
      # @return [VerificationFailure] otherwise
      def call!
        verify!
        raise VerificationFailure, @response['status'] unless valid?

        VerificationResponse.new(@response)
      end

      private

      def valid?
        status_is_ok = @response['status'] == STATUS_OK
        @response && status_is_ok && @response['latest_receipt_info']
      end
    end
  end
end
