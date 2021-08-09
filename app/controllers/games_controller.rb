require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word].upcase
    @word_array = @word.split('')
    @letters = params[:letters].split(' ')
    # verification de l'appartenance des lettres a la grille
    @word_array.each do |el|
      if @letters.include?(el)
        @letters.delete_at(@letters.index(el))
      else
        @message = "Sorry but #{params[:word]} can't be built out of #{params[:letters]}"
        break
      end
    end

    if @message.nil?
      url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
      @api_word = JSON.parse(URI.open(url).read)
      @result = @api_word['found']
      if @result
        @message = "Congratulations! #{params[:word]} is a valid english word!"
      else
        @message = "Sorry but #{params[:word]} does not seem to be an english word"
      end
    end

  end
end
