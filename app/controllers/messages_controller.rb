# frozen_string_literal: true

class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(permitted_message)
    if @message.save
      render :success, status: :created
    else
      render :new
    end
  end

  private

  def permitted_message
    params.require(:message).permit(:name, :email, :content)
  end
end
