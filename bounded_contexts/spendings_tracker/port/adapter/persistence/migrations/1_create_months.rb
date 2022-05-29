Sequel.migration do
  change do
    create_table(:months) do
      column :id, String, :primary_key => true
      column :year, Integer
      column :month_number, Integer
    end
  end
end