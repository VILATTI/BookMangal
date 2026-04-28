class Users::RegistrationsController < Devise::RegistrationsController
  protected
  def after_sign_up_path_for(_) = root_path
  def after_update_path_for(_)  = edit_profile_path
end
