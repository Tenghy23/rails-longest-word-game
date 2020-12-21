require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    charset = ('A'..'Z').to_a
    @arr = charset.sample(10)
  end

  def score
    @answer = params[:answer].downcase.split('')
    @array = params[:letters].downcase.split(' ')

    # check if letter belongs to the grids first
    @answer.each do |i|
      if @array.exclude?(i)
        @reply = "Sorry but '#{i}' can't be built out of #{@array}"
        return @reply
      end
    end

    # check against api
    response = open("https://wagon-dictionary.herokuapp.com/#{params[:answer]}")
    json = JSON.parse(response.read)
    if json['found'] == true
      @reply = "Congratulations. #{json['word']} is a valid English word!"
    elsif json['found'] == false
      @reply = "Sorry but #{json['word']} does not seem to be a valid English word..."
    end
  end
end
