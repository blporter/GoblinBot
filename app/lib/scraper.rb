require 'nokogiri'
require 'mechanize'
require_relative 'benchmarker'
require_relative '../game'
require_relative '../library'

# Class used for scraping for Game data
# Checks if game exists in library before parsing summaries
class Scraper
  attr_accessor :parse_page, :agent

  def initialize(url = nil)
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

    puts 'Fetching Game Summaries'
    benchmarker.run do
      fill_library(names, dates, scores, user_scores, library)
    end

    library
  end

  private

  def fill_library(names, dates, scores, user_scores, library)
    (0...names.size).each do |i|
      print '.'
      game = Game.new(names[i].strip,
                      dates[i].strip,
                      scores[i].strip,
                      user_scores[i].strip)

      next if library.games.include? game

      summary = parse_summary(names[i].strip)
      game.summary = summary.nil? ? nil : summary[0]
      library.games.push(game)
    end
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
