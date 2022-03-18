# frozen_string_literal: true

class DividendsService
  def self.call(ticker)
    new(ticker).call
  end

  def call
    return {} unless dataset.any?

    {
      transactions: dividend_transactions,
      total_amount: dividends_total_amount,
      amount_per_month: dividends_amount_per_month,
      amount_per_month_per_share: dividends_amount_per_month / stock_shares,
      amount_last_month_per_share: last_dividend_per_month_per_share,
      stock: {
        shares: stock_shares,
        spent_to_buy: cash_spent_to_buy
      }
    }
  end

  private

  attr_reader :ticker

  def initialize(ticker)
    @ticker = ticker
  end

  def dataset
    @dataset ||= Transaction.where(ticker: ticker).order(:date)
  end

  def dividend_transactions
    @dividend_transactions ||= dataset.where(type: 'DIVIDEND')
  end

  def dividends_total_amount
    @dividends_total_amount ||= dividend_transactions.sum(:total_amount)
  end

  def dividends_amount_per_month
    @dividends_amount_per_month ||= begin
      months = (dataset.first.date.to_date..Date.today.to_date).step(30).count
      dividends_total_amount / months
    end
  end

  def last_dividend_per_month_per_share
    10000000 # TODO: implement
  end

  def stock_shares
    @stock_shares ||= dataset.where(type: 'BUY').sum(:quantity)
  end

  def cash_spent_to_buy
    dataset.where(type: 'BUY').sum(:total_amount)
  end
end
