# Exploratory Data Analysis in R

A practical guide `dplyr`, `ggplot2`, and the tidyverse family

---

Introduce yourself

---

What and why

---

History

---

# The Pipe (`%>%`) Operator

Making many chained functions readable

<!-- .slide: data-background="https://i.pinimg.com/originals/9b/11/2a/9b112aa30bc1ba530076bf0110dc5f3a.jpg" -->

---

## Sequential Functions

When you have many sequential operations, your code can look like this:

```python
tumble_after(
    broke(
        fell_down(
            fetch(went_up(jack_jill, "hill"), "water"),
            jack),
        "crown"),
    "jill"
)
```

Order is unclear! <!-- .element: class="fragment fade-in" data-fragment-index="1" -->

```python
on_hill = went_up(jack_jill, 'hill')
with_water = fetch(on_hill, 'water')
fallen = fell_down(with_water, 'jack')
broken = broke(fallen, 'jack')
after = tmple_after(broken, 'jill')
```
<!-- .element: class="fragment fade-in" data-fragment-index="2" -->

Lots of unneeded variables! <!-- .element: class="fragment fade-in" data-fragment-index="3" -->

---

## Pipe to the Rescue

Now with the `%>%` operator

```r
jack_jill %>%
    went_up("hill") %>%
    fetch("water") %>%
    fell_down("jack") %>%
    broke("crown") %>%
    tumble_after("jill")
```

Note: Simple, correct order, readable. Even without knowing %>%

---

## How the Pipe Can Be Used

Simple stuff

- `x %>% f` ➡️ `f(x)`
- `x %>% f(y)` ➡️ `f(x,y)`
- `x %>% f %>% g` ➡️  `g(f(x))`

Multiple argument functions

- `x %>% f(y, .)` ➡️ `f(y, x)`
- `x %>% f(y, z = .)` ➡️ `f(y, z = x)`

Fancier stuff

- `f <- . %>% f %>% g` ➡️ `f <- function(x) f(g(x))`

Note: Watchout with fancy stuff, we want readable code

---

# What about Python?

In pandas we can use method-chaining

```python
(jack_jill.pipe(went_up, 'hill')
    .pipe(fetch, 'water')
    .pipe(fell_down, 'jack')
    .pipe(broke, 'crown')
    .pipe(tumble_after, 'jill')
)
```

if the functions are pd.DataFrame methods we can write<!-- .element: class="fragment fade-in" data-fragment-index="1" -->

```python
(jack_jill.went_up('hill')
    .fetch('water')
    .fell_down('jack')
    .broke('crown')
    .tumble_after('jill')
)
```
<!-- .element: class="fragment fade-in" data-fragment-index="1" -->

Note: Custom functions problematic. More "line noise"

---

# Dplyr

A grammer of data manipulation

<!-- .slide: data-background="https://makelmail.nl/wp-content/uploads/2017/05/big-data.jpg" -->

---

## Whats a Grammer?

<blockquote>
A **Grammer** is the set of structured rules governing the composition of clauses, phrases, and words in any given (natural) langauge
</blockquote>
<cite> — Wikipedia </cite>

---

## The "Verbs"

The idea behind dplyr is to have a few simple functions which can be combined to create more advanced behavior in some consistent way:

- `mutate`: Create or overwrite columns
- `select`: Subsets columns by name
- `filter`: Subsets rows by values
- `summarise`: Reduces multiple row values to single values
- `arrange`: Orders rows
- `group_by`: Groups rows by condition

Note: Mention how this is similar to SQL. While old fashioned, SQL has been the standard language for dealing with data since 1974 (44 years).

---

## Data: `nycflights13` dataset

- All flights to/from LaGuardia Airport in New York
- Only flights in 2013

Notes: To those who know this set, sorry this won't be as interesting.

---
# Loading the data

``` r
> library(dplyr)
> 
> flights <- nycflights13::flights 
> flights %>% str()

Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	336776 obs. of  19 variables:
 $ year          : int  2013 2013 2013 2013 2013 2013 2013 2013 2013 2013 ...
 $ month         : int  1 1 1 1 1 1 1 1 1 1 ...
 $ day           : int  1 1 1 1 1 1 1 1 1 1 ...
 $ dep_time      : int  517 533 542 544 554 554 555 557 557 558 ...
 $ sched_dep_time: int  515 529 540 545 600 558 600 600 600 600 ...
 $ dep_delay     : num  2 4 2 -1 -6 -4 -5 -3 -3 -2 ...
 $ arr_time      : int  830 850 923 1004 812 740 913 709 838 753 ...
 $ sched_arr_time: int  819 830 850 1022 837 728 854 723 846 745 ...
 $ arr_delay     : num  11 20 33 -18 -25 12 19 -14 -8 8 ...
 $ carrier       : chr  "UA" "UA" "AA" "B6" ...
 $ flight        : int  1545 1714 1141 725 461 1696 507 5708 79 301 ...
 $ tailnum       : chr  "N14228" "N24211" "N619AA" "N804JB" ...
 $ origin        : chr  "EWR" "LGA" "JFK" "JFK" ...
 $ dest          : chr  "IAH" "IAH" "MIA" "BQN" ...
 $ air_time      : num  227 227 160 183 116 150 158 53 140 138 ...
 $ distance      : num  1400 1416 1089 1576 762 ...
 $ hour          : num  5 5 5 5 6 5 6 6 6 6 ...
 $ minute        : num  15 29 40 45 0 58 0 0 0 0 ...
 $ time_hour     : POSIXct, format: "2013-01-01 05:00:00" "2013-01-01 05:00:00" ...

```

---

# Manipulating columns

---

# Selecting columns

``` r
> flights %>%
>     select(year, month, day, dep_time, arr_time)

# A tibble: 336,776 x 5
    year month   day dep_time arr_time
   <int> <int> <int>    <int>    <int>
 1  2013     1     1      517      830
 2  2013     1     1      533      850
 3  2013     1     1      542      923
 4  2013     1     1      544     1004
 5  2013     1     1      554      812
# ... with 336,766 more rows

```

---

# Removing columns

``` r
> flights %>%
>     select(-year, -month, -day)

# A tibble: 336,776 x 16
   dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay
      <int>          <int>     <dbl>    <int>          <int>     <dbl>
 1      517            515         2      830            819        11
 2      533            529         4      850            830        20
 3      542            540         2      923            850        33
 4      544            545        -1     1004           1022       -18
 5      554            600        -6      812            837       -25
# ... with 336,766 more rows, and 10 more variables: carrier <chr>,
#   flight <int>, tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>,
#   distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>

```

---

# Selecting and renaming

``` r
> flights %>%
>     select("departure" = dep_time)

# A tibble: 336,776 x 1
   departure
       <int>
 1       517
 2       533
 3       542
 4       544
 5       554
# ... with 336,766 more rows

```

---

# Selecting with helper functions

``` r
> flights %>%
>     select(ends_with("time"))

# A tibble: 336,776 x 5
   dep_time sched_dep_time arr_time sched_arr_time air_time
      <int>          <int>    <int>          <int>    <dbl>
 1      517            515      830            819      227
 2      533            529      850            830      227
 3      542            540      923            850      160
 4      544            545     1004           1022      183
 5      554            600      812            837      116
# ... with 336,766 more rows

```

---

# Selecting with helper functions

- `starts_with()`: starts with a prefix
- `ends_with()`: ends with a prefix
- `contains()`: contains a literal string
- `matches()`: matches a regular expression
- `num_range()`: a numerical range like x0, x1, x2.
- `one_of()`: variables in character vector.
- `everything()`: all variables.
---

# Selecting using column range

``` r
> flights %>%
>     select(year:arr_delay)

# A tibble: 336,776 x 9
    year month   day dep_time sched_dep_time dep_delay arr_time
   <int> <int> <int>    <int>          <int>     <dbl>    <int>
 1  2013     1     1      517            515         2      830
 2  2013     1     1      533            529         4      850
 3  2013     1     1      542            540         2      923
 4  2013     1     1      544            545        -1     1004
 5  2013     1     1      554            600        -6      812
# ... with 336,766 more rows, and 2 more variables: sched_arr_time <int>,
#   arr_delay <dbl>

```

---

# Creating columns with mutate()

``` r
> flights_mut <- flights %>%
>     select(year, month, day, dep_time, sched_dep_time, arr_time, sched_arr_time)
>
> flights_mut %>%
>     mutate(dep_delay = dep_time - sched_dep_time,
>            arr_delay = arr_time - sched_arr_time)

# A tibble: 336,776 x 9
    year month   day dep_time sched_dep_time arr_time sched_arr_time
   <int> <int> <int>    <int>          <int>    <int>          <int>
 1  2013     1     1      517            515      830            819
 2  2013     1     1      533            529      850            830
 3  2013     1     1      542            540      923            850
 4  2013     1     1      544            545     1004           1022
 5  2013     1     1      554            600      812            837
# ... with 336,766 more rows, and 2 more variables: dep_delay <int>,
#   arr_delay <int>

```

---

## Using mutate to select columns

``` r
> date_to_epoch <- function(y, m, d) (y + m/12)*365.25*24*3600 + d*3600
> 
> flights_mut %>%
>     transmute(year, day, month,
>               epoch = date_to_epoch(year, month, day))

# A tibble: 336,776 x 4
    year   day month       epoch
   <int> <int> <int>       <dbl>
 1  2013     1     1 63528082200
 2  2013     1     1 63528082200
 3  2013     1     1 63528082200
 4  2013     1     1 63528082200
 5  2013     1     1 63528082200
# ... with 336,766 more rows

```

---

# Manipulating rows

---

# Filtering rows

``` r
> flights %>%
>     filter(carrier == "UA")
 
# A tibble: 58,665 x 19
    year month   day dep_time sched_dep_time dep_delay arr_time
   <int> <int> <int>    <int>          <int>     <dbl>    <int>
 1  2013     1     1      517            515         2      830
 2  2013     1     1      533            529         4      850
 3  2013     1     1      554            558        -4      740
 4  2013     1     1      558            600        -2      924
 5  2013     1     1      558            600        -2      923
# ... with 58,655 more rows, and 12 more variables: sched_arr_time <int>,
#   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#   minute <dbl>, time_hour <dttm>

```

---

# Fancy filtering

``` r
> flights %>%
>     filter(sched_dep_time - dep_time < sched_arr_time - arr_time, carrier == "UA")

# A tibble: 39,433 x 19
    year month   day dep_time sched_dep_time dep_delay arr_time
   <int> <int> <int>    <int>          <int>     <dbl>    <int>
 1  2013     1     1      559            600        -1      854
 2  2013     1     1      607            607         0      858
 3  2013     1     1      643            646        -3      922
 4  2013     1     1      644            636         8      931
 5  2013     1     1      646            645         1      910
# ... with 39,423 more rows, and 12 more variables: sched_arr_time <int>,
#   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#   minute <dbl>, time_hour <dttm>
```

---

## Helper functions are great for filtering too

``` r
> flights %>%
>     filter(is.na(arr_delay)) %>%
>     nrow()

[1] 9430
```

---

## Even base R can be elegant

``` r
> flights %>%
>     filter(dest %in% c("MIA", "JFK"))

# A tibble: 11,728 x 19
    year month   day dep_time sched_dep_time dep_delay arr_time
   <int> <int> <int>    <int>          <int>     <dbl>    <int>
 1  2013     1     1      542            540         2      923
 2  2013     1     1      606            610        -4      858
 3  2013     1     1      607            607         0      858
 4  2013     1     1      623            610        13      920
 5  2013     1     1      655            700        -5     1002
# ... with 11,718 more rows, and 12 more variables: sched_arr_time <int>,
#   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#   minute <dbl>, time_hour <dttm>
```
---

# Order rows with arrange()

``` r
> flights %>%
>     arrange(sched_dep_time)

# A tibble: 336,776 x 19
    year month   day dep_time sched_dep_time dep_delay arr_time
   <int> <int> <int>    <int>          <int>     <dbl>    <int>
 1  2013     7    27       NA            106        NA       NA
 2  2013     1     2      458            500        -2      703
 3  2013     1     3      458            500        -2      650
 4  2013     1     4      456            500        -4      631
 5  2013     1     5      458            500        -2      640
# ... with 336,766 more rows, and 12 more variables: sched_arr_time <int>,
#   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#   minute <dbl>, time_hour <dttm>

```

---

## Ordering by mulitple columns

``` r
> flights %>%
>     arrange(year, month, -day)

# A tibble: 336,776 x 19
    year month   day dep_time sched_dep_time dep_delay arr_time
   <int> <int> <int>    <int>          <int>     <dbl>    <int>
 1  2013     1    31        1           2100       181      124
 2  2013     1    31        4           2359         5      455
 3  2013     1    31        7           2359         8      453
 4  2013     1    31       12           2250        82      132
 5  2013     1    31       26           2154       152      328
# ... with 336,766 more rows, and 12 more variables: sched_arr_time <int>,
#   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#   minute <dbl>, time_hour <dttm>
```

---

# Order by function

``` r
> flights %>%
>     arrange(abs(dep_delay)) %>%
>     tail()

# A tibble: 6 x 19
   year month   day dep_time sched_dep_time dep_delay arr_time
  <int> <int> <int>    <int>          <int>     <dbl>    <int>
1  2013     9    30       NA           1842        NA       NA
2  2013     9    30       NA           1455        NA       NA
3  2013     9    30       NA           2200        NA       NA
4  2013     9    30       NA           1210        NA       NA
5  2013     9    30       NA           1159        NA       NA
6  2013     9    30       NA            840        NA       NA
# ... with 12 more variables: sched_arr_time <int>, arr_delay <dbl>,
#   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
#   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>,
#   time_hour <dttm>
```

---

# Grouping and Aggregation

---

## Grouping with group_by()

``` r
> flights %>%
>     group_by(carrier)

# A tibble: 336,776 x 19
# Groups:   carrier [16]
    year month   day dep_time sched_dep_time dep_delay arr_time
   <int> <int> <int>    <int>          <int>     <dbl>    <int>
 1  2013     1     1      517            515         2      830
 2  2013     1     1      533            529         4      850
 3  2013     1     1      542            540         2      923
 4  2013     1     1      544            545        -1     1004
 5  2013     1     1      554            600        -6      812
# ... with 336,766 more rows, and 12 more variables: sched_arr_time <int>,
#   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#   minute <dbl>, time_hour <dttm>
```

---

## Aggregating with summarise()

``` r
> flights %>%
>     group_by(carrier, dest) %>%
>     summarise(N = n(),
>               max_arr_delay = max(arr_delay),
>               max_dep_delay = max(dep_delay))

# A tibble: 314 x 5
# Groups:   carrier [?]
   carrier dest      N max_arr_delay max_dep_delay
   <chr>   <chr> <int>         <dbl>         <dbl>
 1 9E      ATL      59            NA            NA
 2 9E      AUS       2            25            44
 3 9E      AVL      10            13            19
 4 9E      BGR       1            NA            34
 5 9E      BNA     474            NA            NA
# ... with 304 more rows
```

---

## Group_by and mutate works too!

``` r
> flights %>%
>     group_by(carrier, dest) %>%
>     mutate(delta_mean_airtime = air_time - mean(air_time, na.rm = T)) %>%
>     select(flight, carrier, dest, delta_mean_airtime)

# A tibble: 336,776 x 4
# Groups:   carrier, dest [314]
   flight carrier dest  delta_mean_airtime
    <int> <chr>   <chr>              <dbl>
 1   1545 UA      IAH                29.1 
 2   1714 UA      IAH                29.1 
 3   1141 AA      MIA                 7.12
 4    725 B6      BQN               -11.2 
 5    461 DL      ATL                 3.84
# ... with 336,766 more rows
```

---

# And also joins

``` r
> airlines <- nycflights13::airlines
> 
> flights %>%
>     inner_join(airlines, by = c("carrier")) %>%
>     select(flight, carrier, name)

# A tibble: 336,776 x 3
   flight carrier name                    
    <int> <chr>   <chr>                   
 1   1545 UA      United Air Lines Inc.   
 2   1714 UA      United Air Lines Inc.   
 3   1141 AA      American Airlines Inc.  
 4    725 B6      JetBlue Airways         
 5    461 DL      Delta Air Lines Inc.    
# ... with 336,766 more rows
```

---

# Ggplot2

A grammer of graphics

<!-- .slide: data-background="https://img.devrant.com/devrant/rant/r_179870_JWBHC.jpg" -->

---

##  Grammer of Graphics

<blockquote>
In brief, the grammar tells us that a statistical graphic is a mapping from data to **aesthetic attributes** (colour, shape, size) of **geometric objects** (points, lines, bars). The plot may also contain **statistical transformations** of the data and is drawn on a specific **coordinates system**.
</blockquote>
<cite> —  Hadley Wickham</cite>

---

## Basics of Ggplot

<img src="images/ggplot1.png">

---

## Basics of Ggplot

<img src="images/ggplot1_1.png">

---

## Basics of Ggplot

<img src="images/ggplot1_2.png">

---

## Basics of Ggplot

<img src="images/ggplot1_3.png">

---

## Basics of Ggplot

<img src="images/ggplot2.png">

---

## Basics of Ggplot

<img src="images/ggplot2_1.png">

---

## Basics of Ggplot

<img src="images/ggplot2_2.png">

---

## Basics of Ggplot

<img src="images/ggplot2_3.png">

---

# Demo Time!

<!-- .slide: data-background="https://media.giphy.com/media/11rIergnpiYpvW/giphy.gif" -->

