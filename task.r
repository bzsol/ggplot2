if (!require(tidyverse)) install.packages("tidyverse")
if (!require(RColorBrewer)) install.packages("RColorBrewer")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(dplyr)) install.packages("dplyr")




library(tidyverse)
library(dplyr)
library(ggplot2)
library(RColorBrewer)


# tuesdata <- tidytuesdayR::tt_load('2020-01-21')
spotify_songs <- readr::read_csv("spotify_songs.csv")


rap_songs <- spotify_songs %>%
  filter(playlist_genre == "rap")


top_rap_songs <- rap_songs %>%
  arrange(desc(track_popularity)) %>%
  head(20)

top_rap_songs <- top_rap_songs %>%
  mutate(track_name = paste(track_name, track_artist, sep = " by "))

top_rap_songs_long <- top_rap_songs %>%
  select(track_name, danceability, energy, speechiness, acousticness, instrumentalness, liveness, valence) %>%
  pivot_longer(-track_name, names_to = "attribute", values_to = "value")




ggplot(top_rap_songs_long, aes(x = track_name, y = value, fill = attribute)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_brewer(palette = "Set1") +
  labs(x="",y = "Value", title = "Top 10 Rap Songs on Spotify in 2020 January", fill = "Attribute") +
  theme_bw() +
  coord_flip()


ggsave("top10.pdf", width = 25, height = 25, units = "cm")



spotify_songs$year <- lubridate::year(as.Date(spotify_songs$track_album_release_date))


rap_songs <- spotify_songs %>%
  filter(playlist_genre == "rap", year >= 2014, year <= 2019)


popularity_per_year <- rap_songs %>%
  group_by(year, playlist_subgenre) %>%
  summarise(mean_popularity = mean(track_popularity, na.rm = TRUE)) %>%
  ungroup()


ggplot(popularity_per_year, aes(x = year, y = mean_popularity, color = playlist_subgenre)) +
  geom_line(linewidth = 1.1) +
  labs(x = "Year", y = "Mean Popularity", title = "Mean Popularity of Rap Songs from 2014 to 2019 by Subgenre", color = "Subgenre") +
  theme_bw()



ggsave("subgenre_pop.pdf", width = 15, height = 10, units = "cm")


spotify_songs$year <- lubridate::year(as.Date(spotify_songs$track_album_release_date))


popularity_per_year <- spotify_songs %>%
  group_by(year, playlist_genre) %>%
  summarise(mean_popularity = mean(track_popularity, na.rm = TRUE)) %>%
  ungroup()


popular_genres <- c("rap", "pop", "rock", "edm", "latin", "r&b")
popularity_per_year <- popularity_per_year %>%
  filter(year >= 1990, year <= 2019, playlist_genre %in% popular_genres)


ggplot(popularity_per_year, aes(x = year, y = mean_popularity, color = playlist_genre)) +
  geom_line() +
  labs(x = "Year", y = "Mean Popularity", title = "Mean Popularity of Songs from 1990 to 2019 by Genre", color = "Genre") +
  theme_bw() +
  facet_wrap(~playlist_genre, scales = "fixed")



ggsave("mean_popularity_other_genres.pdf", width = 30, height = 20, units = "cm")


rap_songs <- spotify_songs %>%
  filter(playlist_genre == "rap")


rap_songs_long <- rap_songs %>%
  select(track_name, danceability, energy, speechiness, acousticness, liveness, valence) %>%
  pivot_longer(-track_name, names_to = "attribute", values_to = "value")


ggplot(rap_songs_long, aes(x = attribute, y = value, fill = attribute)) +
  geom_boxplot() +
  scale_fill_brewer(palette = "Dark2") +
  labs(x = "Attribute", y = "Value", title = "Distribution of Various Attributes for Rap Songs", fill = "Attribute") +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 20),
    axis.title.x = element_text(face = "bold", size = 15),
    axis.title.y = element_text(face = "bold", size = 15),
    axis.text.x = element_text(angle = 45, hjust = 1,size = 15),
    legend.title = element_text(face = "bold", size = 12),
    legend.text = element_text(size = 10)
  )




ggsave("distribution_attributes.pdf", width = 25, height = 25, units = "cm")



spotify_songs$duration_min <- spotify_songs$duration_ms / 60000


spotify_songs$release_year <- as.numeric(format(as.Date(spotify_songs$track_album_release_date), "%Y"))


rap_songs <- spotify_songs %>%
  filter(playlist_genre == "rap", year >= 1990, year <= 2019)


avg_duration_by_year <- rap_songs %>%
  group_by(release_year) %>%
  summarize(avg_duration = mean(duration_min))


p <- ggplot(avg_duration_by_year, aes(x = release_year, y = avg_duration)) +
  geom_bar(stat = "identity", fill = "#69b3a2", alpha = 0.9) +
  labs(x = "Release Year", y = "Average Duration (minutes)", title = "Average Song Duration by Year") +
  theme_bw()


ggsave("avg_duration_years.pdf", width = 15, height = 10, units = "cm")


eminem_songs <- spotify_songs %>%
  filter(str_detect(track_artist, "Eminem"))

kendrick_songs <- spotify_songs %>%
  filter(str_detect(track_artist, "Kendrick Lamar"))


ggplot() +
  geom_point(data = eminem_songs, aes(x = speechiness, y = valence, color = "Eminem"), alpha = 0.5) +
  geom_point(data = kendrick_songs, aes(x = danceability, y = energy, color = "Kendrick Lamar"), alpha = 0.5) +
  labs(x = "speechiness", y = "valence", title = "Eminem and Kendrick Lamar's Songs valence and speechines", color = "Artist") +
  theme_bw()

ggsave("kendrick_eminem.pdf", width = 15, height = 10, units = "cm")
