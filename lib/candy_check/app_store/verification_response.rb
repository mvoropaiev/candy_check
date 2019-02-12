module CandyCheck
  module AppStore
    class VerificationResponse
      attr_reader :attributes
      attr_reader :status
      attr_reader :latest_receipt_info
      attr_reader :latest_receipt
      attr_reader :auto_renew_status
      attr_reader :auto_renew_product_id

      def initialize(attributes)
        @attributes = attributes
        @status = attributes['status']

        @receipt = Receipt.new(attributes['receipt'])
        @latest_receipt_info = ReceiptCollection.new(
          attributes['latest_receipt_info']
        )
        @latest_receipt = attributes['latest_receipt']

        @auto_renew_product_id = attributes['auto_renew_product_id']
        @auto_renew_status = attributes['auto_renew_status']
      end

      def subscription_active?
        if @latest_receipt_info.last
          @latest_receipt_info.last.expires_date_ms >= Time.zone.now
        else
          false
        end
      end

      def expiry_date
        @latest_receipt_info.last&.expires_date_ms
      end
    end
  end
end
