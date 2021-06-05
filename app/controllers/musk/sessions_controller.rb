module Musk
  class SessionsController < ApplicationController
    skip_before_action :authenticate_admin_user!, only: [:new, :create]
    before_action :redirect_back_to_root, only: [:new]

    def new
      render :new, layout: 'musk/application_slim'
    end

    def destroy
      sign_out
      redirect_to musk_sign_in_path
    end

    def create
      @admin_user = AdminUser.find_by(email: params[:email])

      if @admin_user && @admin_user.valid_password?(params[:password])
        flash[:success] = '登录成功'
        sign_in(@admin_user)
        redirect_to musk_root_path
      else
        flash[:error] = '登录失败'
        render :new, layout: 'musk/application_slim', status: :unprocessable_entity
      end
    end
  end
end
