require 'date'

# Game class used by Library
class Game
  include Comparable
  attr_accessor :name, :date, :score, :user_score, :summary

  def initialize(name, date = nil, score = nil, user_score = nil, summary = nil)
    @name = name
    @date = assign_date(date)
    @score = score == 'tbd' || score.nil? ? 0 : score.to_i
    @user_score = user_score == 'tbd' || user_score.nil? ? 0 : user_score.to_i
    @summary = summary.nil? ? 'None available.' : summary
  end

  def <=>(other)
    other.date <=> date
  end

  def ==(other)
    name == other.name
  end

  def to_s
    info = "Release Date: #{date}, [ Score: #{score}, User Score: #{user_score} ]"
    "#{name} => #{info}\n\t\tSummary: #{summary}"
  end

  private

  def assign_date(date)
    return date if date == 'tbd'

    new_date = DateTime.parse(date).to_date
    new_date.strftime('%-m/%-d')
  end
end