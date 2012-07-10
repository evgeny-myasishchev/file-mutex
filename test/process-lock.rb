require File.expand_path('../../lib/file_mutex', __FILE__)

FileMutex::locks_dir = File.expand_path('../../tmp', __FILE__)

puts "Acquiring shared lock: test"
mutex = FileMutex::acquire "test"

puts "Shared lock acquired. Press ENTER to release."
gets

mutex.release
puts "Mutex released. Press ENTER to exit."
gets

puts "Process exit."
