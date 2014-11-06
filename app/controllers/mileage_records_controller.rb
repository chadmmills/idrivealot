class MileageRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mileage_record, only: [:show, :edit, :update, :destroy]
  before_action :set_form_select_data, only: [:create, :new, :edit, :index, :update]
	before_action :set_route_description, only: [:create, :update]

  # GET /mileage-records
  def index
    @mileage_record = current_user.mileage_records.last || current_user.mileage_records.new
    respond_to do |f|
      f.html { render "table_index" }
      f.xlsx { send_data @mileage_records.to_xlsx.to_stream.read, :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet" }
    end
  end

	def list_view
    @mileage_records = current_user.mileage_records.order("record_date DESC, end_mileage DESC")
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
				send_to_root_or_next
      else
        render action: 'new'
      end
  end

  def update
    if @mileage_record.update(mileage_record_params)
      redirect_to mileage_records_url, notice: 'Mileage record was successfully updated.'
    else
			render action: 'edit'
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
    @download_data = current_user.mileage_records.order(:record_date)
                      .where("record_date <= ? AND record_date > ?", search_date.end_of_month, search_date-1)

    if email_flag
      DataMailer.monthly_data(current_user.id, search_date_month, @download_data).deliver
      flash[:notice] = "Email Sent!"
      redirect_to download_data_path and return
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def mileage_record_params
      params.require(:mileage_record).permit(:record_date, :start_mileage, :end_mileage, :route_description, :notes, :new_route_description)
    end

    def set_route_description
      params[:mileage_record][:route_description] = params[:new_route_description] unless params[:new_route_description].blank?
    end

		def send_to_root_or_next
			if params[:redirect_path] == "Next"
				redirect_to new_mileage_record_path, notice: 'Mileage record was successfully created.'
			else
        redirect_to mileage_records_path, notice: 'Mileage record was successfully created.'
			end
		end
end
