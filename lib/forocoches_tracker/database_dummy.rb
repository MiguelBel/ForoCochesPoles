require "pg"
require "data_mapper"

DataMapper.setup(:default, 'postgres://alice:password@localhost/forocoches_poles')

class Poles
  include DataMapper::Resource

  property :id, Serial
  property :id_thread, Integer, :unique => true
  property :poleman, String
  property :category, String
  property :op_time, String
  property :pole_time, String
  property :time, Integer
  property :status, String # ["deleted", "censored", "no_pole_yet"]
end

DataMapper.finalize
DataMapper.auto_upgrade!