class CreateJobGenres < ActiveRecord::Migration
  def change
    create_table :job_genres do |t|
      t.integer :job_id
      t.integer :genre_id

      t.timestamps null: false
    end
  end
end
