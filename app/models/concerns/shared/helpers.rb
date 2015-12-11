module Shared
  module Helpers
    extend ActiveSupport::Concern

    def all_skills=(skills)
      skills_array = skills.map do |s|
        Skill.find_or_create_by!(name: s['name'])
      end.uniq

      self.skill_items = skills_array.map do |skill|
        SkillItem.new(skill_id: skill.id)
      end
    end

   end
end
