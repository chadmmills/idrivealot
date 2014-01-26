class MileageRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mileage_record, only: [:show, :edit, :update, :destroy]
  before_action :set_routes_select_data, only: [:create, :new, :edit, :index, :update]

  # GET /mileage-records
  def index
    @mileage_records = current_user.mileage_records.order("record_date DESC, end_mileage DESC")
    @mileage_record = current_user.mileage_records.new
    respond_to do |f|
      f.html { render "table_index" }
      f.csv { send_data @mileage_records.to_csv(current_user), type: 'text/csv; charset=utf-8; header=present' }
      f.xlsx { send_data @mileage_records.to_xlsx.to_stream.read, :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet" }
    end
  end

  # GET /mileage_records/1
  def show
  end

  # GET /mileage_records/new
  def new
    @mileage_record = current_user.mileage_records.new
    @mileage_record.start_mileage = MileageRecord.last_end_mileage_for(current_user)
  end

  # GET /mileage_records/1/edit
  def edit
  end

  # POST /mileage_records
  def create
    @mileage_record = current_user.mileage_records.new(updated_mileage_record_params)
      if @mileage_record.save
        redirect_to mileage_records_url, notice: 'Mileage record was successfully created.'
      else
        render action: 'new'
      end
  end

  # PATCH/PUT /mileage_records/1
  # PATCH/PUT /mileage_records/1.json
  def update
    if @mileage_record.update(updated_mileage_record_params)
      redirect_to mileage_records_url, notice: 'Mileage record was successfully updated.'
    else
    render action: 'edit'
    end
  end

  # DELETE /mileage_records/1
  # DELETE /mileage_records/1.json
  def destroy
    @mileage_record.destroy
    respond_to do |format|
      format.html { redirect_to mileage_records_url }
      format.json { head :no_content }
    end
  end

  def download
  end

  def download_month
    month_value = params.require(:date).permit(:month, :year)
    search_date = Date.strptime("#{month_value[:year]}-#{month_value[:month]}-1", '%Y-%m-%d')
    @download_data = current_user.mileage_records.where("record_date <= ? AND record_date > ?", search_date.end_of_month, search_date-1)
    send_data @download_data.to_xlsx.to_stream.read, filename: "#{search_date} Mileage.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'inline'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mileage_record
      @mileage_record = current_user.mileage_records.find(params[:id])
    end

    def set_routes_select_data
      @routes = MileageRecord.select("route_description").where(user_id: current_user).group("route_description").map { |r| [r.route_description] }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mileage_record_params
      params.require(:mileage_record).permit(:record_date, :start_mileage, :end_mileage, :route_description, :notes, :new_route_description)
    end

    def updated_mileage_record_params
      new_params = mileage_record_params
      new_params[:route_description] = params[:new_route_description] unless params[:new_route_description].blank?
      return new_params
    end
end
