require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @alphabet =
      grid = []
      10.times do
        grid << ('A'..'Z').to_a.sample(1)
      end
      grid
    @letters = @alphabet.flatten
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    word_array = @word.upcase.split('')
    @grid_match = word_array.all? do |letter|
      @grid.include?(letter)
    end
    def real_word?
      url = "https://wagon-dictionary.herokuapp.com/#{@word}"
      serialized = URI.open(url).read
      check = JSON.parse(serialized)
      check['found']
    end
    @real_word = real_word?
    def results
      if @real_word && @grid_match
        "Well done! #{@word} is a valid english word! You scored #{@word.length} points."
      elsif @grid_match == false
        "Sorry, but #{@word} can\'t be built out of #{@grid}"
      elsif @real_word == false
        "That doesn't appear to be a word in the dictionary"
      end
    end
    @results = results
    def total_score
      if session['score']
        session['score'] += @word.length
      # else
      #   session['score'] = 0
      end
    end
    @total_score = total_score
  end

end
