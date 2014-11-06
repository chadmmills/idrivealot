require 'spec_helper'

describe MileageRecordsController do

  describe "GET index" do
    login_user
    it "returns success on get index" do
      get :index
      expect(response).to be_success
    end
  end

  describe "GET new" do
    login_user
    it "assigns a new mileage_record as @mileage_record" do
      get :new
      expect(assigns(:mileage_record)).to be_a_new(MileageRecord)
    end
  end

  describe "GET edit" do
    login_user
    it "assigns the requested mileage_record as @mileage_record" do
      mileage_record = create(:mileage_record, user: subject.current_user)
      get :edit, id: mileage_record
      expect(assigns(:mileage_record)).to eq mileage_record
    end
  end

  describe "POST create" do
    context "with valid params" do
      login_user
      it "creates a new MileageRecord" do
        expect{post :create, mileage_record: attributes_for(:mileage_record)}.to change(MileageRecord, :count).by(1)
      end
      it "redirects to the created mileage_record" do
        post :create, mileage_record: attributes_for(:mileage_record)
        expect(response).to redirect_to(mileage_records_path)
      end
    end
    context "with invalid params" do
      login_user
      it "does not save the new record in the database" do
        expect{post :create, mileage_record: attributes_for(:invalid_mileage_record)}.to_not change(MileageRecord, :count)
      end
      it "does not save the new record with nil end mileage" do
        expect{post :create, mileage_record: attributes_for(:nil_end_mileage)}.to change(MileageRecord, :count)
      end
      it "re-renders the new template" do
        post :create, mileage_record: attributes_for(:invalid_mileage_record)
        expect(response).to render_template :new
      end
    end
  end

  describe "XLSX output" do
		render_views
		context "for #month_download" do
			it "returns a xslx file" do
				user = create(:user)
				mr = create(:mileage_record, user: user)
				sign_in user
				post :download_month, "date" => { "month" => Date.today.month, "year" => Date.today.year }
				expect(response.headers['Content-Type']).to have_content 'openxml'
			end

      it "sends an email with xlsx attachment" do
				user = create(:user, email: "attachment@aldi.com")
				mr = create(:mileage_record, user: user)
				sign_in user
				post :download_month, {"date" => { "month" => Date.today.month, "year" => Date.today.year }, "email_flag" => "1"}
        expect(ActionMailer::Base.deliveries.last.to).to include user.email
        expect(response).to redirect_to download_data_path
      end
		end
  end
end
