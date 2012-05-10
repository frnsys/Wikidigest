Wikidigest is a Wikipedia dump digester, built in Ruby and Activerecord, mainly relying on the [Ox parser gem](https://github.com/ohler55/ox/). Wikidigest takes Wikipedia dumps and converts them into a graph structure. It's still very much a work-in-progress.

wiki\_digest.rb will process the pages articles Wikipedia dump (in XML format) using the Ox SAX parser. Each article is "scrubbed" ([sanitized](https://github.com/rgrove/sanitize) & [Porter stemmed](https://github.com/romanbsd/fast-stemmer)), then [TF\*IDF](http://en.wikipedia.org/wiki/Tf*idf) is performed, and the articles are written to the database as descriptive word vectors, which describe the stemmed words of an article and their TF\*IDF weights. These word vectors are the nodes of the graph. The text processing functions are defined in /require/textutils.rb

page\_digest.rb will process page information from the Wikipedia pages dump (in SQL format) in order to remove unnecessary entries (basically, pages that aren't in the articles or category namespaces). This will reduce the size of the page dump, making it quicker to process. Using this in conjunction with pagelink\_digest.rb is one way of generating the edges.

The other way is to have pagelinks directly extracted from the pages articles dump (though, in its current state, it's not 100% reliable). I believe this way should end up being faster than the former method; the former method involves processing other dumps which are each also very large. Getting as much information from a single dump makes the process much more efficient.

One of the biggest hurdles of the current implementation is its speed. It is *extremely* slow. There appear to be four main reasons for this:
* Everything's written in Ruby. There would probably be significant performance gains if this was written in a faster language.
* The current database is an SQL database (mySQL). These sort of graph representations benefit more from noSQL databases; something like [Neo4j](neo4j.rubyforge.org) might be more appropriate and faster.
* There's a lot of (text) processing going on. This would also benefit from a faster language, or perhaps there are more efficient means for such processing. Maybe pre-filtering what would get processed (more comprehensive lists of stopwords, for example) could help.
* Wikipedia dumps are *huge*. The pages articles dump at the time of this project was 36.05GB. The latest page dump was 2.35GB. The sheer amount of data to be processed inevitably makes the process somewhat slow. Despite this, with the above suggested improvements, Wikidigest should be able to reach a speed that is at least tolerably slow.  

At some point I may rename the project, because "dump digester" sounds really unappealing...
