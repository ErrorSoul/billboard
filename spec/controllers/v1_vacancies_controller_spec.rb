require 'rails_helper'

describe Api::V1::VacanciesController do
  let!(:vacancies) { create_list(:vacancy, 10, :published) }
  let!(:skills) { create_list(:skill, 2) }
  let!(:skill) { create :skill }
  let!(:vacancy) { build :vacancy }

  describe 'GET #index' do
    context 'with valid attributes' do
      it 'return vacancies[0, 5]' do
        get :index, page: 0, format: :json
        expected_json = {
          vacancies: vacancies.sort_by(&:salary).reverse[0, 5],
          page_num:  Vacancy.page_num,
          page: 0
        }.to_json
        expect(response.body).to eq expected_json
      end
    end

    context 'with valid attributes' do
      it 'return vacancies[5, 10]' do
        get :index, page: 1, format: :json
        expected_json = {
          vacancies: vacancies.sort_by(&:salary).reverse[5, 10],
          page_num:  Vacancy.page_num,
          page: 1
        }.to_json
        expect(response.body).to eq expected_json
      end
    end
  end

  describe "GET #show" do
    it "should return vacancy " do
      get :show, id: vacancies.first.id, format: :json
      expected_json = {
        vacancy: vacancies.first.as_json(include: :skills)
      }.to_json
      expect(response.body).to eq expected_json
    end
  end

  describe 'POST #create' do
    let(:skills_attr) { [{"id"=>2, "name"=>"rails"}, {"id"=>3, "name"=>"ruby"}] }

    context 'with valid attributes' do
      it 'creates the vacancy with skills' do
         expect do
          post :create, vacancy: attributes_for(:vacancy, skills: skills_attr), format: :json
        end.to change(Vacancy, :count).by(1)
      end

      it 'when vacancy create should be OK message' do
        post :create, vacancy: attributes_for(:vacancy, skills: skills_attr), format: :json
        expected_json = { message: 'OK' }.to_json
        expect(response.body).to eq expected_json
      end


      it 'when vacancy create should be correct skills' do
        post :create, vacancy: attributes_for(:vacancy, skills: skills_attr), format: :json
        v = Vacancy.last
        expect(v.skills.count).to eq 2
        expect(v.skills.first.name).to eq('rails')
      end
    end



    context 'with invalid attributes' do
      it 'does not create the vacancy' do
        expect do
          post :create, vacancy: attributes_for(:vacancy, name: nil), format: :json
        end.to change(Vacancy, :count).by(0)
      end

      it 'responds with 422' do
        post :create, vacancy: attributes_for(:vacancy, name: nil), format: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "PUT #update method" do
    context 'with correct params' do
      it "should update vacancy"  do

        patch :update, id: vacancies.first.id,
          vacancy: { skills: [{"name"=>"rspec"}, {"name"=>"git"}]},
          format: :json

        expected_json = {message: "OK"}.to_json
        expect(response.body).to eq expected_json
      end

      it 'when vacancy should update with correct skills' do

        patch :update, id: vacancies.first.id,
          vacancy: {skills: [{"name"=>"css"}, {"name"=>"sql"}]},
          format: :json

        v = vacancies.first
        v.reload
        expect(v.skills.count).to eq 2
        expect(v.skills.first.name).to eq('css')
      end
    end

    context 'with invalid params' do
      it 'responds with 422' do
        patch :update, id: vacancies.first.id,
          vacancy: { phone: 'dsafas###'},
          format: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'delete method' do
    it "should delete post" do
       delete :destroy, id: vacancies.first.id
      expected_json = { message: "OK" }.to_json
      expect(response.body).to eq expected_json
    end

    it "DECR vacancies count" do
      expect do
       delete :destroy, id: vacancies.first.id
      end.to change(Vacancy, :count).by(-1)
    end
  end


end
