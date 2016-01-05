require 'rails_helper'

describe Api::V1::PrecinctsController do
  let(:valid_attributes) { Fabricate.attributes_for(:precinct) }
  let(:invalid_attributes) { Fabricate.attributes_for(:invalid_precinct) }

  let!(:user) { Fabricate(:confirmed_user) }

  before(:each) do
    http_login(user)
  end

  describe "GET #index" do
    it "assigns all precincts as @precincts" do
      precinct = Precinct.create! valid_attributes
      get :index, {}
      expect(assigns(:precincts)).to eq([precinct])
    end
  end

  describe "GET #show" do
    it "assigns the requested precinct as @precinct" do
      precinct = Precinct.create! valid_attributes
      get :show, {:id => precinct.to_param}
      expect(assigns(:precinct)).to eq(precinct)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Precinct" do
        expect {
          post :create, {:precinct => valid_attributes}
        }.to change(Precinct, :count).by(1)
      end

      it "assigns a newly created precinct as @precinct" do
        post :create, {:precinct => valid_attributes}
        expect(assigns(:precinct)).to be_a(Precinct)
        expect(assigns(:precinct)).to be_persisted
      end

      it "response with newly created precinct with correct attributes" do
        post :create, {:precinct => valid_attributes}
        body = JSON.parse(response.body)
        for key,val in valid_attributes
          expect(body[key.to_s]).to eq(valid_attributes[key])
        end
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved precinct as @precinct" do
        post :create, {:precinct => invalid_attributes}
        expect(assigns(:precinct)).to be_a_new(Precinct)
      end

      it "returns an error message for name" do
        post :create, {:precinct => invalid_attributes}
        body = JSON.parse(response.body)
        expect(body['name']).to be_present
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { name: "Gotham" } }

      it "updates the requested precinct" do
        precinct = Precinct.create! valid_attributes
        put :update, {:id => precinct.to_param, :precinct => new_attributes}
        precinct.reload
        expect(assigns(:precinct).name).to eq(new_attributes[:name])
      end

      it "assigns the requested precinct as @precinct" do
        precinct = Precinct.create! valid_attributes
        put :update, {:id => precinct.to_param, :precinct => valid_attributes}
        expect(assigns(:precinct)).to eq(precinct)
      end

      it "renders the precinct with id and name" do
        precinct = Precinct.create! valid_attributes
        put :update, {:id => precinct.to_param, :precinct => valid_attributes}
        body = JSON.parse(response.body)
        expect(body['id']).to eq(precinct.id)
        expect(body['name']).to eq(precinct.name)
      end
    end

    context "with invalid params" do
      it "assigns the precinct as @precinct" do
        precinct = Precinct.create! valid_attributes
        put :update, {:id => precinct.to_param, :precinct => invalid_attributes}
        expect(assigns(:precinct)).to eq(precinct)
      end

      it "returns an error message for name" do
        post :create, {:precinct => invalid_attributes}
        body = JSON.parse(response.body)
        expect(body['name']).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested precinct" do
      precinct = Precinct.create! valid_attributes
      expect {
        delete :destroy, {:id => precinct.to_param}
      }.to change(Precinct, :count).by(-1)
    end
  end

end
