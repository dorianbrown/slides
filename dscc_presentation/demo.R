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

### GGplot demo

library(ggplot2)
library(dplyr)
library(ggrepel)

flights <- nycflights13::flights
set.seed(1337)

flights %>%
    sample_n(10000) %>%
    ggplot(aes(distance, arr_delay)) + geom_point()

flights %>%
    sample_n(10000) %>%
    filter(distance < 3000) %>%
    ggplot(aes(distance, arr_delay)) + geom_point()

flights %>%
    sample_n(10000) %>%
    filter(distance < 3000) %>%
    ggplot(aes(distance, arr_delay)) + geom_point(alpha = 0.1) + geom_smooth()

flights %>% 
    mutate(flight_num = paste0(carrier, flight)) %>%
    group_by(flight_num, carrier) %>%
    summarise(N = n(),
              avg_arr_delay = mean(arr_delay),
              avg_distance = mean(distance))

flights %>% 
    mutate(flight_num = paste0(carrier, flight)) %>%
    group_by(flight_num, carrier) %>%
    summarise(N = n(),
              avg_arr_delay = mean(arr_delay, na.rm = T),
              avg_distance = mean(distance, na.rm = T))

flights %>% 
    mutate(flight_num = paste0(carrier, flight)) %>%
    group_by(flight_num, carrier) %>%
    summarise(N = n(),
              avg_arr_delay = mean(arr_delay, na.rm = T),
              avg_distance = mean(distance, na.rm = T)) %>%
    ggplot(aes(x = avg_distance, y = avg_arr_delay, size = N)) + 
        geom_point() + 
        geom_smooth()

flights %>% 
    mutate(flight_num = paste0(carrier, flight)) %>%
    group_by(flight_num, carrier) %>%
    summarise(N = n(),
              avg_arr_delay = mean(arr_delay, na.rm = T),
              avg_distance = mean(distance, na.rm = T)) %>%
    filter(N > 20, avg_distance < 3000) %>%
    ggplot(aes(x = avg_distance, y = avg_arr_delay, size = N)) + 
        geom_point(alpha = 0.25) + 
        geom_smooth()

top5_airlines <- flights %>% 
    group_by(carrier) %>%
    summarise(N = n()) %>%
    arrange(-N) %>%
    top_n(5) %>%
    pull(carrier)

top10_destination <- flights %>% 
    group_by(dest) %>%
    summarise(N = n()) %>%
    arrange(-N) %>%
    top_n(10) %>%
    pull(dest)

planes <- nycflights13::planes %>%
    select(year, tailnum)

flights %>%
    group_by(tailnum) %>%
    summarise(N = n(),
              avg_dep_delay = mean(dep_delay, na.rm = T),
              avg_arr_delay = mean(arr_delay, na.rm = T)) %>%
    left_join(planes, by = "tailnum") %>%
    filter(year > 1981) %>%
    ggplot(aes(x = year, y = avg_arr_delay)) +
        geom_point() + 
        geom_smooth()

# Which airline have the oldest planes? And the most planes?

planes <- nycflights13::planes

planes %>%
    left_join(flights, by = "tailnum") %>%
    select(plane_year = year.x,
           carrier,
           manufacturer) %>%
    ggplot(aes(x = plane_year)) + 
        geom_histogram(aes(y = ..density..)) + 
        facet_wrap(~carrier)

planes %>%
    left_join(flights, by = "tailnum") %>%
    select(plane_year = year.x,
           carrier,
           manufacturer) %>%
    ggplot(aes(x = plane_year)) + 
    geom_histogram() + 
    facet_wrap(~carrier)
    
planes %>%
    left_join(flights, by = "tailnum") %>%
    select(carrier,
           manufacturer) %>%
    filter(manufacturer %in% top_airlines) %>%
    ggplot(aes(x = manufacturer)) + geom_bar() 

planes %>%
    left_join(flights, by = "tailnum") %>%
    left_join(nycflights13::airlines, by = "carrier") %>%
    select(name,
           manufacturer) %>%
    filter(manufacturer %in% top_airlines) %>%
    ggplot(aes(x = manufacturer)) + 
        geom_bar() +
        facet_wrap(~name)

## Map data

airports <- nycflights13::airports %>% 
    filter(stringr::str_detect(tzone, "America"), !stringr::str_detect(tzone, "Anchorage")) %>%
    select(faa:alt)

flights <- flights %>%
    left_join(airports, by = c("origin" = "faa")) %>%
    left_join(airports, by = c("dest" = "faa"), suffix = c("_orig", "_dest"))
    

states <- map_data("state")
ggplot() +
    geom_polygon(data = states, 
                 aes(x = long, y = lat, fill = region, group = group), 
                 color = "grey", 
                 fill = "white")

dscc_map <- geom_polygon(data = states, 
                         aes(x = long, y = lat, fill = region, group = group), 
                         color = "grey", 
                         fill = "white")

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

flights %>%
    group_by(origin, dest) %>%
    summarise(N = n()) %>%
    left_join(airports, by = c("origin" = "faa")) %>%
    left_join(airports, by = c("dest" = "faa")) %>%
    ggplot() + 
        dscc_map +
        geom_segment(aes(x = lon.x, y = lat.x,
                         xend = lon.y, yend = lat.y, 
                         color = origin), 
                     alpha = 0.5, size = 1)

flights %>%
    group_by(origin, dest) %>%
    summarise(N = n()) %>%
    left_join(airports, by = c("origin" = "faa")) %>%
    left_join(airports, by = c("dest" = "faa")) %>%
    ggplot() + 
        dscc_map +
        geom_segment(aes(x = lon.x, y = lat.x,
                         xend = lon.y, yend = lat.y), alpha = 0.25, size = 1) + 
        facet_grid(.~origin)

flights %>%
    group_by(origin, dest) %>%
    summarise(N = n()) %>%
    left_join(airports, by = c("origin" = "faa")) %>%
    left_join(airports, by = c("dest" = "faa")) %>%
    ggplot() + 
        dscc_map +
        geom_jitter(aes(x = lon.y, y = lat.y, color = origin), size = 2.5, height=0.25, width=0.25)

###

library(lubridate)

flights %>%
    sample_n(10000) %>%
    mutate(week = as.factor(week(time_hour))) %>%
    select(week, arr_delay, dep_delay) %>%
    tidyr::gather("delay_type", "delay", 2:3) %>%
    ggplot(aes(x = week, y = delay, fill = delay_type)) + 
        geom_boxplot(outlier.shape = NA) + 
        scale_y_continuous(limits = c(-75,125))

flights %>%
    sample_n(10000) %>%
    mutate(week = as.factor(week(time_hour))) %>%
    ggplot(aes(x = week, y = arr_delay))


flights %>%
    sample_n(10000) %>%
    mutate(week = as.factor(week(time_hour))) %>%
    select(week, origin, arr_delay, dep_delay) %>%
    tidyr::gather("delay_type", "delay", 3:4) %>%
    ggplot(aes(x = week, y = delay, fill = delay_type)) + 
        geom_boxplot(outlier.shape = NA) + 
        scale_y_continuous(limits = c(-75,125)) +
        facet_grid(origin~.)

flights %>%
    sample_n(10000) %>%
    mutate(week = as.factor(week(time_hour))) %>%
    select(week, origin, arr_delay, dep_delay) %>%
    tidyr::gather("delay_type", "delay", 3:4) %>%
    ggplot(aes(x = week, y = delay, fill = origin)) + 
    geom_boxplot(outlier.shape = NA) + 
    scale_y_continuous(limits = c(-75,125)) +
    facet_grid(delay_type~.)

flights %>%
    mutate(date = ISOdate(year, month, day)) %>%
    group_by(origin, date) %>%
    summarise(avg_delay =  mean(arr_delay, na.rm = TRUE) + mean(dep_delay, na.rm = TRUE)) %>%
    ungroup() %>%
    ggplot(aes(x = date, y = avg_delay, color = origin)) +
        geom_point() +
        geom_smooth()

flights %>%
    sample_n(10000) %>%
    mutate(week = week(time_hour)) %>%
    select(week, origin, arr_delay, dep_delay) %>%
    tidyr::gather("delay_type", "delay", 3:4) %>%
    ggplot(aes(x = week, y = delay, color = delay_type)) + 
        geom_smooth(method = "lm") +
        facet_grid(origin~.)

weekly_flights <- flights %>%
    mutate(week = as.factor(week(time_hour))) %>%
    group_by(week) %>%
    summarise(weekly_flights = n())

weekly_delay <- flights %>%
    sample_n(10000) %>%
    mutate(week = as.factor(week(time_hour))) %>%
    select(week, arr_delay, dep_delay) %>%
    tidyr::gather("delay_type", "delay", 2:3)

weekly_flights %>%
    inner_join(weekly_delay, by = "week") %>%
    filter(weekly_flights > 2000) %>%
    ggplot(aes(x = weekly_flights, y = delay, color = delay_type)) + geom_point()

weekly_flights %>%
    inner_join(weekly_delay, by = "week") %>%
    filter(weekly_flights > 2000) %>%
    ggplot(aes(x = weekly_flights, y = delay)) + geom_point() + geom_smooth(aes(color = delay_type)) + scale_y_continuous(limits = c(0, 50))

# Most popular destination per month of year
# Zoom into Summer/Spring Break

flights %>%
    sample_n(10000) %>%
    mutate(week = as.factor(lubridate::week(time_hour))) %>%
    ggplot(aes(x = week, y = distance)) + geom_bin2d() + geom_point(alpha = 0.1)

flights %>%
    mutate(week = as.factor(lubridate::week(time_hour))) %>%
    ggplot(aes(x = week, y = distance)) + geom_boxplot()

# Distribution of delays.

# Check arrival delay and age of plane

flights %>%
    select(arr_delay, dep_delay) %>%
    tidyr::gather("delay_type", "delay") %>%
    ggplot(aes(x = delay, fill = delay_type)) + geom_histogram(position = "dodge") + geom_density(aes(y = ..count..*10), alpha = 0.25) + scale_x_continuous(limits = c(-100, 250))
