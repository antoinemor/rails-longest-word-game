require 'json'
require 'open-uri'

class WordGridsController < ApplicationController
  def game
    @grid = generate_grid(9)
    @start_time = Time.now
  end

  def score
    @result = run_game(params[:guess], params[:grid].split(''), params[:start_time].to_i, Time.now.to_i)
    # session[:played_games] += 1
    # session[:score] << @result[:score]
  end

  private

  WORDS = File.read('/usr/share/dict/words').upcase.split("\n")
  KEY = "605d1d65-a3c4-43ab-99d7-60441c36a4e1"

  def generate_grid(grid_size)
    grid = []
    grid_size.times { grid << ("A".."Z").to_a.sample }
    return grid
  end

  def in_the_grid?(word, grid)
    result = true
    word_arr = word.upcase.split('')
    until word_arr.length.zero? || result == false
      if grid.include? word_arr.first
        grid.delete_at(grid.index(word_arr.first))
        word_arr.shift
      else
        result = false
      end
    end
    return result
  end

  def english_word?(word)
    WORDS.include? word.upcase
  end

  def translation(word)
    url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=" + KEY + "&input=" + word
    serialized_json = open(url).read
    json = JSON.parse(serialized_json)
    translated = json["outputs"][0]["output"]
    english_word?(word) ? translated : nil
  end

  def run_game(attempt, grid, start_time, end_time)
    result = { time: end_time - start_time, score: 0, translation: translation(attempt) }
    if english_word?(attempt) == false
      result[:message] = "not an english word"
    elsif in_the_grid?(attempt, grid) == false
      result[:message] = "not in the grid"
    else
      result[:message] = 'well done'
      result[:score] = ((100 / result[:time]) + (attempt.length * 100)).round
    end
    return result
  end
end

