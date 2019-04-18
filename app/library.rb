# Collection of games
class Library
  attr_accessor :games

  def initialize
    @games = []
    open
  end

  def save
    File.open('app/data/games.yml', 'w') do |file|
      file.write(games.to_yaml)
    end
  end

  def sort_user_scores
    filter_unknown_games
    filter_bad_games
    # Calling this once doesn't remove all for some reason...
    filter_bad_games

    games.sort_by(&:date).reverse!
  end

  def filter_unknown_games
    games.each do |game|
      games.delete(game) if game.score.zero? && game.user_score.zero?
    end
  end

  def filter_bad_games
    games.each do |game|
      games.delete(game) if game.score < 60
    end
  end

  def print
    games.each(&method(:puts))
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
    @games = YAML.load_file('app/data/games.yml') if File.exist?('app/data/games.yml')
  end
end
