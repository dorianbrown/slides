# Exploratory Data Analysis in R

A practical guide `dplyr`, `ggplot2`, and the tidyverse family

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

## The "Verbs"

The idea behind dplyr is to have a few simple functions which can be combined to create more advanced behavior:

- `mutate`: Create or overwrite columns
- `select`: Subsets columns by name
- `filter`: Subsets rows by values
- `summarise`: Reduces multiple row values to single values
- `arrange`: Orders rows
- `group_by`: Groups rows by condition

Note: Mention how this is similar to SQL. While old fashioned, SQL has been the standard language for dealing with data since 1974 (44 years).

---

# Ggplot2

A grammer of graphics

<!-- .slide: data-background="https://img.devrant.com/devrant/rant/r_179870_JWBHC.jpg" -->

---

# Demo Time!

<!-- .slide: data-background="https://media.giphy.com/media/11rIergnpiYpvW/giphy.gif" -->
