# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class InstitutionsTest < ApplicationSystemTestCase
        setup do
          @institution = spina_admin_conferences_institutions :university_of_atlantis
          @empty_institution = spina_admin_conferences_institutions :empty_institution

          authenticate
        end

        test 'visiting the index' do
          visit admin_conferences_institutions_path
          assert_text 'Institutions'
          Percy.snapshot page, name: 'Institutions index'
        end

        test 'creating an institution' do
          skip 'Not currently worth the time trying to figure this one out.'
          visit admin_conferences_institutions_path
          click_on 'New institution'
          assert_text 'New institution'
          fill_in 'institution_name', with: @institution.name
          fill_in 'institution_city', with: @institution.city
          click_on 'Choose image'
          within '#media_picker' do
            first('button').click
          end
          click_on 'Insert image'
          Percy.snapshot page, name: 'Institutions form on create'
          click_on 'Save institution'
          assert_current_path admin_conferences_institutions_path
          assert_text 'Institution saved'
          Percy.snapshot page, name: 'Institutions index on create'
        end

        test 'updating an institution' do
          skip 'Not currently worth the time trying to figure this one out.'
          visit admin_conferences_institutions_path
          within "tr[data-institution-id=\"#{@institution.id}\"]" do
            click_on 'Edit'
          end
          assert_text @institution.name
          Percy.snapshot page, name: 'Institutions form on update'
          fill_in 'institution_name', with: @institution.name
          fill_in 'institution_city', with: @institution.city
          click_on 'Choose image'
          within '#media_picker' do
            first('button').click
          end
          click_on 'Insert image'
          click_on 'Save institution'
          assert_current_path admin_conferences_institutions_path
          assert_text 'Institution saved'
          Percy.snapshot page, name: 'Institutions index on update'
        end

        test 'destroying an institution' do
          skip 'Not currently sure how to click this button...'
          visit admin_conferences_institutions_path
          within "tr[data-institution-id=\"#{@empty_institution.id}\"]" do
            click_on 'Edit'
          end
          assert_text @empty_institution.name
          accept_confirm "Are you sure you want to delete the institution <strong>#{@empty_institution.name}</strong>?" do
            click_on 'Permanently delete'
            Percy.snapshot page, name: 'Institutions delete dialog'
          end
          assert_current_path admin_conferences_institutions_path
          assert_text 'Institution deleted'
          assert_no_selector "tr[data-institution-id=\"#{@empty_institution.id}\"]"
          Percy.snapshot page, name: 'Institutions index on delete'
        end
      end
    end
  end
end
