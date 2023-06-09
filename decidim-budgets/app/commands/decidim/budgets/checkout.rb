# frozen_string_literal: true

module Decidim
  module Budgets
    # A command with all the business to checkout.
    class Checkout < Decidim::Command
      # Public: Initializes the command.
      #
      # order - The current order for the user.
      def initialize(order)
        @order = order
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the there is an error.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid, order) unless checkout!

        broadcast(:ok, order)
      end

      private

      attr_reader :order

      def checkout!
        return unless order && order.valid?

        @order.with_lock do
          SendOrderSummaryJob.perform_later(@order)

          Decidim.traceability.update!(
            @order,
            @order.user,
            { checked_out_at: Time.current },
            visibility: "private-only"
          )
        rescue ActiveRecord::RecordInvalid
          false
        end
      end
    end
  end
end
