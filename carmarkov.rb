require 'marky_markov'
require 'json'
require 'twitter'


# read settings
file = File.read('carmarkov.cfg')
data = JSON.parse(file)

CONSUMER_KEY = data["consumer_key"]
CONSUMER_SECRET = data["consumer_secret"]
ACCESS_TOKEN = data["access_token"]
ACCESS_SECRET = data["access_secret"]
LOG_DIRECTORY = data["log_directory"]

# compile regex for chat and things to remove
# \[CHAT\] \[(GLOBAL|LOCAL|RADIO|[0-9\.]*)\] \[[a-zA-Z0-9\(\)\[\]\._$=@]*\]: ([a-zA-Z0-9 !"#$%&'()*+,\-./:;<=>?@[\\\]^_`|~]*)
chat = Regexp.new(/\[CHAT\] \[(GLOBAL|LOCAL|RADIO|[0-9\.]*)\] \[[a-zA-Z0-9\(\)\[\]\._$=@]*\]: ([a-zA-Z0-9 !\"#$%&\'()*+,\-.\/:;<=>?@^_`|~]*)/)
tags = Regexp.new(/([A-Z]*:)/)

# open dict
markov = MarkyMarkov::Dictionary.new('logdict')

if ARGV.length == 0

	puts "Params: build, tweet, <number of sentences to print>"

elsif ARGV[0] == "build"

	Dir.foreach(LOG_DIRECTORY) do |item|

		next if item == '.' or item == '..'

		puts "Parsing file " + item + "..."
		File.foreach(File.join(LOG_DIRECTORY, item), "r:utf-8") do |line|

			if line.length > 2
				final_string = line.gsub(tags, "")
				# puts final_string
				if final_string.split.size > 1
					markov.parse_string final_string
				end
			end

		end

		puts "Parsing complete!"

	end
	markov.save_dictionary!

elsif ARGV[0] == "tweet"

	s = markov.generate_1_sentence
	puts s

	puts "post?"
	answer = STDIN.gets.chomp

	if answer == "y"
		puts "Posting to twitter!"
		client = Twitter::REST::Client.new do |config|
			config.consumer_key        = CONSUMER_KEY
			config.consumer_secret     = CONSUMER_SECRET
			config.access_token        = ACCESS_TOKEN
			config.access_token_secret = ACCESS_SECRET
		end

		begin
			client.update(s)
		rescue => error
			puts error.message
		end
	end

elsif ARGV[0].match(/[0-9]*/)

	puts markov.generate_n_sentences(ARGV[0].to_i)

end
