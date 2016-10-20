class CreateCrumbs < ActiveRecord::Migration
  def change
    create_table :crumbs do |t|
      t.decimal :latitude, :precision => 11, :scale => 8
      t.decimal :longitude, :precision => 11, :scale => 8
      t.decimal :accuracy, :precision => 9, :scale => 3
      t.boolean :ate, default: false
      
      t.timestamps 
    end
  end
end
