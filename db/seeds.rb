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
# url = URI("https://imdb-api.com/en/API/Top250TVs/#{api_key}")
#url = URI("https://imdb-api.com/en/API/Title/#{api_key}/tt0110413")

https = Net::HTTP.new(url.host, url.port)

https.use_ssl = true

request = Net::HTTP::Get.new(url)

response = https.request(request)

data = JSON.parse(response.body)

data["items"].sample(20).each do |item|
  movie = Movie.new(
    title: item["title"],
    year: item["year"].to_i,
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
  # add poster
  url_poster = URI("https://imdb-api.com/API/Posters/#{api_key}/#{item['id']}")
  https_poster = Net::HTTP.new(url_poster.host, url_poster.port)
  https_poster.use_ssl = true
  request_poster = Net::HTTP::Get.new(url_poster)
  response_poster = https_plot.request(request_poster)
  data_poster = JSON.parse(response_poster.body)
  movie.poster_url = data_poster['posters'].first['link']
  # add images
  url_images = URI("https://imdb-api.com/en/API/Images/#{api_key}/#{item['id']}")
  https_images = Net::HTTP.new(url_images.host, url_images.port)
  https_images.use_ssl = true
  request_images = Net::HTTP::Get.new(url_images)
  response_images = https_plot.request(request_images)
  data_images = JSON.parse(response_images.body)
  movie.imageone = data_images['items'][0]['image']
  movie.imageonetitle = data_images['items'][0]['title']
  movie.imagetwo = data_images['items'][1]['image']
  movie.imagetwotitle = data_images['items'][1]['title']
  movie.imagethree = data_images['items'][2]['image']
  movie.imagethreetitle = data_images['items'][2]['title']
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
  cast = Cast.new
  cast.movie = movie
  cast.save!
  data_cast['actors'].each do |actor|
    actorcast = Actor.new
    actorcast.name = actor["name"]
    actorcast.role = actor["asCharacter"]
    actorcast.image = actor["image"]
    url_actor = URI("https://imdb-api.com/en/API/Name/#{api_key}/#{actor['id']}")
    https_actor = Net::HTTP.new(url_actor.host, url_actor.port)
    https_actor.use_ssl = true
    request_actor = Net::HTTP::Get.new(url_actor)
    response_actor = https_actor.request(request_actor)
    data_actor = JSON.parse(response_actor.body)
    actorcast.summary = data_actor["summary"]
    actorcast.birthdate = data_actor["birthDate"]
    actorcast.deathdate = data_actor["deathDate"] unless data_actor['deathDate'].nil?
    actorcast.awards = data_actor["awards"]
    actorcast.cast = cast
    actorcast.save!
  end
end
