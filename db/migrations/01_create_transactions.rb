# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:transactions) do
      primary_key :id
      String :ticker
      String :type
      BigDecimal :quantity
      BigDecimal :price_per_share
      BigDecimal :total_amount
      String :currency, size: 5
      BigDecimal :fx_rate
      DateTime :date
    end
  end
end
