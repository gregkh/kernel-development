#!/usr/bin/env ruby
#
# Minimal Gruff example, kept as a starting point for new graphs and as a
# quick way to confirm that a Gruff/ImageMagick install works.
#
# It is not part of any slide deck - the output is a scratch file, and is
# listed in .gitignore.  The real graphs live in graphs/patches_per_release/.
#
# Usage:
#	./graph.ruby [output.png]
#
# Prerequisites:
#	gem install gruff	# pulls in rmagick, which needs ImageMagick headers

require 'rubygems'
require 'gruff'

g = Gruff::Line.new
g.title = "My Graph"

g.data("Apples", [1, 2, 3, 4, 4, 3])
g.data("Oranges", [4, 8, 7, 9, 8, 9])
g.data("Watermelon", [2, 3, 1, 5, 6, 8])
g.data("Peaches", [9, 9, 10, 8, 7, 9])

g.labels = {0 => '2003', 2 => '2004', 4 => '2005'}

# Write next to this script rather than into whatever directory the script was
# started from, so running it from the top of the repo does not drop stray
# files in the tree.
output = ARGV[0] || File.expand_path('my_fruity_graph.png', __dir__)
g.write(output)
puts "wrote #{output}"
