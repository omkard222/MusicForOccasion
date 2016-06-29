class CreateReviewMusician < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references  :user,       index: true
      t.references  :profile,    index: true
      t.text        :message
      t.integer     :score

      t.timestamps null: false
    end
    add_column :reviews, :deleted_at, :datetime
    add_index :reviews, :deleted_at
  end
end
