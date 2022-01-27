# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class PresentationAttachmentTypesTest < ApplicationSystemTestCase
        setup do
          @presentation_attachment_type = spina_admin_conferences_presentation_attachment_types :handout

          authenticate
        end

        test 'visiting the index' do
          visit admin_conferences_presentation_attachment_types_path
          assert_text 'Presentation attachment types'
          Percy.snapshot page, name: 'Presentation attachment types index'
        end

        test 'creating a presentation attachment type' do
          visit admin_conferences_presentation_attachment_types_path
          click_on 'New presentation attachment type'
          assert_text 'New presentation attachment type'
          fill_in 'presentation_attachment_type_name', with: @presentation_attachment_type.name
          Percy.snapshot page, name: 'Presentation attachment types form on create'
          click_on 'Save presentation attachment type'
          assert_current_path admin_conferences_presentation_attachment_types_path
          assert_text 'Presentation attachment type saved'
          Percy.snapshot page, name: 'Presentation attachment types index on create'
        end

        test 'updating a presentation attachment type' do
          visit admin_conferences_presentation_attachment_types_path
          within "tr[data-presentation-attachment-type-id=\"#{@presentation_attachment_type.id}\"]" do
            click_on 'Edit'
          end
          assert_text @presentation_attachment_type.name
          Percy.snapshot page, name: 'Presentation attachment types form on update'
          fill_in 'presentation_attachment_type_name', with: @presentation_attachment_type.name
          click_on 'Save presentation attachment type'
          assert_current_path admin_conferences_presentation_attachment_types_path
          assert_text 'Presentation attachment type saved'
          Percy.snapshot page, name: 'Presentation attachment types index on update'
        end

        test 'destroying a presentation attachment type' do
          skip 'Not currently sure how to click this button...'
          visit admin_conferences_presentation_attachment_types_path
          within "tr[data-presentation-attachment-type-id=\"#{@presentation_attachment_type.id}\"]" do
            click_on 'Edit'
          end
          assert_text @presentation_attachment_type.name
          accept_confirm "Are you sure you want to delete the presentation attachment type <strong>#{@presentation_attachment_type.name}" \
                         '</strong>?' do
            click_on 'Permanently delete'
            Percy.snapshot page, name: 'Presentation attachment types delete dialog'
          end
          assert_current_path admin_conferences_presentation_attachment_types_path
          assert_text 'Presentation attachment type deleted'
          assert_no_selector "tr[data-dietary-requirement-id=\"#{@presentation_attachment_type.id}\"]"
          Percy.snapshot page, name: 'Presentation attachment types index on delete'
        end
      end
    end
  end
end
