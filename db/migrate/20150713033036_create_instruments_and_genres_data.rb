class CreateInstrumentsAndGenresData < ActiveRecord::Migration
  def change
    create_table :instruments do |t|
      t.string :instrument
    end
    create_table :genres do |t|
      t.string :genre
    end
    create_table :musician_genres do |t|
      t.references :genre,    index: true
      t.references :profile,  index: true
    end
    add_column :profiles, :instrument_id, :integer, references: :instrument
  end
end
