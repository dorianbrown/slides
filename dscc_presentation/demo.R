options(tibble.print_max = 5)
library(dplyr)

flights <- nycflights13::flights %>% 
    select(dep_time, sched_dep_time, dep_delay, arr_time, 
           sched_arr_time, arr_delay, carrier, dest)
flights %>% head()

#### Manipulating columns

flights %>%
    select(dep_time, arr_time)

flights %>%
    select(-dest, -carrier)

flights %>%
    select("departure" = dep_time)

flights %>%
    select(ends_with("time"))

flights %>%
    select(dep_time:arr_time)

flights %>%
    mutate(dep_delay = dep_time - sched_dep_time,
           arr_delay = arr_time - sched_arr_time)

date_to_epoch <- function(y, m, d) (y + m/12)*365.25*24*3600 + d*3600

flights %>%
    transmute(year, day, month,
              epoch = date_to_epoch(year, month, day))

#### Manipulating rows: (Filter, Arrange)

flights %>%
    filter(carrier == "UA")

flights %>%
    filter(sched_dep_time - dep_time < sched_arr_time - arr_time, carrier == "UA")

# Help functions are awesome here too

flights %>%
    filter(is.na(arr_delay)) %>%
    nrow()

flights %>%
    filter(carrier %in% c("UA", "AA"))

# Arrange

flights %>%
    arrange(sched_dep_time)

flights %>%
    arrange(year, month, -day)

flights %>%
    arrange(abs(dep_delay)) %>%
    tail()

# Grouping and Aggregation

flights %>%
    group_by(carrier)

flights %>%
    group_by(carrier, dest) %>%
    summarise(N = n(),
              max_arr_delay = max(arr_delay),
              max_dep_delay = max(dep_delay))

flights %>%
    group_by(carrier, dest) %>%
    mutate(delta_mean_airtime = air_time - mean(air_time, na.rm = T)) %>%
    select(flight, carrier, dest, delta_mean_airtime)

airlines <- nycflights13::airlines

flights %>%
    inner_join(airlines, by = c("carrier")) %>%
    select(flight, carrier, name)                    

flights %>%
    inner_join(x = ., y = ., by = c("dep_delay" = "arr_delay"))

routes <- flights %>% 
    select(origin, dest) %>% 
    distinct()

library(ggplot2)
library(ggrepel)

flights %>%
    sample_n(10000) %>%
    ggplot(aes(distance, arr_delay)) + geom_point()

## Map data

airports <- nycflights13::airports %>% 
    filter(stringr::str_detect(tzone, "America"), !stringr::str_detect(tzone, "Anchorage")) %>%
    select(faa:alt)

flights <- flights %>%
    left_join(airports, by = c("origin" = "faa")) %>%
    left_join(airports, by = c("dest" = "faa"), suffix = c("_orig", "_dest"))
    
dscc_map <- geom_polygon(data = states, 
                         aes(x = long, y = lat, fill = region, group = group), 
                         color = "grey", 
                         fill = "white")

states <- map_data("state")
airports %>%
    sample_n(1000) %>%
    ggplot(aes(x = lon, y = lat, color = alt)) + dscc_map + geom_point()
    
flights %>%
    group_by(dest) %>%
    summarise(num_flights = n()) %>%
    ungroup() %>%
    left_join(airports, by = c("dest" = "faa")) %>%
    ggplot() +
    dscc_map +
    geom_point(aes(x = lon, y = lat, size = num_flights)) + 
    geom_label_repel(data = . %>% filter(num_flights > 10000), 
                    aes(x = lon, y = lat, label = name, color = "red"),
                    nudge_x = -2,
                    nudge_y = -2)




ggplot(data, aes(x = col1, y = col2)) + geom_point() + geom_line()




ggplot(data, aes(x = col1, y = col2)) + geom_point() + geom_line(aes(size = col3))




