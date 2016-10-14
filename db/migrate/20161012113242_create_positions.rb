class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.belongs_to :user, index: true
      t.decimal :latitude, :precision => 11, :scale => 8
      t.decimal :longitude, :precision => 11, :scale => 8
      t.decimal :accuracy, :precision => 9, :scale => 3

      t.timestamps 
    end
  end
end
