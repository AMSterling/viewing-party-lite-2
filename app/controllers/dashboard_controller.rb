class DashboardController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :require_user
  def show
  end

  private

  def require_user
    @user = User.find(params[:user_id])
  end
end
