module Shared
  module SQL
    extend ActiveSupport::Concern

    included do
      scope :find_equal, -> obj do
        query = <<-SQL
          SELECT
            *
          FROM #{ name.pluralize.downcase } AS e
          WHERE NOT EXISTS (
            (
             SELECT skills.id FROM public.skills
             INNER JOIN skill_items
             ON skill_items.skill_id = skills.id AND
                skill_items.skillable_id = #{ obj.id } AND
                skill_items.skillable_type = '#{ obj.class.to_s }'
            )
          EXCEPT
            (
             SELECT skills.id FROM public.skills
             INNER JOIN skill_items
             ON skill_items.skill_id = skills.id AND
                skill_items.skillable_id = e.id  AND
                skill_items.skillable_type = '#{ name }'
            )
          );
        SQL
        find_by_sql query

      end

      scope :find_part, -> obj do
        query = <<-SQL
           (
            (
             SELECT skills.id FROM public.skills
             INNER JOIN skill_items
             ON skill_items.skill_id = skills.id AND
                skill_items.skillable_id = #{ obj.id } AND
                skill_items.skillable_type = '#{ obj.class.to_s }'
            )
          INTERSECT
            (
             SELECT skills.id FROM public.skills
             INNER JOIN skill_items
             ON skill_items.skill_id = skills.id AND
                skill_items.skillable_id = e.id  AND
                skill_items.skillable_type = '#{ name }'
            )
          )
        SQL



        part = <<-PART
          (
             SELECT skills.id FROM public.skills
             INNER JOIN skill_items
             ON skill_items.skill_id = skills.id AND
                skill_items.skillable_id = #{ obj.id } AND
                skill_items.skillable_type = '#{ obj.class.to_s }'
            )
        PART

        qw = <<-SQL1
          SELECT
            *
          FROM #{ name.pluralize.downcase } AS e
          WHERE EXISTS #{ query }
          AND (
            SELECT COUNT(*)
            FROM #{ part } as sk
            ) > (SELECT COUNT (*) FROM #{ query } as y);
        SQL1
         find_by_sql qw
      end
    end

  end
end
