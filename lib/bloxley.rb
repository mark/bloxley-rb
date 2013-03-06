module Bloxley; end

Dir['lib/**/*.rb'].each do |file|
  require_relative "../#{file}"
end