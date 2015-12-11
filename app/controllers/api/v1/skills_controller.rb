class Api::V1::SkillsController < ApplicationController

  def index
    @skills = Skill.all
    render json: { skills: @skills }
  end

  def show
    @skill = Skill.find_by name: params[:id]

    if @skill
      render json: { message: false }
    else
      render json: { message: true }
    end
  end

end
