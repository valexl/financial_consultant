Sequel.migration do
  change do
    create_table(:investments) do
      primary_key :id
      String :type, null: false
      String :name, null: false
      BigDecimal :price_value, size: [10, 2], null: false
      String :price_currency, null: false
      BigInt :balance_id, null: false
    end
  end
end