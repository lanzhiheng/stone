class TagsController < ApplicationController
  def index
    raise ActionController::RoutingError.new('Page Not Found') unless admin_user_signed_in?
    tags = ActsAsTaggableOn::Tag.most_used(10).select(:id, :name)

    render json: {
             data: tags
           }.to_json
  end
end
