class CreateMusicianInstruments < ActiveRecord::Migration
  def change
    create_join_table :profiles, :instruments do |t|
      t.index :profile_id
      t.index :instrument_id
    end
    remove_column :profiles, :instrument_id, :integer, references: :instrument
  end
end
