# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {PresentationType} objects.
      # @see PresentationType
      class PresentationTypesController < ApplicationController
        before_action :set_presentation_type, only: %i[edit update destroy]
        before_action :set_breadcrumbs
        before_action :set_tabs

        # @!group Actions

        # Renders a list of presentation types.
        # @return [void]
        def index
          @presentation_types = PresentationType.sorted.page(params[:page])
        end

        # Renders a form for a new presentation type.
        # @return [void]
        def new
          @presentation_type = PresentationType.new
          add_breadcrumb t('.new')
        end

        # Renders a form for an existing presentation type.
        # @return [void]
        def edit
          add_breadcrumb @presentation_type.name
        end

        # Creates a presentation type.
        # @return [void]
        def create
          @presentation_type = PresentationType.new presentation_type_params

          if @presentation_type.save
            redirect_to admin_conferences_presentation_types_path, success: t('.saved')
          else
            add_breadcrumb t('.new')
            flash.now[:alert] = t('.failed')
            render :new, status: :unprocessable_entity
          end
        end

        # Updates a presentation type.
        # @return [void]
        def update
          if @presentation_type.update(presentation_type_params)
            redirect_to admin_conferences_presentation_types_path, success: t('.saved')
          else
            add_breadcrumb @presentation_type.name
            flash.now[:alert] = t('.failed')
            render :edit, status: :unprocessable_entity
          end
        end

        # Destroys a presentation type.
        # @return [void]
        def destroy # rubocop:disable Metrics/MethodLength
          if @presentation_type.destroy
            redirect_to admin_conferences_presentation_types_path, success: t('.destroyed')
          else
            add_breadcrumb @presentation_type.name
            flash.now[:alert] = t('.failed')
            render :edit, status: :unprocessable_entity
          end
        end

        # @!endgroup

        private

        def set_presentation_type
          @presentation_type = PresentationType.find params[:id]
        end

        def set_breadcrumbs
          add_breadcrumb Conference.model_name.human(count: 0), admin_conferences_conferences_path
          add_breadcrumb PresentationType.model_name.human(count: 0), admin_conferences_presentation_types_path
        end

        def set_tabs
          @tabs = %w[presentation_type_details presentations sessions]
        end

        def presentation_type_params
          params.require(:presentation_type).permit(:name, :conference_id, :minutes)
        end
      end
    end
  end
end
