# frozen_string_literal: true

class Transaction < Sequel::Model
  def display_amount
    self.total_amount.to_f
  end
end
