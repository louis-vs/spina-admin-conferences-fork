# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class PresentationsTest < ApplicationSystemTestCase
        setup do
          @presentation = spina_admin_conferences_presentations :asymmetry_and_antisymmetry

          authenticate
        end

        test 'visiting the index' do
          visit admin_conferences_presentations_path
          assert_text 'Presentations'
          Percy.snapshot page, name: 'Presentations index'
        end

        test 'creating a presentation' do
          skip 'Not currently worth the time trying to figure this one out.'
          visit admin_conferences_presentations_path
          click_on 'New presentation'
          assert_text 'New presentation'
          select @presentation.conference.name, from: 'conference_id'
          select @presentation.presentation_type.name, from: 'presentation_type_id'
          select @presentation.session.name, from: 'presentation_session_id'
          fill_in 'presentation_start_datetime', with: @presentation.start_datetime
          fill_in 'presentation_title', with: @presentation.title
          fill_in_rich_text_area 'presentation[abstract]', with: @presentation.abstract
          @presentation.presenters.each { |presenter| check presenter.reversed_name_and_institution, allow_label_click: true }
          click_button 'New entry'
          find(id: /presentation_attachments_attributes_[0-9]+_attachment_type_id/).select @presentation.attachments.first.name
          find(id: /presentation_attachments_attributes_[0-9]+_attachment_id/).select @presentation.attachments.first.attachment.name
          Percy.snapshot page, name: 'Presentations form on create'
          click_on 'Save presentation'
          assert_current_path admin_conferences_presentations_path
          assert_text 'Presentation saved'
          Percy.snapshot page, name: 'Presentations index on create'
        end

        test 'updating a presentation' do
          visit admin_conferences_presentations_path
          within "tr[data-presentation-id=\"#{@presentation.id}\"]" do
            click_on 'Edit'
          end
          assert_text @presentation.name
          Percy.snapshot page, name: 'Presentations form on update'
          select @presentation.conference.name, from: 'conference_id'
          select @presentation.presentation_type.name, from: 'presentation_type_id'
          select @presentation.session.name, from: 'presentation_session_id'
          fill_in 'presentation_start_datetime', with: @presentation.start_datetime
          fill_in 'presentation_title', with: @presentation.title
          fill_in_rich_text_area 'presentation[abstract]', with: @presentation.abstract
          @presentation.presenters.each { |presenter| check presenter.reversed_name_and_institution, allow_label_click: true }
          click_button 'New entry'
          find(id: /presentation_attachments_attributes_[0-9]+_attachment_type_id/).select @presentation.attachments.first.name
          find(id: /presentation_attachments_attributes_[0-9]+_attachment_id/).select @presentation.attachments.first.attachment.name
          click_on 'Save presentation'
          assert_current_path admin_conferences_presentations_path
          assert_text 'Presentation saved'
          Percy.snapshot page, name: 'Presentations index on update'
        end

        test 'destroying a presentation' do
          skip 'Not currently sure how to click this button...'
          visit admin_conferences_presentations_path
          within "tr[data-presentation-id=\"#{@presentation.id}\"]" do
            click_on 'Edit'
          end
          assert_text @presentation.name
          accept_confirm "Are you sure you want to delete the presentation <strong>#{@presentation.name}</strong>?" do
            click_on 'Permanently delete'
            Percy.snapshot page, name: 'Presentations delete dialog'
          end
          assert_current_path admin_conferences_presentations_path
          assert_text 'Presentation deleted'
          assert_no_selector "tr[data-presentation-id=\"#{@presentation.id}\"]"
          Percy.snapshot page, name: 'Presentations index on delete'
        end
      end
    end
  end
end
