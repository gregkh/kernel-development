#!/usr/bin/env ruby
#
# Generate graphs/patches_per_release/cves_fixed_per_release.png and
# cves_created_per_release.png - the "is the kernel secure" slides.
#
# Usage (see NOTES in this directory):
#	bundle install
#	bundle exec ruby cves_per_release.rb
#
# Data source: the numbers hard-coded below, one value per kernel release.
# The outputs are written next to this script, so it can be run from anywhere.

require 'gruff'
g = Gruff::Line.new(2048)
g.title = 'CVE fixes per release'

g.labels = {
  0 => '6.9',
  1 => '6.10',
  2 => '6.11',
  3 => '6.12',
  4 => '6.13',
  5 => '6.14',
  6 => '6.15',
  7 => '6.16',
  8 => '6.17',
  9 => '6.18',
  10 => '6.19',
  11 => '7.0',
  12 => '7.1',
  13 => '7.2',
  14 => '7.3-rc',
}

g.theme = Gruff::Themes::PASTEL

g.hide_legend = true
g.title_font = 'Bitter-Regular'
#g.font = 'Bitter'

g.y_axis_increment = 500
g.baseline_value = 0
g.baseline_color = 'white'
#g.hide_dots = true
#g.show_vertical_markers = true
#g.hide_lines = true

g.data(' ', [
        538,
        525,
        484,
        620,
        549,
        425,
        506,
        475,
        484,
        491,
        545,
        1247,
        1303,
        2105,
        1422],
	'#72AE6E') # green

g.write(File.expand_path('cves_fixed_per_release.png', __dir__))

g = Gruff::Line.new(2048)
g.title = 'CVEs created per release'

g.labels = {
  0 => '5.4',
  1 => '5.5',
  2 => '5.6',
  3 => '5.7',
  4 => '5.8',
  5 => '5.9',
  6 => '5.10',
  7 => '5.11',
  8 => '5.12',
  9 => '5.13',
  10 => '5.14',
  11 => '5.15',
  12 => '5.16',
  13 => '5.17',
  14 => '5.18',
  15 => '5.19',
  16 => '6.0',
  17 => '6.1',
  18 => '6.2',
  19 => '6.3',
  20 => '6.4',
  21 => '6.5',
  22 => '6.6',
  23 => '6.7',
  24 => '6.8',
  25 => '6.9',
  26 => '6.10',
  27 => '6.11',
  28 => '6.12',
  29 => '6.13',
  30 => '6.14',
  31 => '6.15',
  32 => '6.16',
  33 => '6.17',
  34 => '6.18',
  35 => '6.19',
  36 => '7.0',
  37 => '7.1',
  38 => '7.2',
}

g.theme = Gruff::Themes::PASTEL

g.hide_legend = true
g.title_font = 'Bitter-Regular'
#g.font = 'Bitter'

g.y_axis_increment = 100
g.baseline_value = 0
g.baseline_color = 'white'
#g.hide_dots = true
#g.show_vertical_markers = true
#g.hide_lines = true

g.data(' ', [
  176,  # 5.4
  190,  # 5.5
  213,  # 5.6
  222,  # 5.7
  196,  # 5.8
  177,  # 5.9
  262,  # 5.10
  218,  # 5.11
  217,  # 5.12
  287,  # 5.13
  302,  # 5.14
  475,  # 5.15
  236,  # 5.16
  258,  # 5.17
  267,  # 5.18
  304,  # 5.19
  313,  # 6.0
  197,  # 6.1
  253,  # 6.2
  231,  # 6.3
  267,  # 6.4
  216,  # 6.5
  250,  # 6.6
  308,  # 6.7
  367,  # 6.8
  260,  # 6.9
  275,  # 6.10
  285,  # 6.11
  273,  # 6.12
  239,  # 6.13
  247,  # 6.14
  282,  # 6.15
  255,  # 6.16
  178,  # 6.17
  240,  # 6.18
  227,  # 6.19
  139,  # 7.0
  134,  # 7.1
  17],  # 7.2
  '#72AE6E') # green

g.write(File.expand_path('cves_created_per_release.png', __dir__))

#Linux 6.0:	304
#Linux 6.1:	194
#Linux 6.2:	248
#Linux 6.3:	226
#Linux 6.4:	261
#Linux 6.5:	211
#Linux 6.6:	242
#Linux 6.7:	293
#Linux 6.8:	366
#Linux 6.9:	252
#Linux 6.10:	265
#Linux 6.11:	276
#Linux 6.12:	264
#Linux 6.13:	230
#Linux 6.14:	221
#Linux 6.15:	266
#Linux 6.16:	243
#Linux 6.17:	166
#Linux 6.18:	213
#Linux 6.19:	214
#Linux 7.0:	125
#Linux 7.1:	115
#Linux 7.2:	7
