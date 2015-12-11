module Shared
  module Scopes
    extend ActiveSupport::Concern

    PER_PAGE = 5

    included do

      scope :pagination, -> page do
        offset(page.to_i * PER_PAGE)
          .limit(PER_PAGE)
      end

      scope :page_num, -> { (count / PER_PAGE.to_f).ceil }
      scope :public_num, -> { (to_show.count / PER_PAGE.to_f).ceil }
      scope :optional, -> page do
        salary_ord.to_show
        .pagination page
      end

      scope :needed, -> obj, page do
        includes(:skills)
          .where(id: find_equal(obj))
          .includes(:skills)
          .optional page
      end

      scope :part_of_needed, -> obj, page do
        includes(:skills)
          .where(id: find_part(obj))
          .optional page
      end
    end
  end
end
