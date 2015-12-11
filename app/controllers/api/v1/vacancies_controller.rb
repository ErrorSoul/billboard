class Api::V1::VacanciesController < ApplicationController

  before_action :find_vacancy, only: [:show, :update, :destroy]

  def index
    @vacancies = Vacancy.pagination(params[:page]).salary_ord
    @page_num = Vacancy.page_num
    render json: {
      vacancies: @vacancies,
      page_num:  @page_num,
      page: params[:page]
    }
  end

  def show
    @vacancy = Vacancy.includes(:skills).find params[:id]
    render json: { vacancy: @vacancy.as_json(include: :skills) }
  end

  def create
    @vacancy = Vacancy.new vacancy_params
    if @vacancy.save
      render json: { message: 'OK' }
    else
        render json: @vacancy.errors, status: :unprocessable_entity
    end
  end

  def update
    if @vacancy.update_attributes vacancy_params
      render json: { message: 'OK' }
    else
        render json: @vacancy.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @vacancy.destroy
      render json: { message: 'OK' }
    else
      render json: @vacancy.errors, status: :unprocessable_entity
    end
  end

  private

  def find_vacancy
    @vacancy = Vacancy.includes(:skills).find params[:id]
  end

  def vacancy_params
    unless params["vacancy"]["skills"].blank?
      params["vacancy"]["all_skills"] = params["vacancy"]["skills"]
      params["vacancy"].delete("skills")
    end

    params.fetch(:vacancy, {}).permit(
      :name, :email, :phone, :salary, :validity,
      :published_at, :id, :all_skills => [:name]
    )
  end
end
