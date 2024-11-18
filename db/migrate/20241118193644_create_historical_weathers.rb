class CreateHistoricalWeathers < ActiveRecord::Migration[8.0]
  def change
    create_table :historical_weathers do |t|
      t.string :location
      t.date :date
      t.float :temperature
      t.float :precipitation

      t.timestamps
    end
  end
end
