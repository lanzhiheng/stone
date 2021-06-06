# frozen_string_literal: true

class MyFailureApp < Devise::FailureApp
  def route(_scope)
    :musk_sign_in_path
  end
end
