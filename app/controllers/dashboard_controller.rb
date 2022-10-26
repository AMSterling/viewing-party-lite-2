class DashboardController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :require_user, only: %i[show]

  def show
  end
end
