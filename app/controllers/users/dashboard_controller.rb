class Users::DashboardController < ApplicationController
  before_action :require_user

  def index
  end

  private
    def require_user
      flash[:error] = 'You must be logged in or registered to access your dashboard'
      render file: "public/404.html" unless current_user
    end
end