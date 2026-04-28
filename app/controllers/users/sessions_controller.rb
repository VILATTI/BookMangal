module Users
  class SessionsController < Devise::SessionsController
    protected

    def after_sign_in_path_for(_)  = root_path
    def after_sign_out_path_for(_) = root_path
  end
end
