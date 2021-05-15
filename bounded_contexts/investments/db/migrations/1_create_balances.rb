Sequel.migration do
  change do
    create_table(:balances) do
      primary_key :id
      jsonb :cash, null: false, default: '{}'
      jsonb :investments, null: false, default: '[]'
    end
  end
end