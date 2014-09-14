require_relative 'benchmark_helper.rb'

initial_thread = 3_000_000
number_of_threads = 100

Benchmark.bm do |unit|
  unit.report("From #{initial_thread} to #{initial_thread + number_of_threads} (#{number_of_threads} threads)") {
    polemans = []
    (initial_thread..(initial_thread + number_of_threads)).each do |thread_number|
      thread = FCThread.new(thread_number)
      polemans.push(thread.poleman)
    end
  }
end

=begin

  Output:

                        user     system      total        real
      From 3000000 to 3000100 (100 threads)  2.980000   0.160000   3.140000 ( 24.561139)

      100 / 24.56 => like 4 per second
=end