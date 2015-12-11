class Api::V1::EmployeesController < ApplicationController

  before_action :find_employee, only: [:show, :update, :destroy]

  def index
    @employees = Employee.pagination(params[:page]).salary_ord
    @page_num = Employee.page_num
    render json: {
      employees: @employees,
      page_num:  @page_num,
      page: params[:page]
    }
  end

  def show
    @employee = Employee.includes(:skills).find params[:id]
    render json: { employee: @employee.as_json(include: :skills) }
  end

  def create
    @employee = Employee.new employee_params
    if @employee.save
      render json: { message: 'OK' }
    else
        render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def update
    if @employee.update_attributes employee_params
      render json: { message: 'OK' }
    else
        render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @employee.destroy
      render json: { message: 'OK' }
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  private

  def find_employee
    @employee = Employee.includes(:skills).find params[:id]
  end

  def employee_params
    unless params["employee"]["skills"].blank?
      params["employee"]["all_skills"] = params["employee"]["skills"]
      params["employee"].delete("skills")
    end

    params.fetch(:employee, {}).permit(
      :first_name, :middle_name, :last_name, :status,
      :email, :phone, :salary, :id, :all_skills => [:name]
    )
  end
end
