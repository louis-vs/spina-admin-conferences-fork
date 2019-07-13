# frozen_string_literal: true

require 'webpacker'

module Spina
  module Conferences
    module WebpackHelper #:nodoc:
      include ::Webpacker::Helper

      helper_methods = ::Webpacker::Helper.public_instance_methods false
      helper_methods.delete :current_webpacker_instance
      helper_methods.each do |method|
        alias_method :"base_#{method}", :"#{method}"
        redefine_method method do |*args, **options|
          @webpacker = options.delete(:instance) || ::Webpacker.instance
          send :"base_#{method}", *args, **options
        end
      end

      private

      def current_webpacker_instance
        @webpacker
      end
    end
  end
end
