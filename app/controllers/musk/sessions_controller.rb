module Musk
  class SessionsController < ApplicationController
    skip_before_action :authenticate_admin_user!, only: [:new, :create]
    before_action :redirect_back_to_root, only: [:new]

    def new; end

    def create
      @admin_user = AdminUser.find_by(email: params[:email])

      if @admin_user && @admin_user.valid_password?(params[:password])
        flash[:success] = '登录成功'
        sign_in(@admin_user)
        redirect_to admin_root_path
      else
        flash[:error] = '登录失败'
        redirect_back(fallback_location: musk_sign_in_path)
      end
    end
  end
end
