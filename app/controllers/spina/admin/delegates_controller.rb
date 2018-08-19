module Spina
  module Admin
    # This class manages delegates and sets breadcrumbs
    class DelegatesController < AdminController
      before_action :set_breadcrumbs

      def index
        @delegates = Delegate.sorted
      end

      def new
        @delegate = Delegate.new
        add_breadcrumb I18n.t('spina.delegates.new')
        render layout: 'spina/admin/admin'
      end

      def edit
        @delegate = Delegate.find(params[:id])
        add_breadcrumb "#{@delegate.first_name} #{@delegate.last_name}"
        render layout: 'spina/admin/admin'
      end

      def create
        @delegate = Delegate.new(delegate_params)
        add_breadcrumb I18n.t('spina.delegates.new')
        if @delegate.save
          redirect_to admin_delegates_path
        else
          render :new, layout: 'spina/admin/admin'
        end
      end

      def update
        @delegate = Delegate.find(params[:id])
        add_breadcrumb "#{@delegate.first_name} #{@delegate.last_name}"
        if @delegate.update(delegate_params)
          redirect_to admin_delegates_path
        else
          render :edit, layout: 'spina/admin/admin'
        end
      end

      def destroy
        @delegate = Delegate.find(params[:id])
        @delegate.destroy
        if Delegate.any? || DietaryRequirement.any? || Conference.any?
          redirect_to admin_delegates_path
        else
          redirect_to admin_conferences_path
        end
      end

      private

      def set_breadcrumbs
        add_breadcrumb I18n.t('spina.website.delegates'), admin_delegates_path
      end

      def delegate_params
        params.require(:delegate).permit(:first_name, :last_name,
                                         :email_address, :url, :institution,
                                         conference_ids: [],
                                         presentation_ids: [],
                                         dietary_requirement_ids: [])
      end
    end
  end
end
