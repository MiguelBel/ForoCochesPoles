require_relative 'benchmark_helper.rb'

initial_thread = 3_000_000
number_of_threads = 100

Benchmark.bm do |unit|
  unit.report("From #{initial_thread} to #{initial_thread + number_of_threads} (#{number_of_threads} threads)") {
    polemans = []
    responses = {}
    requests = []
    

    (initial_thread..(initial_thread + number_of_threads)).each do |thread_number|
      requests.push(FCURL.buildThreadURL(thread_number))
    end

    m = Curl::Multi.new

    requests.each do |url|
      responses[url] = ""
      c = Curl::Easy.new(url) do|curl|
        curl.follow_location = true
        curl.on_body{|data| responses[url] << data; data.size }
      end

      m.add(c)
    end

    m.perform

    responses.each_with_index do |response, index|
      thread = FCThread.new(FCURL.retrieveIDFromURL(response[0]), response[1])
      polemans.push(thread.poleman)
    end

    p "    => #{polemans.join(', ')}"
  }
end

=begin

  Output:

=end