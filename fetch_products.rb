require "json"
require "dotenv"
require "stripe"
require "open-uri"
require "fileutils"

Dotenv.load

Stripe.api_key = ENV['STRIPE_SECRET_KEY']

products = Stripe::Product.all(limit: 100).sort_by(&:name)

json = JSON.pretty_generate(products)
File.open('products.json', 'w') { |file| file.write(json) }
