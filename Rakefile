task :default => [:test]

desc "Run test suite"
task :test do |t|
  require_relative 'test/test_helper'
  
  if ENV["TEST"]
    require_relative ENV["TEST"]
  else
    Dir['test/**/*_test.rb'].each do |file|
      require_relative file
    end
  end
end

