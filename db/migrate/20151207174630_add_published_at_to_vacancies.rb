class AddPublishedAtToVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :published_at, :datetime
  end
end
