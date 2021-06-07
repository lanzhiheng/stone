# frozen_string_literal: true

require 'application_responder'

module Musk
  class ApplicationController < InheritedResources::Base
    self.responder = ApplicationResponder
    respond_to :html

    before_action :authenticate_admin_user!

    def after_sign_out_path_for
      musk_sign_in_path
    end

    def redirect_back_to_root
      redirect_to admin_root_path if admin_user_signed_in?
    end

    def create
      create! do |_success, failure|
        failure.html { respond_with(*with_chain(resource), status: :unprocessable_entity) }
      end
    end

    def collection
      get_collection_ivar || set_collection_ivar(end_of_association_chain
                                                   .order(created_at: :DESC).paginate(page: params[:page]))
    end

    def update
      update! do |_success, failure|
        failure.html { respond_with(*with_chain(resource), status: :unprocessable_entity) }
      end
    end

    rescue_from ActiveRecord::DeleteRestrictionError do |e|
      flash[:alert] = e.message
      redirect_back(fallback_location: collection_path)
    end
  end
end
