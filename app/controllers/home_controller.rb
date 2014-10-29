class HomeController < ApplicationController
  
  def home
    redirect_to mileage_records_path if user_signed_in?
  end

end
