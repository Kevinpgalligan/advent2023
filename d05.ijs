NB. Day 5: If You Give A Seed A Fertilizer

in =: fread 'input05'

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
intervalLength =: -~/
emptyInterval =: (0: = intervalLength)
intervalStart =: {.
intervalEnd =: {:
intersects =: dyad define
  ((intervalStart x) < (intervalEnd y)) * ((intervalStart y) < (intervalEnd x))
)
intervalIntersection =: dyad define
  if. -. x intersects y do.
    0 0 NB. empty interval
  else.
    ((intervalStart x) >. (intervalStart y)) , ((intervalEnd x) <. (intervalEnd y))
  end.
)
intervalContains =: dyad define
  ((intervalStart x) <: intervalStart y) * ((intervalEnd y) <: intervalEnd x)
)
intervalCompletelyContains =: dyad define
  ((intervalStart x) < intervalStart y) * ((intervalEnd y) < intervalEnd x)
)
intervalComplement =: dyad define
  if. x intervalCompletelyContains y do.
    _2 ,\ (intervalStart x),(intervalStart y),(intervalEnd y),(intervalEnd x)
  elseif. y intervalContains x do.
    0 0 $ 0
  elseif. (x intersects y) * (intervalStart x) < intervalStart y do.
    ,: (intervalStart x) , intervalStart y
  elseif. x intersects y do.
    ,: (intervalEnd y) , intervalEnd x
  else.
    ,: x
  end.
)

mapSrcInterval =: monad define
  (1 { y) , (({: y) + 1 { y)
)
mapOffset =: {. - 1&{
applyMap =: dyad define
  NB. Takes an intersecting interval (start,end) and
  NB. map (destStart,srcStart,length), and returns
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

NB. This was painful and I'm sure I could've done it an easier way.
part2 =: monad define
  sections =. (LF , LF) splitstring y
  NB. This time, represent seeds as a collection of intervals
  NB. rather than individual numbers.
  intervals =. ({. , +/)"(1) _2 ,\ ". ':' takeafter > {. sections
  parseMap =. {{ ". ;._1 LF , (}.~ >:@(i.&LF)) y }}
  maps =. parseMap each }. sections

  NB. Does a fold over the array of "maps".
  NB. Each set of maps is contained in a box, since the sets contain
  NB. different numbers of ranges. E.g. the seed-to-soil and soil-to-fertilizer
  NB. maps in the sample have 2 and 3 ranges, respectively.
  NB. The input to each step of the fold is: a set of maps, and the current
  NB. intervals. The output is the new intervals, after applying the maps to
  NB. the old intervals.
  finalIntervals =. intervals ]F.. {{ ; remapInterval&(>x) each <"1 y }} maps
  NB. Finally, filter out the empty intervals (not sure how they snuck in there, I
  NB. think it's a bug in the interval code?) and find the minimum.
  <./ , (#~ (-.@emptyInterval"1)) finalIntervals
)
