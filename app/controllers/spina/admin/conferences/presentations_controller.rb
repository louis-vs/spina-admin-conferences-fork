# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {Presentation} objects.
      # @see Presentation
      class PresentationsController < ApplicationController
        before_action :set_presentation, only: %i[edit update destroy]
        before_action :set_breadcrumb
        before_action :set_tabs
        before_action :set_conferences, only: %i[new edit]

        # @!group Actions

        # Renders a list of presentations.
        # @return [void]
        def index
          @presentations = Presentation.sorted.page(params[:page])
        end

        # Renders a form for a new presentation.
        # @return [void]
        def new
          @presentation = Presentation.new
          add_breadcrumb t('.new')
        end

        # Renders a form for an existing presentation.
        # @return [void]
        def edit
          add_breadcrumb @presentation.title
        end

        # Creates a presentation.
        # @return [void]
        def create
          @presentation = Presentation.new presentation_params

          if @presentation.save
            redirect_to admin_conferences_presentations_path, success: t('.saved')
          else
            add_breadcrumb t('.new')
            flash.now[:alert] = t('.failed')
            render :new, status: :unprocessable_entity
          end
        end

        # Updates a presentation.
        # @return [void]
        def update
          if @presentation.update(presentation_params)
            redirect_to admin_conferences_presentations_path, success: t('.saved')
          else
            add_breadcrumb @presentation.name
            flash.now[:alert] = t('.failed')
            render :edit, status: :unprocessable_entity
          end
        end

        # Destroys a presentation.
        # @return [void]
        def destroy
          if @presentation.destroy
            redirect_to admin_conferences_presentations_path, success: t('.destroyed')
          else
            add_breadcrumb @presentation.name
            flash.now[:alert] = t('.failed')
            render :edit, status: :unprocessable_entity
          end
        end

        # Imports a presentation.
        # @return [void]
        # @see Presentation#import
        def import
          Presentation.import params[:file]
        end

        # @!endgroup

        private

        def set_presentation
          @presentation = Presentation.find params[:id]
        end

        def set_conferences
          @conferences = Conference.all.to_json methods: %i[name],
                                                include:
                                                  { presentation_types:
                                                      { methods: [:name], include: { sessions: { methods: [:name] } } } }
        end

        def set_breadcrumb
          add_breadcrumb Presentation.model_name.human(count: 0), admin_conferences_presentations_path
        end

        def set_tabs
          @tabs = %w[presentation_details presenters]
        end

        def presentation_params
          params.require(:presentation).permit(:title, :abstract, :session_id, :start_datetime,
                                               presenter_ids: [],
                                               attachments_attributes: %i[id attachment_id attachment_type_id _destroy])
        end
      end
    end
  end
end
