class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
  end

  def create
    user = User.new(user_params)

    if user.save
      redirect_to user_dashboard_path(user)
      flash[:success] = "Welcome #{user.name}"
    else
      redirect_to register_path
      flash[:alert] = user.errors.full_messages.to_sentence
    end
  end

  def login_user
    @user = User.find_by(email: params[:email])
      if @user&.authenticate(params[:password])
        flash[:success] = "Welcome #{@user.name}"
        redirect_to user_dashboard_path(@user)
      else
        redirect_to root_path
        flash[:error] = 'Invalid Credentials'
      end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
