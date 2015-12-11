require 'rails_helper'

describe Api::V2::EmployeesController do
  let!(:employees_published) { create_list(:employee, 5) }
  let!(:employees_hide) { create_list(:employee, 5, :stoped) }


  describe 'GET #index' do
    context 'with valid attributes' do
      it 'return only published employees' do
        get :index, page: 0, format: :json
        expected_json = {
          employees: employees_published.sort_by(&:salary),
          page_num:  Employee.public_num,
          page: 0
        }.to_json
        expect(response.body).to eq expected_json
      end
    end

    context 'with valid attributes' do
      it 'should return nil' do
        get :index, page: 1, format: :json
        expected_json = {
          employees: [],
          page_num:  Employee.public_num,
          page: 1
        }.to_json
        expect(response.body).to eq expected_json
      end
    end
  end

  describe 'GET #except' do
    before do
      @employees = create_list(:employee, 5)
      @skills = create_list(:skill, 2)
      @skill = create :skill
      @vacancy = create :vacancy
    end

    context 'when skills in vacancy equal skills in all employees' do
      it "should return array of employees with equals skills" do
        @employees_with_skills = @employees.map do |v|
          v.skills << @skills
          v
        end

        @vacancy.skills << @skills
        #pry.binding
        get :except, id: @vacancy.id, page: 0
        expected_json = {
          message: 'OK',
          employees: @employees_with_skills.sort_by(&:salary).as_json(include: :skills),
          page_flag: false
        }.to_json
        expect(response.body).to eq expected_json
      end
    end

    context 'when skills in vacancy equal skills in part of employees' do
      it "should return array of employees with equals skills" do
        @employees_with_skills = @employees[1, 5].map do |v|
          v.skills << @skills
          v
        end

        @vacancy.skills << @skills
        @employees_with_skills.first.skills << @skill
        get :except, id: @vacancy.id, page: 0
        expected_json = {
          message: 'OK',
          employees: @employees_with_skills.sort_by(&:salary).as_json(include: :skills),
          page_flag: false
        }.to_json
        expect(response.body).to eq expected_json
      end
    end

    context 'when skills employee.skills > vacancy.skills' do
      it "should return this employee too" do
        @employees_with_skills = @employees.map do |v|
          v.skills << @skills
          v
        end

        @vacancy.skills << @skills
        @employees_with_skills.first.skills << @skill
        get :except, id: @vacancy.id, page: 0
        expected_json = {
          message: 'OK',
          employees: @employees_with_skills.sort_by(&:salary).as_json(include: :skills),
          page_flag: false
        }.to_json
        expect(response.body).to eq expected_json
      end
    end
  end

  describe 'GET #intersect' do
    before do
      @employees = create_list(:employee, 5)
      @skills = create_list(:skill, 2)
      @opt_skills = create_list(:skill, 2)
      @skill = create :skill
      @vacancy = create :vacancy
    end

    context 'when  skills in vacancy intersect skills in employees' do
      it "should return array of employees with part of  skills" do
        employees_with_skills = @employees.map do |v|
          v.skills << @skills
          v.skills << @skill
          v
        end

        @vacancy.skills << @skill
        @vacancy.skills << @opt_skills

        get :intersect, id: @vacancy.id, page: 0
        expected_json = {
          message: 'OK',
          employees: employees_with_skills.sort_by(&:salary).as_json(include: :skills),
          page_flag: false
        }.to_json
        expect(response.body).to eq expected_json
      end
    end

    context 'when skills in vacancy intersect skills in part of employees, , but not all' do
      it "should return array of employees with equals skills" do
        @employees_with_skills = @employees[1, 5].map do |v|
          v.skills << @skills
          v.skills << @skill
          v
        end

        @vacancy.skills << @skills
        @vacancy.skills << @opt_skills
        @employees.first.skills << @skills
        @employees.first.skills << @opt_skills
        get :intersect, id: @vacancy.id, page: 0
        expected_json = {
          message: 'OK',
          employees: @employees_with_skills.sort_by(&:salary).as_json(include: :skills),
          page_flag: false
        }.to_json
        expect(response.body).to eq expected_json
      end
    end
  end
end
