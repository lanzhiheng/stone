class MessagesController < ApplicationController
  def create
    @message = Message.new(permitted_message)
    if @message.save
      render json: { message: 'success' }, status: 200
    else
      render json: { message: 'request failed' }, status: 400
    end
  end

  private

  def permitted_message
    params.permit(:name, :email, :content)
  end
end
