# encoding: utf-8

require 'sinatra'
require 'json'

class CitySDK_Linker < Sinatra::Base
  config = JSON.parse(File.read('./config.json'), symbolize_names: true)

  before do
    content_type 'text/html; charset=utf-8'
  end

  get '/' do
    File.read(File.join('public', 'index.html'))
  end

  get '/data/1' do
    "Geef alle GeoJSON-data uit de eerste dataset terug!"
  end

  get '/data/2' do
    id = params["id"]
    "Geef alle relevante data uit de tweede dataset terug, gerelateerd aan object #{id} uit dataset 1!"
  end

end
