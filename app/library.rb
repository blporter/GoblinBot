# frozen_string_literal: true

# Collection of games
class Library
  attr_accessor :games

  GAMES_CACHE = 'app/data/games.yml'

  def initialize
    @games = []
    open
  end

  def save
    sort
    File.open(GAMES_CACHE, 'w') do |file|
      file.write(games.to_yaml)
    end
  end

  def sort
    games.sort_by(&:date).reverse!
  end

  def to_s
    list = ''
    games.each do |game|
      list += "#{game}\n\n"
    end
    list
  end

  private

  def open
    @games = YAML.load_file(GAMES_CACHE) if File.exist?(GAMES_CACHE)
  end
end
