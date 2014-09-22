# CitySDK Linker

## Usage

Uses machine learning to find links between two CitySDK datasets.

Uses PostgreSQL/PostGIS database, configuration in `config.json`. Run:

    CREATE EXTENSION postgis;
    CREATE EXTENSION hstore;

## OpenStreetMap

    wget https://s3.amazonaws.com/metro-extracts.mapzen.com/amsterdam_netherlands.osm.pbf
    osm2pgsql --slim -j -d citysdk-linker -H localhost -l -C6000 -U postgres amsterdam_netherlands.osm.pbf

And execute the following query:

    CREATE VIEW osm_objects AS
      SELECT osm_id, tags, way FROM planet_osm_line
      UNION ALL
      SELECT osm_id, tags, way FROM planet_osm_polygon
      UNION ALL
      SELECT osm_id, tags, way FROM planet_osm_point;

## Data files

- `ns.json` - source: [NS API](http://www.ns.nl/api/home)
- `parking.json`
- `schools.json` - source: [schoolcijferlijst.nl](http://www.schoolcijferlijst.nl/)

You can use the different data files by setting the file in the location hash:

- [http://localhost:9292/#ns](http://localhost:9292/#ns)
- [http://localhost:9292/#parking](http://localhost:9292/#parking)
- [http://localhost:9292/#schools](http://localhost:9292/#schools)
