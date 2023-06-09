# frozen_string_literal: true

module Decidim
  module Devise
    # Custom Devise UnlocksController to avoid namespace problems.
    class UnlocksController < ::Devise::UnlocksController
      include Decidim::DeviseControllers

      private

      # Since we are using a single Devise installation for multiple
      # organizations, and user emails can be repeated across organizations,
      # we need to identify the user by both the email and the organization.
      # Setting the organization ID here will be used by Devise internally to
      # find the correct user.
      #
      # Note that in order for this to work we need to define the `reset_password_keys`
      # Devise attribute in the `Decidim::User` model to include the
      # `decidim_organization_id` attribute.
      def resource_params
        super.merge(decidim_organization_id: current_organization.id)
      end
    end
  end
end
