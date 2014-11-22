class HomeController < ApplicationController
  
  layout 'home'

  def home
    redirect_to mileage_records_path if user_signed_in?
  end

end
