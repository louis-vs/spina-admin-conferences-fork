# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class DelegatesTest < ApplicationSystemTestCase
        setup do
          @delegate = spina_admin_conferences_delegates :joe_bloggs

          authenticate
        end

        test 'visiting the index' do
          visit admin_conferences_delegates_path
          assert_text 'Delegates'
          Percy.snapshot page, name: 'Delegates index'
        end

        test 'creating a delegate' do
          skip 'Not currently worth the time trying to figure this one out.'
          visit admin_conferences_delegates_path
          click_on 'New delegate'
          assert_text 'New delegate'
          fill_in 'delegate_first_name', with: @delegate.first_name
          fill_in 'delegate_last_name', with: @delegate.last_name
          select @delegate.institution.name, from: 'delegate_institution_id'
          fill_in 'delegate_email_address', with: @delegate.email_address
          fill_in 'delegate_url', with: @delegate.url
          @delegate.conferences.each { |conference| check conference.name, allow_label_click: true }
          Percy.snapshot page, name: 'Delegates form on create'
          click_on 'Save delegate'
          assert_current_path admin_conferences_delegates_path
          assert_text 'Delegate saved'
          Percy.snapshot page, name: 'Delegates index on create'
        end

        test 'updating a delegate' do
          skip 'Not currently worth the time trying to figure this one out.'
          visit admin_conferences_delegates_path
          within "tr[data-delegate-id=\"#{@delegate.id}\"]" do
            click_on 'Edit'
          end
          assert_text @delegate.full_name
          Percy.snapshot page, name: 'Delegates form on update'
          fill_in 'delegate_first_name', with: @delegate.first_name
          fill_in 'delegate_last_name', with: @delegate.last_name
          select @delegate.institution.name, from: 'delegate_institution_id'
          fill_in 'delegate_email_address', with: @delegate.email_address
          fill_in 'delegate_url', with: @delegate.url
          @delegate.conferences.each { |conference| check conference.name, allow_label_click: true }
          click_on 'Save delegate'
          assert_current_path admin_conferences_delegates_path
          assert_text 'Delegate saved'
          Percy.snapshot page, name: 'Delegates index on update'
        end

        test 'destroying a delegate' do
          skip 'Not currently sure how to click this button...'
          visit admin_conferences_delegates_path
          within "tr[data-delegate-id=\"#{@delegate.id}\"]" do
            click_on 'Edit'
          end
          assert_text @delegate.full_name
          accept_confirm "Are you sure you want to delete the delegate <strong>#{@delegate.full_name}</strong>?" do
            click_on 'Permanently delete'
            Percy.snapshot page, name: 'Delegates delete dialog'
          end
          assert_current_path admin_conferences_delegates_path
          assert_text 'Delegate deleted'
          assert_no_selector "tr[data-delegate-id=\"#{@delegate.id}\"]"
          Percy.snapshot page, name: 'Delegates index on delete'
        end
      end
    end
  end
end
