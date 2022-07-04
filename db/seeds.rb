# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Be sure to clean the db when seeding

require 'uri'
require 'net/http'
require 'json'

api_key = 'k_71bzmhl3'

url = URI("https://imdb-api.com/en/API/Top250Movies/#{api_key}")

#url = URI("https://imdb-api.com/en/API/Title/#{api_key}/tt0110413")

https = Net::HTTP.new(url.host, url.port)

https.use_ssl = true

request = Net::HTTP::Get.new(url)

response = https.request(request)

data = JSON.parse(response.body)

data["items"].sample(2).each do |item|
  movie = Movie.new(
    title: item["title"],
    year: item["year"].to_i,
    poster_url: item["image"],
    rating: item["imDbRating"].to_i
  )
  # add overview
  url_plot = URI("https://imdb-api.com/en/API/Title/#{api_key}/#{item['id']}")
  https_plot = Net::HTTP.new(url_plot.host, url_plot.port)
  https_plot.use_ssl = true
  request_plot = Net::HTTP::Get.new(url_plot)
  response_plot = https_plot.request(request_plot)
  data_plot = JSON.parse(response_plot.body)
  movie.overview = data_plot['plot']
  # add official website
  url_ext = URI("https://imdb-api.com/en/API/ExternalSites/#{api_key}/#{item['id']}")
  https_ext = Net::HTTP.new(url_ext.host, url_ext.port)
  https_ext.use_ssl = true
  request_ext = Net::HTTP::Get.new(url_ext)
  response_ext = https_ext.request(request_ext)
  data_ext = JSON.parse(response_ext.body)
  movie.streaming = data_ext['officialWebsite'] unless data_ext['officialWebsite'].nil?
  # add trailer
  url_trailer = URI("https://imdb-api.com/en/API/Trailer/#{api_key}/#{item['id']}")
  https_trailer = Net::HTTP.new(url_trailer.host, url_trailer.port)
  https_trailer.use_ssl = true
  request_trailer = Net::HTTP::Get.new(url_trailer)
  response_trailer = https_ext.request(request_trailer)
  data_trailer = JSON.parse(response_trailer.body)
  movie.trailer = data_trailer['linkEmbed']
  # add director and cast
  url_cast = URI("https://imdb-api.com/en/API/FullCast/#{api_key}/#{item['id']}")
  https_cast = Net::HTTP.new(url_cast.host, url_cast.port)
  https_cast.use_ssl = true
  request_cast = Net::HTTP::Get.new(url_cast)
  response_cast = https.request(request_cast)
  data_cast = JSON.parse(response_cast.body)
  moviedirector = Director.new
  data_cast["directors"]["items"].each do |director|
    moviedirector.name = director["name"]
    url_director = URI("https://imdb-api.com/en/API/Name/#{api_key}/#{director['id']}")
    https_director = Net::HTTP.new(url_director.host, url_director.port)
    https_director.use_ssl = true
    request_director = Net::HTTP::Get.new(url_director)
    response_director = https_director.request(request_director)
    data_director = JSON.parse(response_director.body)
    moviedirector.summary = data_director['summary']
    moviedirector.birthdate = data_director['birthDate']
    moviedirector.deathdate = data_director['deathDate'] unless data_director['deathDate'].nil?
    moviedirector.awards = data_director['awards']
  end
  moviedirector.save!
  movie.director = moviedirector
  movie.save!
end
