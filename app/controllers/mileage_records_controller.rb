class MileageRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mileage_record, only: [:show, :edit, :update, :destroy]

  # GET /mileage_records
  def index
    @mileage_records = current_user.mileage_records.order("record_date DESC")
    respond_to do |f|
      f.html
      f.csv { send_data @mileage_records.to_csv(current_user), type: 'text/csv; charset=utf-8; header=present' }
    end
  end

  # GET /mileage_records/1
  def show
  end

  # GET /mileage_records/new
  def new
    @mileage_record = current_user.mileage_records.new
    @mileage_record.start_mileage = MileageRecord.last_end_mileage_for(current_user)
    @routes = MileageRecord.select("route_description").group("route_description").map { |r| [r.route_description] }
  end

  # GET /mileage_records/1/edit
  def edit
  end

  # POST /mileage_records
  def create
    @mileage_record = current_user.mileage_records.new(mileage_record_params)
      if @mileage_record.save
        redirect_to mileage_records_url, notice: 'Mileage record was successfully created.'
      else
        render action: 'new'
      end
  end

  # PATCH/PUT /mileage_records/1
  # PATCH/PUT /mileage_records/1.json
  def update
    respond_to do |format|
      if @mileage_record.update(mileage_record_params)
        format.html { redirect_to @mileage_record, notice: 'Mileage record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mileage_record.errors, status: :unprocessable_entity }
      end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mileage_record
      @mileage_record = current_user.mileage_records.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mileage_record_params
      params.require(:mileage_record).permit(:record_date, :start_mileage, :end_mileage, :route_description, :distance, :notes, :user_id)
    end
end
