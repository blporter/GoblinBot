require 'nokogiri'
require 'mechanize'
require_relative 'benchmarker'
require_relative '../game'
require_relative '../library'

# Class used for scraping for Game data
# Checks if game exists in library before parsing summaries
class Scraper
  attr_accessor :parse_page, :agent

  def initialize(url)
    puts 'Fetching Games'
    @agent = Mechanize.new { |agent| agent.user_agent_alias = 'Windows Chrome' }
    @agent.request_headers
    @parse_page ||= agent.get(url)
  end

  def parse_games
    names = parse_names
    dates = parse_dates
    scores = parse_scores
    user_scores = parse_user_scores

    library = Library.new
    benchmarker = Benchmarker.new

    benchmarker.run do
      fill_library(names, dates, scores, user_scores, library)
    end

    library
  end

  private

  def fill_library(names, dates, scores, user_scores, library)
    puts 'Fetching Game Summaries'
    games = []
    (0...names.size).each do |i|
      print '.'
      game = Game.new(names[i].strip,
                      dates[i].strip,
                      scores[i].strip,
                      user_scores[i].strip)

      next if library.games.include? game
      next if game.score.zero? && game.user_score.zero?
      next if game.score < 60

      summary = parse_summary(names[i].strip)
      game.summary = summary.nil? ? 'None available.' : summary[0]
      games.push(game)
    end
    library.games.unshift(games).flatten!
  end

  def product_wrap
    parse_page.css('div#main').css('div.product_wrap')
  end

  def parse_names
    product_wrap.css('div.product_title a').map(&:text)
  end

  def parse_dates
    product_wrap.css('li.release_date').css('span.data').map(&:text)
  end

  def parse_scores
    product_wrap.css('div.product_score').map(&:text)
  end

  def parse_user_scores
    product_wrap.css('li.product_avguserscore')
                .css('span.textscore').map(&:text)
  end

  def game_url(name)
    game = name.gsub(/&\s/, '')
               .gsub(/[^0-9A-Za-z\s\-!]/, '')
               .downcase.tr(' ', '-')
    'https://www.metacritic.com/game/playstation-4/' + game
  end

  def parse_summary(name)
    begin
      summary_page = agent.get(game_url(name))
    rescue StandardError => err
      puts "Error in #{name}: #{err}"
      return nil
    end

    summary_page.css('div#main_content div.summary_wrap')
                .css('ul.summary_details span.data span').map(&:text)
  end
end
