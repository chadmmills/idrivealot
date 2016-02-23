class MileageRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_active_user!
  before_action :set_mileage_record, only: [:show, :edit, :update, :destroy]
  before_action :set_form_select_data, only: [:create, :new, :edit, :index, :update]
  before_action :set_route_description, only: [:create, :update]

  def index
    @mileage_record = current_user.mileage_records.last || current_user.mileage_records.new
    respond_to do |f|
      f.html { render "table_index" }
      f.xlsx do
        send_data(
          @mileage_records.to_xlsx.to_stream.read,
          type: "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
        )
      end
    end
  end

  def list_view
    @mileage_records = current_user.mileage_records.by_date_and_end_mileage
  end

  def show
  end

  def new
    @mileage_record = current_user.mileage_records.new
    @mileage_record.start_mileage = MileageRecord.last_end_mileage_for(current_user)
  end

  def edit
  end

  def create
    @mileage_record = current_user.mileage_records.new(mileage_record_params)
    if @mileage_record.save
      redirect_to mileage_records_or_next_path, notice: 'Mileage record was successfully created.'
    else
      render :new
    end
  end

  def update
    if @mileage_record.update(mileage_record_params)
      redirect_to mileage_records_url, notice: 'Mileage record was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @mileage_record.destroy
    respond_to do |format|
      format.html { redirect_to mileage_records_url }
      format.json { head :no_content }
    end
  end

  def download
    @records = current_user.mileage_records.order(:record_date)
    respond_to do |f|
      f.html { render 'download' }
      f.xlsx { render xlsx: "data_dump", disposition: "inline", filename: "My idrivealot data" }
    end
  end

  def download_month
    @download_data = current_user.mileage_records_for_download(search_date: search_date)

    if email_flag
      DataMailer.monthly_data(current_user.id, search_date_month, @download_data).deliver_now
      redirect_to download_data_path, notice: "Email Sent!" and return
    else
      render xlsx: "aldi_log", disposition: 'inline', filename: "#{search_date_month}_log"
    end
  end

  def stats
    @mileage_entries = current_user.mileage_records
  end

  private

    def search_date_month
      search_date.strftime('%B')
    end

    def email_flag
      params[:email_flag]
    end

    def month_value
      params.require(:date).permit(:month, :year)
    end

    def search_date
      Date.strptime("#{month_value[:year]}-#{month_value[:month]}-1", '%Y-%m-%d')
    end

    def set_mileage_record
      @mileage_record = current_user.mileage_records.find(params[:id])
    end

    def set_form_select_data
      @routes = MileageRecord.where(user: current_user).uniq.pluck(:route_description)
			@dates = (1.month.ago.to_date..30.days.from_now).map{ |date| [date.strftime("%A, %b-%d"), date] }
    end

    def mileage_record_params
      params.
        require(:mileage_record).
        permit(
          :record_date,
          :start_mileage,
          :end_mileage,
          :route_description,
          :notes,
          :new_route_description
        )
    end

    def set_route_description
      if params[:new_route_description].present?
        params[:mileage_record][:route_description] = params[:new_route_description]
      end
    end

		def mileage_records_or_next_path
			if params[:redirect_path] == "Save & Add New"
				new_mileage_record_path
			else
        mileage_records_path
			end
		end

    def ensure_active_user!
      unless current_user.active?
        redirect_to(
          update_payment_form_path,
          alert: "Your account is locked due to invalid payment"
        ) and return
      end
    end
end
