# frozen_string_literal: true

require 'csv'

class TransactionsImporter
  def self.call(file)
    new(file).call
  end

  def call
    return false unless file_valid?

    parse_csv
    persist_transactions
  end

  private

  attr_reader :file, :csv

  def initialize(file)
    @file = file
  end

  def file_valid?
    return false unless File.exist?(file)

    content = File.read(file, encoding: 'utf-8')
    puts content.valid_encoding?
    return false unless content.valid_encoding?

    true
  end

  def parse_csv
    @csv = CSV.parse(
      File.read(file),
      headers: true,
      header_converters: ->(h) { h.gsub(' ', '_' ).downcase.to_sym }
    )
  end

  def persist_transactions
    csv.each do |row|
      Transaction.create row.to_hash
    end
  end
end
