class MyFailureApp < Devise::FailureApp
  def route(scope)
    :musk_sign_in_path
  end
end
