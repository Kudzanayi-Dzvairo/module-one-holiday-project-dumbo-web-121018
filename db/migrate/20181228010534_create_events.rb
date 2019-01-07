class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :event
      t.string :description
      t.string :host
      t.string :venue
      t.datetime :date_time
    end
  end
end
