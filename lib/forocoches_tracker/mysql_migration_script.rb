require "mysql2"

require_relative "database.rb"

client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "12345678", :database => "forocoches_poles")

last_thread_inserted = Poles.last(:fields => [:id_thread]).id_thread
last_thread_inserted = 0 if last_thread_inserted.nil?

client.query("SELECT * FROM poles WHERE id_thread > #{last_thread_inserted} LIMIT 1000000").each do |row|
  pp row[:id_thread] if row["id"] % 10000 == 0
  Poles.create({:id => row["id"], :id_thread => row["id_thread"], :poleman => row["poleman"], :category => row["category"], :time => row["time"]})
end
