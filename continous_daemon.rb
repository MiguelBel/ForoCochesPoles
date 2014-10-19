require 'daemons'
require "pp"
require "curb"
require "nokogiri"

require_relative 'lib/forocoches_api/url_constructor'
require_relative 'lib/forocoches_api/thread_petitions'
require_relative 'lib/forocoches_tracker/database'
require_relative 'lib/forocoches_tracker/tracker'

Process.daemon(true)

loop do
  pid = Process.fork do
    last_id = Poles.last.id_thread

    # ((last_id + 1)..(last_id + 11)).each_with_index do |thread_id, index|
    #   thread = FCThread.new(thread_id)
    #   tracker = Tracker.new
    #   if thread.status == 2
    #     break
    #   else
    #     tracker.insertInDatabase(thread)
    #   end
    # end

    adapter = DataMapper.repository(:default).adapter
    select = adapter.select("SELECT * FROM poles WHERE category = 'General' AND status = 'no_pole_yet' AND poleman IS NULL AND time > (#{Time.now.to_i - 30 * 60}) ORDER BY time ASC LIMIT 20;")
    select.each do |previous_thread|
      thread = FCThread.new(previous_thread.id_thread)
      if thread.poleman
        adapter.execute("UPDATE poles SET status='', poleman='#{thread.poleman}', pole_time='#{thread.pole_time}', op_time='#{thread.op_time}' WHERE id_thread = #{previous_thread.id_thread}")
      end
    end
  end

  Process.waitpid(pid)

  # Reduce CPU usage
  sleep(5)
end
