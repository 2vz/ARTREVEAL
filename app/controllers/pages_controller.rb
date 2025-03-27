class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing, :error]

  def landing
    redirect_to scan_path if user_signed_in?
  end

  def scan
    # page protégée automatiquement
  end

  def error
  end
end
