require 'fileutils'

#File based implementation of named mutexes in ruby.
#Used for inter process synchronizaion withing the same local environment.
#To start using it locks_dir should be set to some folder. 
#Same folder should be set for each process in order to use same named mutex
class FileMutex
  def initialize(name)
    @name = name
    @lock_file_path = File.join(self.class.locks_dir, "#{name}.lock")
  end
  
  #Acuires ownership on the mutext. Blocks untill the ownership obtained.
  def acquire
    @lock_file = File.open(@lock_file_path, File::RDWR|File::CREAT, 0644)
    @lock_file.flock(File::LOCK_EX)
    self
  end
  
  #Releases ownership on the mutex so anyone else can acuire it.
  def release
    @lock_file.flock(File::LOCK_UN)
    @lock_file.close
    @lock_file = nil
  end
  
  private
  
  class << self
    def acquire(name)
      new(name).acquire
    end
    
    def locks_dir
      @@locks_dir || begin
        raise "Locks dir has not been initialized."
      end
    end
    
    def locks_dir=(value)
      FileUtils.mkpath value
      @@locks_dir = value
    end
  end
end