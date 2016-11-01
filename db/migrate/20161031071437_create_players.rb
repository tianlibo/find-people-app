class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.decimal :latitude, :precision => 11, :scale => 8
      t.decimal :longitude, :precision => 11, :scale => 8
      t.decimal :accuracy, :precision => 9, :scale => 3
      t.integer :crumbs_count, :default => 0

      t.timestamps 
    end
  end
end
