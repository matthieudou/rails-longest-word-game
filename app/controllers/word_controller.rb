class WordController < ApplicationController

  def game
    @grid = generate_grid(9)
  end

  def score
    time_spend = Time.now.to_i - params.fetch(:start_time).to_i
    @grid = params.fetch(:grid).split("")
    attempt = params.fetch(:query)
    @game_results = run_game(attempt, @grid, time_spend)
    @translation = translation(attempt)
  end

  # here begins the private part of the class
  private

  def generate_grid(grid_size)
    return [*('A'..'Z'), *('A'..'Z'), *('A'..'Z')].sample(grid_size)
  end

  def run_game(attempt, grid, time_spend)
    return_hash = { time: time_spend, message: "not an english word", score: 0, translation: nil, attempt: attempt }

    if attempt != ""
      translation = translation(attempt)
      if valid?(attempt, grid, translation)
        return_hash[:translation] = translation
        return_hash[:message] = "well done"
        return_hash[:score] = attempt.length*100 / return_hash[:time]
      end
    end
    return_hash[:message] = "not in the grid" unless word_match?(attempt, grid)
    return_hash
  end

  def translation(attempt)
    url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=32f671f8-e61c-4886-997e-115108d83a38&input=#{attempt}"
    user_serialized = open(url).read
    translation = JSON.parse(user_serialized)["outputs"][0]["output"]
  end

  def valid?(attempt, grid, translation)
    word_match?(attempt, grid) && attempt != translation && attempt != ""
  end

  def word_match?(attempt, grid)
    attempt.each_char { |x| return false if attempt.count(x) > grid.join.count(x.upcase) }
    true
  end
end
