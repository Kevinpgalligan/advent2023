NB. Day 5: If You Give A Seed A Fertilizer

in =: fread 'input05'

0 : 0
DEBUGGING.

TODO - figure out why '0 0' is in the output after 3 remappings.

Manually stepping through part 2....

79 92
55 67

vvvvv

77 90
53 65

vvvvv

77 90
54 65
14 14

vvvvv

77 90
61 65
58 60
7 10
25 25


Actual output:
77 90
61 65
58 60
 7 10
 0  0
25 25
)

sample =: 0 : 0
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
)

NB. Part 1.
inMapSrc =: {{ ((1 { y) <: x) * (x <: (+/ }. y) ) }}
mapToNext =: dyad define
  m =. x (inMapSrc"0 1) y
  if. +./m do. (((x&-)@(1&{)) + {.) , m # y else. x end.
)
part1 =: monad define
  sections =. (LF , LF) splitstring y
  seeds =. ". (}.~ >:@(i.&':')) > {. sections
  parseMap =. {{ ". ;._1 LF , (}.~ >:@(i.&LF)) y }}
  maps =. parseMap each }. sections
  <./ seeds ]F.. {{ y (mapToNext"0 _) >x }} maps
)

NB. Part 2.
intervalStart =: {.
intervalEnd =: {:
intersects =: dyad define
  ((intervalStart x) <: (intervalEnd y)) * ((intervalStart y) <: (intervalEnd x))
)
intervalIntersection =: dyad define
  ((intervalStart x) >. (intervalStart y)) , ((intervalEnd x) <. (intervalEnd y))
)
intervalContains =: dyad define
  ((intervalStart x) <: intervalStart y) * ((intervalEnd y) <: intervalEnd x)
)
intervalCompletelyContains =: dyad define
  ((intervalStart x) < intervalStart y) * ((intervalEnd y) < intervalEnd x)
)
intervalComplement =: dyad define
  if. x intervalCompletelyContains y do.
    _2 ,\ (intervalStart x),(<: intervalStart y),(>: intervalEnd y),(intervalEnd x)
  elseif. y intervalContains x do.
    0 0 $ 0
  elseif. (x intersects y) * (intervalStart x) < intervalStart y do.
    ,: (intervalStart x) , <: intervalStart y
  elseif. x intersects y do.
    ,: (>: intervalEnd y) , intervalEnd x
  else.
    ,: x
  end.
)

mapSrcInterval =: {. , <:@:({. + {:)
mapOffset =: 1&{ - {.
applyMap =: dyad define
  NB. Takes an intersecting interval (start,end) and
  NB. map (srcStart,destStart,length) that, and returns
  NB. the output from applying the map.
  (mapOffset y) + x intervalIntersection (mapSrcInterval y)
)

remapInterval =: {{
  NB. Inputs:
  NB.   x -- an interval (start & end coordinates)
  NB.   y -- a list of maps
  NB. Output: the output from applying those maps to that interval.
  srcIntervals =. mapSrcInterval"1 y
  mask =. x intersects"1 1 srcIntervals
  NB. Get the outputs of applying each map to the interval, then subtract
  NB. the intersections to get what's left.
  outputs =. x applyMap"_ 1 (mask # y)
  remaining =. (,: x) ]F.. {{ ; (intervalComplement&x) each <"1 y }} srcIntervals
  remaining , outputs
}}

part2 =: monad define
  NB. Almost the same as part 1, just with different parsing and
  NB. have to deal with intervals instead of individual seed values.
  sections =. (LF , LF) splitstring y
  intervals =. ({. , (<:@:(+/)))"(1) _2 ,\ ". (}.~ >:@:(i.&':')) > {. sections
  parseMap =. {{ ". ;._1 LF , (}.~ >:@(i.&LF)) y }}
  maps =. parseMap each }. sections
  NB. intervals ]F.. {{ ; (remapInterval&(>x)) each <"1 y }} |. maps
  m1 =. ; (remapInterval& (> {. maps)) each <"1 intervals
  m2 =. ; (remapInterval& (> 1 { maps)) each <"1 m1
  m3 =. ; (remapInterval& (> 2 { maps)) each <"1 m2
  m3
)
