require_relative 'benchmark_helper.rb'

initial_thread = 3_000_000
number_of_threads = 100

Benchmark.bm do |unit|
  unit.report("From #{initial_thread} to #{initial_thread + number_of_threads} (#{number_of_threads} threads)") {
    polemans = []

      hydra = Typhoeus::Hydra.new      
    (initial_thread..(initial_thread + number_of_threads)).each do |thread_number|

      requests = 100.times.map { 
        request = Typhoeus::Request.new("http://www.forocoches.com/foro/showthread.php?t=3938358", followlocation: true)
        hydra.queue(request) 
        request
      }
      hydra.run

      responses = requests.map { |request|
        request.response.body
      }
    end
  }
end