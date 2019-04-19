require_relative 'app/lib/scraper'
require_relative 'app/lib/mailer'
require 'yaml'

scraper = Scraper.new('https://www.metacritic.com/browse/games/release-date/new-releases/ps4/date')

library = scraper.parse_games
library.save

# puts library

Mailer.new(library)
