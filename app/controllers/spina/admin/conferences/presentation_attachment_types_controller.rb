# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {PresentationAttachmentType} objects.
      # @see PresentationAttachmentType
      class PresentationAttachmentTypesController < ApplicationController
        before_action :set_presentation_attachment_type, only: %i[edit update destroy]
        before_action :set_breadcrumb

        # @!group Actions

        # Renders a list of presentation attachment types.
        # @return [void]
        def index
          @presentation_attachment_types = PresentationAttachmentType.sorted.page(params[:page])
        end

        # Renders a form for a new presentation attachment type.
        # @return [void]
        def new
          @presentation_attachment_type = PresentationAttachmentType.new
          add_breadcrumb t('.new')
        end

        # Renders a form for an existing presentation attachment type.
        # @return [void]
        def edit
          add_breadcrumb @presentation_attachment_type.name
        end

        # Creates a presentation attachment type.
        # @return [void]
        def create
          @presentation_attachment_type = PresentationAttachmentType.new presentation_attachment_type_params

          if @presentation_attachment_type.save
            redirect_to admin_conferences_presentation_attachment_types_path, success: t('.saved')
          else
            add_breadcrumb t('.new')
            flash.now[:alert] = t('.failed')
            render :new, status: :unprocessable_entity
          end
        end

        # Updates a presentation attachment type.
        # @return [void]
        def update
          if @presentation_attachment_type.update(presentation_attachment_type_params)
            redirect_to admin_conferences_presentation_attachment_types_path, success: t('.saved')
          else
            add_breadcrumb @presentation_attachment_type.name
            flash.now[:alert] = t('.failed')
            render :edit, status: :unprocessable_entity
          end
        end

        # Destroys a presentation attachment type.
        # @return [void]
        def destroy
          if @presentation_attachment_type.destroy
            redirect_to admin_conferences_presentation_attachment_types_path, success: t('.destroyed')
          else
            add_breadcrumb @presentation_attachment_type.name
            flash.now[:alert] = t('.failed')
            render :edit, status: :unprocessable_entity
          end
        end

        # @!endgroup

        private

        # noinspection RubyInstanceMethodNamingConvention
        def set_presentation_attachment_type
          @presentation_attachment_type = PresentationAttachmentType.find params[:id]
        end

        def set_breadcrumb
          add_breadcrumb PresentationAttachmentType.model_name.human(count: 0),
                         admin_conferences_presentation_attachment_types_path
        end

        # noinspection RubyInstanceMethodNamingConvention
        def presentation_attachment_type_params
          params.require(:presentation_attachment_type).permit(:name)
        end
      end
    end
  end
end
