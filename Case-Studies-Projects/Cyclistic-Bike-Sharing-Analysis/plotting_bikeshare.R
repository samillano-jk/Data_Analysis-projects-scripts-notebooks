
library(tidyverse)
library(treemapify)



l_blue <- "#2D5AAF"
n_blue <- "#2A5D9A"
d_blue <- "#112e51"
black <- "#212121"
grey <- "#5b616b"
yellow <- "#F9D33C"
green <- "#90d8b2"




member_station <- read.csv("C:/Users/samil/Downloads/Analysis_Cyclistic_Bikeshare/summaries_for_visual/member_pop_station.csv")
casual_station <- read.csv("C:/Users/samil/Downloads/Analysis_Cyclistic_Bikeshare/summaries_for_visual/casual_pop_station.csv")
member_time <- read.csv("C:/Users/samil/Downloads/Analysis_Cyclistic_Bikeshare/summaries_for_visual/member_time.csv")
casual_time <- read.csv("C:/Users/samil/Downloads/Analysis_Cyclistic_Bikeshare/summaries_for_visual/casual_time.csv")
trips <- read.csv("C:/Users/samil/Downloads/Analysis_Cyclistic_Bikeshare/summaries_for_visual/total_trips.csv")
ride <- read.csv("C:/Users/samil/Downloads/Analysis_Cyclistic_Bikeshare/summaries_for_visual/rideable_type.csv")


trips$day <- factor(trips$day, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))


casual_station <- select(casual_station, -member_casual)




# MEMBER STATION RIDES RANKING
# ------------------------------------------------------------------------------

member_station$start_station_name <- factor(member_station$start_station_name,
                                            levels=c("Canal St & Adams St", "Loomis St & Lexington St", "Broadway & Barry Ave",
                                                     "University Ave & 57th St", "Wells St & Elm St", "Wells St & Concord Ln",
                                                     "Clinton St & Madison St", "Clark St & Elm St", "Kingsbury St & Kinzie St",
                                                     "Clinton St & Washington Blvd"))

member_station %>%
  arrange(-total_rides) %>%
  head(10) %>%
  ggplot(aes(start_station_name, total_rides, alpha=start_station_name)) +
  geom_col(fill="#E9C639", color=d_blue) +
  coord_flip() +
  guides(alpha=FALSE) +
  theme(axis.text=element_text(color=black, size=10), axis.title=element_text(size=12),
        plot.caption=element_text(color=grey), plot.title=element_text(size=20),
        plot.subtitle=element_text(size=16, color="#313131"), plot.margin=margin(15,20,2,10,"pt")) +
  labs(title="Top 10 stations with most ride trips", subtitle="Annual Members", x="station name", y="total rides",
       caption="March 2023 to February 2024\n Data made available by Lyft Bikes and Scooters and City of Chicago")

# ggsave("C:/Users/samil/Downloads/Graphs_for_Bike-sharing/member_station.png", width=10, height=7)




# MEMBER HOUR RIDES RANKING


member_time %>%
  group_by(time) %>%
  summarize(avg_ride=mean(rides)) %>%
  ggplot(aes(x=time, y=avg_ride)) + geom_line(color="#EFCF50", linewidth=1.15) +
  geom_point(color=d_blue, size=2) +
  theme(axis.text=element_text(color=black, size=10), axis.title=element_text(size=12),
        plot.caption=element_text(color=grey), plot.title=element_text(size=20),
        plot.subtitle=element_text(size=16, color="#313131"), plot.margin=margin(15,20,2,10,"pt")) +
  scale_y_continuous(labels=scales::comma_format(scale=1e-3)) +
  labs(title="Average weekday rides per hour", subtitle="Annual Members", y="average ride (1000)", x="Hours (in a day)",
       caption="March 2023 to February 2024\n Data made available by Lyft Bikes and Scooters and City of Chicago")

# ggsave("C:/Users/samil/Downloads/Graphs_for_Bike-sharing/member_time.png", width=10, height=7)

# Gets high during hour 7-8 
# Then decreases and starts to increase from 12 until it peak at hour 17, then decreases





# ------------------------------------------------------------------------------
# CASUAL STATION RIDES RANKING: HBAR


casual_station <- casual_station %>%
  mutate(start_station_name=trimws(str_to_title(start_station_name)))


casual_station$start_station_name <- factor(casual_station$start_station_name, levels=c("Montrose Harbor",
                                      "Wells St & Concord Ln", "Dusable Harbor", "Theater On The Lake",
                                      "Shedd Aquarium", "Millennium Park", "Dusable Lake Shore Dr & North Blvd",
                                      "Michigan Ave & Oak St", "Dusable Lake Shore Dr & Monroe St",
                                      "Streeter Dr & Grand Ave"))


casual_station %>%
  arrange(-total_rides) %>%
  head(10) %>%
  ggplot(aes(start_station_name, total_rides, alpha=start_station_name)) +
  geom_col(fill=n_blue, color=d_blue) +
  coord_flip() +
  guides(alpha=FALSE) +
  theme(axis.text=element_text(color=black, size=10), axis.title=element_text(size=12),
        plot.caption=element_text(color=grey), plot.title=element_text(size=20),
        plot.subtitle=element_text(size=16, color="#313131"), plot.margin=margin(15,20,2,10,"pt")) +
  labs(title="Top 10 stations with most ride trips", subtitle="Casual users", x="station name", y="total rides",
       caption="March 2023 to February 2024\n Data made available by Lyft Bikes and Scooters and City of Chicago")

# ggsave("C:/Users/samil/Downloads/Graphs_for_Bike-sharing/casual_station.png", width=10, height=7)





# CASUAL HOUR RIDES RANKING : LINE GRAPH


casual_time %>%
  group_by(time) %>%
  summarize(avg_ride=mean(rides)) %>%
  ggplot(aes(x=time, y=avg_ride)) + geom_line(color=n_blue, linewidth=1.15) +
  geom_point(color=d_blue, size=2) +
  theme(axis.text=element_text(color=black, size=10), axis.title=element_text(size=12),
        plot.caption=element_text(color=grey), plot.title=element_text(size=20),
        plot.subtitle=element_text(size=16, color="#313131"), plot.margin=margin(15,20,2,10,"pt")) +
  scale_y_continuous(labels=scales::comma_format(scale=1e-3)) +
  labs(title="Average weekend rides per hour", subtitle="Casual users", y="average ride (1000)", x="Hours (in a day)",
       caption="March 2023 to February 2024\n Data made available by Lyft Bikes and Scooters and City of Chicago")

# ggsave("C:/Users/samil/Downloads/Graphs_for_Bike-sharing/casual_time.png", width=10, height=7)

# Starts to increase in hour 10 and decreases during hour 18









# ------------------------------------------------------------------------------
# TREEMAP GRAPH FOR BIKE TYPE USED
# 
ggplot(ride, aes(area=bike_count, fill=member_casual, label=rideable_type, subgroup=member_casual )) +
  geom_treemap(layout="squarified", size=2, color="#CFD1CF") +
  geom_treemap_text(place="centre", size=17, color="black") +
  geom_treemap_subgroup_text(place = "centre", size=70,
                             alpha = 0.50, colour = "white",
                             fontface = "italic") +
  guides(fill=FALSE) +
  labs(fill="User type:", title="Bike types: Casual vs Member",caption="March 2023 to February 2024\n Data made available by Lyft Bikes and Scooters and City of Chicago", subtitle="Total bikes used in a year") +
  scale_fill_manual(values=c(l_blue, yellow)) +
  theme(legend.text=element_text(size=10), legend.title=element_text(size=14, vjust=.8),
        plot.subtitle=element_text(size=20, color="#313131"),
        plot.margin=margin(15,10,10,20), plot.title=element_text(size=25),
        legend.position="bottom")



# ggsave("C:/Users/samil/Downloads/Graphs_for_Bike-sharing/total_bikes.png", width=10, height=7)





# ------------------------------------------------------------------------------
# BAR GRAPH FOR AVERAGE BIKE RIDE

ride$rideable_type <- factor(ride$rideable_type, levels=c("electric_bike", "classic_bike", "docked_bike"))



ride_type_duration <- ride %>%
  mutate(avg_ride = avg_ride/60) %>%
  ggplot(aes(rideable_type, avg_ride, fill=member_casual)) +
    geom_col() +
    scale_fill_manual(values=c(l_blue, yellow))  +
    labs(title="Average bike ride: Casual vs Member", subtitle="Per bike type", y="Bike ride (minutes)", x="Bike type", caption="March 2023 to February 2024\n Data made available by Lyft Bikes and Scooters and City of Chicago", fill="User type") +
    theme(axis.text=element_text(color=black, size=10), axis.title=element_text(size=12), plot.caption=element_text(color=grey), plot.title=element_text(size=20), plot.subtitle=element_text(size=16, color="#313131"), plot.margin=margin(15,20,2,10,"pt"))

# ggsave("C:/Users/samil/Downloads/Graphs_for_Bike-sharing/ride_type_duration.png", width=10, height=7)





# ------------------------------------------------------------------------------

# BAR GRAPH FOR BIKE TYPE USED

ggplot(ride, aes(rideable_type, bike_count, fill=member_casual)) +
  geom_col(position=position_dodge(width=.9), width=.8) +
  scale_fill_manual(values=c(d_blue, yellow))  +
  labs(title="Total bikes: Casual vs Member", subtitle="Type of bikes used in a year", y="# Bikes (millions)", x="Bike type", caption="March 2023 to February 2024\n Data made available by Lyft Bikes and Scooters and City of Chicago", fill="User type") +
  theme(axis.text=element_text(color=black, size=10), axis.title=element_text(size=12), plot.caption=element_text(color=grey), plot.title=element_text(size=20), plot.subtitle=element_text(size=16, color="#313131"), plot.margin=margin(15,20,2,10,"pt")) +
  scale_y_continuous(labels=scales::comma_format(scale=1.0e-6))


# ggsave("C:/Users/samil/Downloads/Graphs_for_Bike-sharing/total_bikes.png", width=10, height=7)






# ------------------------------------------------------------------------------

# LINE GRAPH: TOTAL TRIPS
#
labels <- unique(trips$member_casual)
legend_positions <- data.frame(x=c(7.20, 7.20), y=c(375000, 500000), label=labels)

ggplot(trips, aes(day, num_trips)) + geom_line(aes(group=member_casual, color=member_casual), linewidth=1) +
  geom_point(color="#313131") +
  scale_color_manual(values=c(l_blue, yellow)) +
  labs(title="Annual total trips: Casual vs Member", subtitle="Per day in a ", y="Total trips (1000)", x="Days", caption="March 2023 to February 2024\n Data made available by Lyft Bikes and Scooters and City of Chicago") +
  guides(color=FALSE) +
  theme(axis.text=element_text(color=black, size=10), axis.title=element_text(size=12), plot.caption=element_text(color=grey), plot.title=element_text(size=20), plot.subtitle=element_text(size=16, color="#313131"), plot.margin=margin(15,20,2,10,"pt")) +
  geom_text(data=legend_positions, aes(x=x, y=y, label=labels), color=c(l_blue, yellow), size=4, fontface="bold") +
  scale_y_continuous(limits=c(0, 750000), labels=scales::comma_format(scale=1.0e-3))


# ggsave("C:/Users/samil/Downloads/Graphs_for_Bike-sharing/total_trips.png", width=10, height=7)





# ------------------------------------------------------------------------------

# LINE GRAPH FOR RIDE DURATION IN WEEKDAYS
#
labels <- unique(trips$member_casual)
legend_positions <- data.frame(x=c(7, 7), y=c(28.5, 12.5), label=labels)

trips <- trips %>%
  mutate(mean_ride_length= mean_ride_length/60)

ggplot(trips, aes(day, mean_ride_length)) + 
  geom_line(aes(group=member_casual, color=member_casual), linewidth=1) +
  scale_color_manual(values=c(l_blue, yellow)) +
  geom_point(color="#313131") +
  labs(title="Annual ride duration: Casual vs Member", subtitle="Average per day in a week", 
       y="Ride duration (minutes)", x="Days", 
       caption="March 2023 to February 2024\n Data made available by Lyft Bikes and Scooters and City of Chicago") +
  guides(color=FALSE) +
  theme(axis.text=element_text(color=black, size=10), axis.title=element_text(size=12), 
        plot.caption=element_text(color=grey), plot.title=element_text(size=20), 
        plot.subtitle=element_text(size=16, color="#313131"), 
        plot.margin=margin(15,20,2,10,"pt")) + 
  geom_text(data=legend_positions, aes(x=x, y=y, label=labels), color=c(l_blue, yellow), size=4, fontface="bold") +
  scale_y_continuous(limits=c(0, 50))

# ggsave("C:/Users/samil/Downloads/Graphs_for_Bike-sharing/line_bike_ride_length.png", width=10, height=7)
