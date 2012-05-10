=begin

Utilities used for processing text.
Copyright 2012 Francis Tseng

=end

require "rubygems"
require "sanitize"
require "fast_stemmer"

# load stop words
def load_stopwords
	stopwords = Array.new
	File.open("stopwords.txt","r").each_line { |line| stopwords << line.tr("\n","") }
	stopwords_re = Regexp.new(stopwords.join('|'))
end

# sanitizes, downcases, then removes stopwords, punctuation other than dashes, and numbers
def scrub(text,stopwords_re)
	Sanitize.clean(text.force_encoding("UTF-8")).downcase.gsub!(/(&gt;)|(&lt;)|('s)|('')|[%|.|=|{|}|!|;|#|&|@|\/|:|(|)|"|,|?|\[|\]]/i," ").gsub!(/(?<=\s|,|:|;)(#{stopwords_re})(?=\s|,|:|;)|(?<=\s)['|-]|['|-](?=\s)|[0-9*]/i,"")	
		# there HAS to be a more elegant way to implement this regex...
end

# create words array: splits the text, removes blank entries, then stems each word
def wordify(text,stopwords_re)
	words = scrub(text,stopwords_re).split(/[^\S](?<!['\-])/)
	words.reject! { |word| word.size > 40 }
	words.reject!(&:empty?)
	words.map! { |word| word.stem }
end

#create term frequency hash
def freqify(words)
	freqs = Hash.new
	words.each do |word|
		freqs[word] = freqs[word]*words.length unless freqs[word].nil?
		freqs[word].nil? ? freqs[word] = 1.0 : freqs[word] += 1.0
		freqs[word] = freqs[word]/words.length
	end
	return freqs
end
