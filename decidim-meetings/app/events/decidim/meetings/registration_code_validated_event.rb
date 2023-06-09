# frozen_string_literal: true

module Decidim
  module Meetings
    class RegistrationCodeValidatedEvent < Decidim::Events::SimpleEvent
      include Decidim::Meetings::MeetingEvent

      i18n_attributes :registration_code

      private

      def registration_code
        extra["registration"]["code"]
      end
    end
  end
end
