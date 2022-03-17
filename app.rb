# frozen_string_literal: true

require 'pry' if ENV['RACK_ENV'] == 'development'
require 'roda'
require 'securerandom'
require 'sequel'

require './db'

%w[models services].each do |dir|
  Dir[File.join(__dir__, dir, '**', '*.rb')].each { |file| require file }
end

class App < Roda
  plugin :render
  plugin :sessions, secret: SecureRandom.base64(46)
  plugin :flash
  plugin :assets,
    css: ['bootstrap.css'],
    js: ['bootstrap.bundle.min.js']
  compile_assets unless ENV['RACK_ENV'] == 'development'

  route do |r|
    r.assets

    r.root do
      @transactions = Transaction.dataset
      view 'home'
    end

    r.on 'import' do
      r.get do
        view 'import'
      end

      r.post do
        if TransactionsImporter.call(r.params['form_file'])
          flash[:success] = 'Successfully imported transactions'
          r.redirect '/'
        else
          flash[:error] = 'Failed to import transactions'
          r.redirect
        end
      end
    end

    r.on 'statistics' do
      r.on 'dividends' do
        r.get String do |ticker|
          @dividends = DividendsService.call(ticker.upcase)
          view 'statistics/dividends_per_ticker'
        end

        r.get do
          @tickers = Transaction.where(type: 'DIVIDEND').map(&:ticker).uniq.sort
          view 'statistics/dividends'
        end
      end
    end
  end
end
