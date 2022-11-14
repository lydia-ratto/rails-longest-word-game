require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    attempt = params[:word].upcase
    # grid = @letters.join(' ')
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_attempt = URI.open(url).read
    response = JSON.parse(word_attempt)
    word = attempt.chars
    letters_group = params[:letters]
    letters = params[:letters].split(" ")
    english_word = response['found'] == true

    included_word = word.all? { |letter| word.count(letter) <= letters.count(letter) } &&
    word.all? { |letter| letters.include?(letter) }

    if included_word == false
      @message = "Sorry but #{attempt} can't be built out of #{letters_group}"
    elsif english_word == false
      @message = "Sorry but #{attempt} is not an English word"
    else
      @message = "Congratulations? #{attempt} is a valid English word!"
    end
  end
end
