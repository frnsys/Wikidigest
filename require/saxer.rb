class Saxer < ::Ox::Sax

	# Notes: You MUST set the words table, name column to unique:
	# mysql>  alter table words add unique (name);

	def initialize
		@count = 0
		@stopwords_re = load_stopwords
		@page_id = []
		@start_time = Time.now
	end

	def start_element(name)
		@name = name.to_s
	end
	
	def text(value)
		@value = value.to_s.force_encoding("UTF-8") # UTF-8 encoding is forced to allow saving to database
		case @name
		when "title"
			@title = @value
		when "id"
			@page_id << @value.to_i
		when "text"
			@text = @value
		end
	end

	def end_element(name)
		if name.to_s == "page"
			# Grab a text sample
			if @text.split(/\S+/).size > 200

				@node = Node.create(:title => @title, :page_id => @page_id[0])

				@pagelinks = extract_pagelinks(@text)
				puts @pagelinks
				@text = wordify(@text, @stopwords_re)
				Word.transaction do
					freqify(@text).each do |key,value|
						fixed_key = key.gsub(/'/,"\\\\'")
						@word_id = Word.connection.insert_sql "INSERT INTO words (name, created_at, updated_at) VALUES ('#{fixed_key}',NOW(),NOW()) ON DUPLICATE KEY UPDATE name=name"
						if @word_id == 0
							@word = Word.connection.select_all "SELECT * FROM words WHERE name='#{fixed_key}'"
							@word_id = @word[0]['id']
						end
						WordLink.connection.execute "INSERT INTO word_links (node_id, word_id, weight, created_at, updated_at) VALUES (#{@page_id[0]},#{@word_id},#{value},NOW(),NOW())"
					end
				end

				# output some test files:
				# File.new("tests/sample_article"+@count.to_s+"_"+@title+".txt", "w").write(@text)
			end

			@page_id.clear

			if @count > 50
				print_profiler_results
				exit
			end

			@count += 1
			puts @count

			puts elapsed_time(@start_time, Time.now).to_s+"seconds"  if @count%100 == 0

		end
	end

	private

	def elapsed_time(start, finish)
		((finish - start)).to_i
	end

end

