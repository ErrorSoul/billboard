require 'rails_helper'

describe Api::V1::EmployeesController do
  let!(:employees) { create_list(:employee, 10, :searched) }
  let!(:skills) { create_list(:skill, 2) }
  let!(:skill) { create :skill }
  let!(:employee) { build :employee }

  describe 'GET #index' do
    context 'with valid attributes' do
      it 'return employees[0, 5]' do
        get :index, page: 0, format: :json
        expected_json = {
          employees: employees.sort_by(&:salary)[0, 5],
          page_num:  Employee.page_num,
          page: 0
        }.to_json
        expect(response.body).to eq expected_json
      end
    end

    context 'with valid attributes' do
      it 'return employees[5, 10]' do
        get :index, page: 1, format: :json
        expected_json = {
          employees: employees.sort_by(&:salary)[5, 10],
          page_num:  Employee.page_num,
          page: 1
        }.to_json
        expect(response.body).to eq expected_json
      end
    end
  end

  describe "GET #show" do
    it "should return employee " do
      get :show, id: employees.first.id, format: :json
      expected_json = {
        employee: employees.first.as_json(include: :skills)
      }.to_json
      expect(response.body).to eq expected_json
    end
  end

  describe 'POST #create' do
    let(:skills_attr) { [{"id"=>2, "name"=>"rails"}, {"id"=>3, "name"=>"ruby"}] }

    context 'with valid attributes' do
      it 'creates the employee with skills' do
         expect do
          post :create, employee: attributes_for(:employee, skills: skills_attr), format: :json
        end.to change(Employee, :count).by(1)
      end

      it 'when employee create should be OK message' do
        post :create, employee: attributes_for(:employee, skills: skills_attr), format: :json
        expected_json = { message: 'OK' }.to_json
        expect(response.body).to eq expected_json
      end


      it 'when employee create should be correct skills' do
        post :create, employee: attributes_for(:employee, skills: skills_attr), format: :json
        v = Employee.last
        expect(v.skills.count).to eq 2
        expect(v.skills.first.name).to eq('rails')
      end
    end



    context 'with invalid attributes' do
      it 'does not create the employee' do
        expect do
          post :create, employee: attributes_for(:employee, first_name: nil), format: :json
        end.to change(Employee, :count).by(0)
      end

      it 'responds with 422' do
        post :create, employee: attributes_for(:employee, first_name: nil), format: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "PUT #update method" do
    context 'with correct params' do
      it "should update employee"  do

        patch :update, id: employees.first.id,
          employee: { skills: [{"name"=>"rspec"}, {"name"=>"git"}]},
          format: :json

        expected_json = {message: "OK"}.to_json
        expect(response.body).to eq expected_json
      end

      it 'when employee should update with correct skills' do

        patch :update, id: employees.first.id,
          employee: {skills: [{"name"=>"css"}, {"name"=>"sql"}]},
          format: :json

        v = employees.first
        v.reload
        expect(v.skills.count).to eq 2
        expect(v.skills.first.name).to eq('css')
      end
    end

    context 'with invalid params' do
      it 'responds with 422' do
        patch :update, id: employees.first.id,
          employee: { phone: 'dsafas###'},
          format: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'delete method' do
    it "should delete post" do
       delete :destroy, id: employees.first.id
      expected_json = { message: "OK" }.to_json
      expect(response.body).to eq expected_json
    end

    it "DECR employees count" do
      expect do
       delete :destroy, id: employees.first.id
      end.to change(Employee, :count).by(-1)
    end
  end


end
