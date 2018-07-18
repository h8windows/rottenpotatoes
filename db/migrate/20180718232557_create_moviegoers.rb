class CreateMoviegoers < ActiveRecord::Migration[5.0]
  def change
    create_table :moviegoers do |t|
      t.string :name
      t.string :provider

      t.timestamps
    end
  end
end
