# frozen_string_literal: true

module Spina
  module Conferences
    class ApplicationMailer < ActionMailer::Base #:nodoc:
      default from: 'from@example.com'
      layout 'mailer'
    end
  end
end
