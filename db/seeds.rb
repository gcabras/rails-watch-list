# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Be sure to clean the db when seeding

require 'open-uri'
require 'json'

mdb_url = 'https://api.themoviedb.org/3/movie/top_rated?api_key=64f784046b4a3bcc1414ee6a894812ea&language=en-US&page=1'

movies_doc = URI.open(mdb_url).read

Movie.destroy_all

movies = JSON.parse(movies_doc)['results']

movies.each do |movie|
  Movie.create!(
    title: movie['original_title'],
    overview: movie['overview'],
    poster_url: "https://image.tmdb.org/t/p/w500/#{movie['poster_path']}",
    rating: movie['vote_average']
  )
end
