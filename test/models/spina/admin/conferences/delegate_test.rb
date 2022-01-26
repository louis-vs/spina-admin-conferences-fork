# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DelegateTest < ActiveSupport::TestCase
        include ActiveJob::TestHelper

        setup do
          @delegate = spina_admin_conferences_delegates :joe_bloggs
          @new_delegate = Delegate.new
        end

        test 'delegates have sorted scope' do
          assert_equal Delegate.order(:last_name, :first_name), Delegate.sorted
        end

        test 'delegate has associated institution' do
          assert_not_nil @delegate.institution
        end

        test 'delegate has associated conferences' do
          assert_not_empty @delegate.conferences
        end

        test 'delegate has associated presentations' do
          assert_not_empty @delegate.presentations
        end

        test 'delegate has associated dietary requirements' do
          assert_not_empty @delegate.dietary_requirements
        end

        test 'institution must not be empty' do
          assert @delegate.valid?
          assert_empty @delegate.errors[:institution]
          @delegate.institution = nil
          assert @delegate.invalid?
          assert_not_empty @delegate.errors[:institution]
        end

        test 'first name must not be empty' do
          assert @delegate.valid?
          assert_empty @delegate.errors[:first_name]
          @delegate.first_name = nil
          assert @delegate.invalid?
          assert_not_empty @delegate.errors[:first_name]
        end

        test 'last name must not be empty' do
          assert @delegate.valid?
          assert_empty @delegate.errors[:last_name]
          @delegate.last_name = nil
          assert @delegate.invalid?
          assert_not_empty @delegate.errors[:last_name]
        end

        test 'email address must be email address' do
          assert @delegate.valid?
          assert_empty @delegate.errors[:email_address]
          @delegate.email_address = 'foo'
          assert @delegate.invalid?
          assert_not_empty @delegate.errors[:email_address]
        end

        test 'URL must be HTTP(S) URL' do
          assert @delegate.valid?
          assert_empty @delegate.errors[:url]
          @delegate.url = 'ftp://www.bbc.co.uk'
          assert @delegate.invalid?
          assert_not_empty @delegate.errors[:url], 'wrong protocol adds error'
          @delegate.restore_attributes
          @delegate.url = '\\'
          assert @delegate.invalid?
          assert_not_empty @delegate.errors[:url], 'malformed URL adds error'
        end

        test 'performs import job' do
          file_fixture('delegates.csv.erb').read
                                           .then { |file| ERB.new(file).result(binding) }
                                           .then { |result| Pathname.new(File.join(file_fixture_path, 'delegates.csv')).write(result) }
          assert_enqueued_jobs 1, only: DelegateImportJob do
            Delegate.import file_fixture('delegates.csv')
          end
        end

        test 'returns localized full name' do
          assert_equal Delegate.human_attribute_name(:full_name, first_name: @delegate.first_name,
                                                                 last_name: @delegate.last_name),
                       @delegate.full_name
          assert_nil @new_delegate.full_name
        end

        test 'returns localized full name and institution' do
          assert_equal Delegate.human_attribute_name(:name_and_institution, name: @delegate.full_name,
                                                                            institution: @delegate.institution.name),
                       @delegate.full_name_and_institution
          assert_nil @new_delegate.full_name_and_institution
        end

        test 'returns localized reversed name' do
          assert_equal Delegate.human_attribute_name(:reversed_name, first_name: @delegate.first_name,
                                                                     last_name: @delegate.last_name),
                       @delegate.reversed_name
          assert_nil @new_delegate.reversed_name
        end

        test 'returns localized reversed name and institution' do
          assert_equal Delegate.human_attribute_name(:name_and_institution, name: @delegate.reversed_name,
                                                                            institution: @delegate.institution.name),
                       @delegate.reversed_name_and_institution
          assert_nil @new_delegate.reversed_name_and_institution
        end
      end
    end
  end
end
