class ProfilesController < ApplicationController
  def edit; end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?

    if current_user.update_with_password(profile_params)
      bypass_sign_in(current_user)
      redirect_to edit_profile_path, notice: "Профіль оновлено ✅"
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def profile_params
    params.expect(user: %i[name email password password_confirmation current_password])
  end
end
