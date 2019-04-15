class Benchmarker
  def run(&block)
    start_time = Time.now
    yield
    end_time = Time.now
    elapsed = end_time - start_time
    puts "\nElapsed time: #{elapsed} seconds"
  end
end