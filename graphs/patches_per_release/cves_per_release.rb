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
}

g.theme = Gruff::Themes::PASTEL

g.hide_legend = true
g.title_font = 'Bitter-Bold'
#g.font = 'Bitter'

g.y_axis_increment = 500
g.baseline_value = 0
g.baseline_color = 'white'
#g.hide_dots = true
#g.show_vertical_markers = true
#g.hide_lines = true

g.data(' ', [
  538,  # 6.9
  525,  # 6.10
  484,  # 6.11
  620,  # 6.12
  549,  # 6.13
  425,  # 6.14
  506,  # 6.15
  475,  # 6.16
  484,  # 6.17
  491,  # 6.18
  545,  # 6.19
  1247, # 7.0
  1306, # 7.1
  2299], # 7.2
  '#72AE6E') # green

g.write('cves_fixed_per_release.png')

g = Gruff::Line.new(2048)
g.title = 'CVE fixes per release (with -rc)'

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
  14 => '7.3-rc6',
}

g.theme = Gruff::Themes::PASTEL

g.hide_legend = true
g.title_font = 'Bitter-Bold'
#g.font = 'Bitter'

g.y_axis_increment = 500
g.baseline_value = 0
g.baseline_color = 'white'
#g.hide_dots = true
#g.show_vertical_markers = true
#g.hide_lines = true

g.data(' ', [
  538,  # 6.9
  525,  # 6.10
  484,  # 6.11
  620,  # 6.12
  549,  # 6.13
  425,  # 6.14
  506,  # 6.15
  475,  # 6.16
  484,  # 6.17
  491,  # 6.18
  545,  # 6.19
  1247, # 7.0
  1306, # 7.1
  2299, # 7.2
  2738],  # 7.3-rc6
  '#72AE6E') # green
g.write('cves_fixed_per_release-rc.png')

g = Gruff::Line.new(2048)
g.title = 'CVEs created per release'

g.labels = {
#  0 => '5.4',
  1 => '5.5',
#  2 => '5.6',
#  3 => '5.7',
#  4 => '5.8',
#  5 => '5.9',
  6 => '5.10',
#  7 => '5.11',
#  8 => '5.12',
#  9 => '5.13',
#  10 => '5.14',
  11 => '5.15',
#  12 => '5.16',
#  13 => '5.17',
#  14 => '5.18',
#  15 => '5.19',
  16 => '6.0',
#  17 => '6.1',
#  18 => '6.2',
#  19 => '6.3',
#  20 => '6.4',
  21 => '6.5',
#  22 => '6.6',
#  23 => '6.7',
#  24 => '6.8',
#  25 => '6.9',
  26 => '6.10',
#  27 => '6.11',
#  28 => '6.12',
#  29 => '6.13',
#  30 => '6.14',
  31 => '6.15',
#  32 => '6.16',
#  33 => '6.17',
#  34 => '6.18',
#  35 => '6.19',
  36 => '7.0',
#  37 => '7.1',
#  38 => '7.2',
#  39 => '7.3',
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
  191,  # 5.4
  212,  # 5.5
  240,  # 5.6
  247,  # 5.7
  230,  # 5.8
  193,  # 5.9
  286,  # 5.10
  240,  # 5.11
  243,  # 5.12
  322,  # 5.13
  329,  # 5.14
  517,  # 5.15
  266,  # 5.16
  275,  # 5.17
  287,  # 5.18
  328,  # 5.19
  384,  # 6.0
  230,  # 6.1
  281,  # 6.2
  265,  # 6.3
  301,  # 6.4
  242,  # 6.5
  308,  # 6.6
  342,  # 6.7
  422,  # 6.8
  298,  # 6.9
  326,  # 6.10
  334,  # 6.11
  314,  # 6.12
  274,  # 6.13
  290,  # 6.14
  350,  # 6.15
  310,  # 6.16
  213,  # 6.17
  289,  # 6.18
  275,  # 6.19
  200,  # 7.0
  218,  # 7.1
   74,  # 7.2
    6], # 7.3
  '#72AE6E') # green

g.write('cves_created_per_release.png')

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
