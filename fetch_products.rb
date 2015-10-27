require "json"
require "dotenv"
require "stripe"
require "open-uri"
require "fileutils"

Dotenv.load

Stripe.api_key = ENV['STRIPE_SECRET_KEY']

products = Stripe::Product.all

FileUtils.rm_rf(Dir.glob("Stone/Crystals.xcassets/*.imageset"))

products.each do |product|
  url = product.images.first
  filename = "#{product.id}.jpg"
  dirname = "Stone/Crystals.xcassets/#{product.id}.imageset"
  FileUtils.mkdir_p(dirname)
  File.open("#{dirname}/#{filename}", 'w') do |file|
    file.write(open(url).read)
  end
  json_string = JSON.pretty_generate({
    images: [
      {
        idiom: "iphone",
        scale: "1x"
      },
      {
        idiom: "iphone",
        filename: filename,
        scale: "2x"
      },
      {
        idiom: "iphone",
        scale: "3x"
      }
    ],
    info: {
      version: 1,
      author: "xcode"
    }
  }).gsub(/":/, '" :')
  File.open("#{dirname}/contents.json", 'w') do |file|
    file.write(json_string)
  end
end

json = JSON.pretty_generate(products.values)
File.open('Stone/products.json', 'w') { |file| file.write(json) }
