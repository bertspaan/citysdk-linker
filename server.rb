# encoding: utf-8

require 'sinatra'
require 'json'

class CitySDK_Linker < Sinatra::Base
  config = JSON.parse(File.read('./config.json'), symbolize_names: true)

  DB = Sequel.connect("postgres://#{config[:db][:username]}:#{config[:db][:password]}@#{config[:db][:host]}:#{config[:db][:port]}/#{config[:db][:database]}")

  Sequel.extension :pg_hstore_ops
  DB.extension :pg_hstore

  before do
    content_type 'text/html; charset=utf-8'
  end

  get '/' do
    File.read(File.join('public', 'index.html'))
  end

  get '/data/:data' do |data|
    content_type 'application/json; charset=utf-8'
    File.read(File.join('data', "#{data}.geojson"))
  end

  get '/data/osm/:lat/:lon' do |lat, lon|
    content_type 'application/json; charset=utf-8'

    radius = 100
    features = []

    # Get all objects from view osm_objects which completely intersect with circle with radius <radius> m.
    where = "ST_Contains(ST_Transform(Geometry(ST_Buffer(Geography(ST_Transform(ST_SetSRID(ST_Point(#{lon}, #{lat}), 4326), 4326)), #{radius})), 4326), way)"
    dataset = DB[:osm_objects].select(:osm_id, :tags, Sequel.function(:ST_AsGeoJSON, :way).as(:geojson)).where(where).each do |row|
      features << {
        type: "Feature",
        id: row[:osm_id],
        properties: row[:tags].to_h,
        geometry: JSON.parse(row[:geojson])
      }
    end

    {
      type: "FeatureCollection",
      features: features
    }.to_json
  end

end
