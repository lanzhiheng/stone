# frozen_string_literal: true

class ResumesController < ApplicationController
  def index; end

  def personal
    render layout: false
  end
end
