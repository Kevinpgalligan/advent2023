NB. Day 6: Wait For It
NB. https://adventofcode.com/2023/day/6

in =: fread 'input06'
sample =: 0 : 0
Time:      7  15   30
Distance:  9  40  200
)

dropBeforeComma =: }.~ (>: @: (i.&':'))

NB. Part 1.
part1 =: {{
  lines =. LF splitstring y
  times =. ". dropBeforeComma > 0 { lines
  dists =. ". dropBeforeComma > 1 { lines
  */ dists {{ +/ x < (* (y&-)) i. y }}"0 0 times
}}

NB. Part 2
part2 =: {{
  lines =. LF splitstring y
  getNum =. {{ ". '' joinstring ' ' splitstring dropBeforeComma y }}
  time =. getNum > 0 { lines
  dist =. getNum > 1 { lines
  +/ dist {{ x < (* (y&-)) i. y }} time
}}



