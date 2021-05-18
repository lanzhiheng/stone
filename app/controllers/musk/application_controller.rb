module Musk
  class ApplicationController < ActionController::Base
    before_action :authenticate_admin_user!

    def after_sign_out_path_for
      musk_sign_in_path
    end

    def redirect_back_to_root
      redirect_to admin_root_path if admin_user_signed_in?
    end
  end
end
