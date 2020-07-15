class PagesController < ApplicationController
  def robots
    render formats: :text
  end
end
