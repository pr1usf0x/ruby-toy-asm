require_relative "isa.rb"

DEFAULT_OUTPUT_FILENAME = "a.out".freeze

def prog(&block)
  block.call
end

begin

$pc_ = 0
$program = []
input = ARGV[0]

if not ARGV[1]
  OUTPUT_NAME = "a.out"
else
  OUTPUT_NAME = ARGV[1]
end

prog do
  load input
end

File.open(OUTPUT_NAME, "wb")
File.binwrite(OUTPUT_NAME, $program.pack("V*"))

rescue => e
  puts e.message
end
