# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # @abstract Subclass to implement a custom controller.
      class ApplicationController < ::Spina::Admin::AdminController
        helper ::Spina::Engine.routes.url_helpers

        add_flash_types :success

        layout :admin_layout

        before_action :set_locale

        admin_section :conferences

        private

        def admin_layout
          'spina/admin/admin'
        end

        def set_locale
          @locale = params[:locale] || I18n.default_locale
        end
      end
    end
  end
end
