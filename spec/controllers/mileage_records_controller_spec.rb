require 'spec_helper'

describe MileageRecordsController do
  # # This should return the minimal set of attributes required to create a valid
  # # MileageRecord. As you add validations to MileageRecord, be sure to
  # # adjust the attributes here as well.
  # let(:valid_attributes) { { "record_date" => "2013-11-03" } }

  # # This should return the minimal set of values that should be in the session
  # # in order to pass any filters (e.g. authentication) defined in
  # # MileageRecordsController. Be sure to keep this updated too.
  # let(:valid_session) { {} }

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
    # it "should only show selects for current_user" do
    #   create(:mileage_record, route_description: "Do not include this text")
    #   get :new
    #   expect(find_field('mileage_record[route_description]')).to_not have_content "Do not include this text"
    # end
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
				puts response.body.inspect
				expect(response.headers['Content-Type']).to have_content 'openxml'
			end
		end

    xit "returns csv content" do
			create(:mileage_record, user: subject.current_user)
			create(:mileage_record, end_mileage: 1024, route_description: "95 to 89 Chattanooga Route", user: subject.current_user)
			get :index, format: :csv
			expect(response.body).to have_content "95 to 89 Chattanooga Route"
    end

    xit "only includes current_user content" do
      create(:mileage_record, route_description: "Do not include")
      get :index, format: :csv
      expect(response.body).to_not have_content "Do not include"
    end
  end

  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved mileage_record as @mileage_record" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       MileageRecord.any_instance.stub(:save).and_return(false)
  #       post :create, {:mileage_record => { "record_date" => "invalid value" }}, valid_session
  #       assigns(:mileage_record).should be_a_new(MileageRecord)
  #     end

  #     it "re-renders the 'new' template" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       MileageRecord.any_instance.stub(:save).and_return(false)
  #       post :create, {:mileage_record => { "record_date" => "invalid value" }}, valid_session
  #       response.should render_template("new")
  #     end
  #   end
  # end

  # describe "PUT update" do
  #   describe "with valid params" do
  #     it "updates the requested mileage_record" do
  #       mileage_record = MileageRecord.create! valid_attributes
  #       # Assuming there are no other mileage_records in the database, this
  #       # specifies that the MileageRecord created on the previous line
  #       # receives the :update_attributes message with whatever params are
  #       # submitted in the request.
  #       MileageRecord.any_instance.should_receive(:update).with({ "record_date" => "2013-11-03" })
  #       put :update, {:id => mileage_record.to_param, :mileage_record => { "record_date" => "2013-11-03" }}, valid_session
  #     end

  #     it "assigns the requested mileage_record as @mileage_record" do
  #       mileage_record = MileageRecord.create! valid_attributes
  #       put :update, {:id => mileage_record.to_param, :mileage_record => valid_attributes}, valid_session
  #       assigns(:mileage_record).should eq(mileage_record)
  #     end

  #     it "redirects to the mileage_record" do
  #       mileage_record = MileageRecord.create! valid_attributes
  #       put :update, {:id => mileage_record.to_param, :mileage_record => valid_attributes}, valid_session
  #       response.should redirect_to(mileage_record)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns the mileage_record as @mileage_record" do
  #       mileage_record = MileageRecord.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       MileageRecord.any_instance.stub(:save).and_return(false)
  #       put :update, {:id => mileage_record.to_param, :mileage_record => { "record_date" => "invalid value" }}, valid_session
  #       assigns(:mileage_record).should eq(mileage_record)
  #     end

  #     it "re-renders the 'edit' template" do
  #       mileage_record = MileageRecord.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       MileageRecord.any_instance.stub(:save).and_return(false)
  #       put :update, {:id => mileage_record.to_param, :mileage_record => { "record_date" => "invalid value" }}, valid_session
  #       response.should render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE destroy" do
  #   it "destroys the requested mileage_record" do
  #     mileage_record = MileageRecord.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => mileage_record.to_param}, valid_session
  #     }.to change(MileageRecord, :count).by(-1)
  #   end

  #   it "redirects to the mileage_records list" do
  #     mileage_record = MileageRecord.create! valid_attributes
  #     delete :destroy, {:id => mileage_record.to_param}, valid_session
  #     response.should redirect_to(mileage_records_url)
  #   end
  # end

end
