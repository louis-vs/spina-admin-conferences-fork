# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class SessionsTest < ApplicationSystemTestCase
        setup do
          @session = spina_admin_conferences_sessions :oral_1_lecture_block_2_uoa_2017
          @empty_session = spina_admin_conferences_sessions :empty_session

          authenticate
        end

        test 'visiting the index' do
          visit admin_conferences_sessions_path
          assert_text 'Sessions'
          Percy.snapshot page, name: 'Sessions index'
        end

        test 'creating a session' do
          visit admin_conferences_sessions_path
          click_on 'New session'
          assert_text 'New session'
          fill_in 'session_name', with: @session.name
          select @session.conference.name, from: 'conference_id'
          select @session.presentation_type.name, from: 'session_presentation_type_id'
          select @session.institution.name, from: 'institution_id'
          select @session.room.name, from: 'session_room_id'
          Percy.snapshot page, name: 'Sessions form on create'
          click_on 'Save session'
          assert_current_path admin_conferences_sessions_path
          assert_text 'Session saved'
          Percy.snapshot page, name: 'Sessions index on create'
        end

        test 'updating a session' do
          visit admin_conferences_sessions_path
          within "tr[data-session-id=\"#{@session.id}\"]" do
            click_on 'Edit'
          end
          assert_text @session.name
          Percy.snapshot page, name: 'Sessions form on update'
          fill_in 'session_name', with: @session.name
          select @session.conference.name, from: 'conference_id'
          select @session.presentation_type.name, from: 'session_presentation_type_id'
          select @session.institution.name, from: 'institution_id'
          select @session.room.name, from: 'session_room_id'
          click_on 'Save session'
          assert_current_path admin_conferences_sessions_path
          assert_text 'Session saved'
          Percy.snapshot page, name: 'Sessions index on update'
        end

        test 'destroying a session' do
          skip 'Not currently sure how to click this button...'
          visit admin_conferences_sessions_path
          within "tr[data-session-id=\"#{@empty_session.id}\"]" do
            click_on 'Edit'
          end
          assert_text @empty_session.name
          accept_confirm "Are you sure you want to delete the session <strong>#{@empty_session.name}</strong>?" do
            click_on 'Permanently delete'
            Percy.snapshot page, name: 'Sessions delete dialog'
          end
          assert_current_path admin_conferences_sessions_path
          assert_text 'Session deleted'
          assert_no_selector "tr[data-session-id=\"#{@empty_session.id}\"]"
          Percy.snapshot page, name: 'Sessions index on delete'
        end
      end
    end
  end
end
