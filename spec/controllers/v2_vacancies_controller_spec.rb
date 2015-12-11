require 'rails_helper'

describe Api::V2::VacanciesController do
  let!(:vacancies_published) { create_list(:vacancy, 5) }
  let!(:vacancies_hide) { create_list(:vacancy, 5, :in_the_past) }


  describe 'GET #index' do
    context 'with valid attributes' do
      it 'return only published vacancies' do
        get :index, page: 0, format: :json
        expected_json = {
          vacancies: vacancies_published.sort_by(&:salary).reverse,
          page_num:  Vacancy.public_num,
          page: 0
        }.to_json
        expect(response.body).to eq expected_json
      end
    end

    context 'with valid attributes' do
      it 'should return nil' do
        get :index, page: 1, format: :json
        expected_json = {
          vacancies: [],
          page_num:  Vacancy.public_num,
          page: 1
        }.to_json
        expect(response.body).to eq expected_json
      end
    end
  end

  describe 'GET #except' do
    before do
      @vacancies = create_list(:vacancy, 5)
      @skills = create_list(:skill, 2)
      @skill = create :skill
      @employee = create :employee
    end

    context 'when skills in employee equal skills in all vacancies' do
      it "should return array of vacancies with equals skills" do
        vacancies_with_skills = @vacancies.map do |v|
          v.skills << @skills
          v
        end

        @employee.skills << @skills

        get :except, id: @employee.id, page: 0
        expected_json = {
          message: 'OK',
          vacancies: vacancies_with_skills.sort_by(&:salary).reverse.as_json(include: :skills),
          page_flag: false
        }.to_json
        expect(response.body).to eq expected_json
      end
    end

    context 'when skills in employee equal skills in part of vacancies' do
      it "should return array of vacancies with equals skills" do
        @vacancies_with_skills = @vacancies[1, 5].map do |v|
          v.skills << @skills
          v
        end

        @employee.skills << @skills
        @vacancies_with_skills.first.skills << @skill
        get :except, id: @employee.id, page: 0
        expected_json = {
          message: 'OK',
          vacancies: @vacancies_with_skills.sort_by(&:salary).reverse.as_json(include: :skills),
          page_flag: false
        }.to_json
        expect(response.body).to eq expected_json
      end
    end

    context 'when skills vacancy.skills > employee.skills' do
      it "should return this vacancy too" do
        @vacancies_with_skills = @vacancies.map do |v|
          v.skills << @skills
          v
        end

        @employee.skills << @skills
        @vacancies_with_skills.first.skills << @skill
        get :except, id: @employee.id, page: 0
        expected_json = {
          message: 'OK',
          vacancies: @vacancies_with_skills.sort_by(&:salary).reverse.as_json(include: :skills),
          page_flag: false
        }.to_json
        expect(response.body).to eq expected_json
      end
    end
  end

  describe 'GET #intersect' do
    before do
      @vacancies = create_list(:vacancy, 5)
      @skills = create_list(:skill, 2)
      @opt_skills = create_list(:skill, 2)
      @skill = create :skill
      @employee = create :employee
    end

    context 'when  skills in employee intersect skills in vacancies' do
      it "should return array of vacancies with part of  skills" do
        vacancies_with_skills = @vacancies.map do |v|
          v.skills << @skills
          v.skills << @skill
          v
        end

        @employee.skills << @skill
        @employee.skills << @opt_skills

        get :intersect, id: @employee.id, page: 0
        expected_json = {
          message: 'OK',
          vacancies: vacancies_with_skills.sort_by(&:salary).reverse.as_json(include: :skills),
          page_flag: false
        }.to_json
        expect(response.body).to eq expected_json
      end
    end

    context 'when skills in employee intersect skills in part of vacancies, , but not all' do
      it "should return array of vacancies with equals skills" do
        @vacancies_with_skills = @vacancies[1, 5].map do |v|
          v.skills << @skills
          v.skills << @skill
          v
        end

        @employee.skills << @skills
        @employee.skills << @opt_skills
        @vacancies.first.skills << @skills
        @vacancies.first.skills << @opt_skills
        get :intersect, id: @employee.id, page: 0
        expected_json = {
          message: 'OK',
          vacancies: @vacancies_with_skills.sort_by(&:salary).reverse.as_json(include: :skills),
          page_flag: false
        }.to_json
        expect(response.body).to eq expected_json
      end
    end
  end

end
