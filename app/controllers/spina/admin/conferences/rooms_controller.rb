# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {Room} objects.
      # @see Room
      class RoomsController < ApplicationController
        before_action :set_room, only: %i[edit update destroy]
        before_action :set_breadcrumbs
        before_action :set_tabs

        # @!group Actions

        # Renders a list of rooms.
        # @return [void]
        def index
          @rooms = Room.sorted.page(params[:page])
        end

        # Renders a form for a new room.
        # @return [void]
        def new
          @room = Room.new
          add_breadcrumb t('.new')
        end

        # Renders a form for an existing room.
        # @return [void]
        def edit
          add_breadcrumb @room.name
        end

        # Creates a room.
        # @return [void]
        def create
          @room = Room.new(room_params)

          if @room.save
            redirect_to admin_conferences_rooms_path, success: t('.saved')
          else
            add_breadcrumb t('.new')
            flash.now[:alert] = t('.failed')
            render :new, status: :unprocessable_entity
          end
        end

        # Updates a room.
        # @return [void]
        def update
          if @room.update(room_params)
            redirect_to admin_conferences_rooms_path, success: t('.saved')
          else
            add_breadcrumb @room.name
            flash.now[:alert] = t('.failed')
            render :edit, status: :unprocessable_entity
          end
        end

        # Destroys a room.
        # @return [void]
        def destroy
          if @room.destroy
            redirect_to admin_conferences_rooms_path, success: t('.destroyed')
          else
            add_breadcrumb @room.name
            flash.now[:alert] = t('.failed')
            render :edit, status: :unprocessable_entity
          end
        end

        # @!endgroup

        private

        def set_room
          @room = Room.find params[:id]
        end

        def set_breadcrumbs
          add_breadcrumb Institution.model_name.human(count: 0), admin_conferences_institutions_path
          add_breadcrumb Room.model_name.human(count: 0), admin_conferences_rooms_path
        end

        def set_tabs
          @tabs = %w[room_details presentations]
        end

        def room_params
          params.require(:room).permit(:building, :number, :institution_id)
        end
      end
    end
  end
end
