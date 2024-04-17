if (!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
}

data(mtcars)

cyl_and_names <- data.frame(
  Car = rownames(mtcars),
  Cyl = mtcars$cyl,
  Mpg = mtcars$mpg
)

cyl_4 <- subset(cyl_and_names, Cyl == 4)

cyl_6 <- subset(cyl_and_names, Cyl == 6)

cyl_8 <- subset(cyl_and_names, Cyl == 8)

plot <- ggplot() +
  geom_bar(
    data = cyl_4,
    aes(
      x = Mpg,
      y = reorder(Car, -Mpg),
      fill = "4"
    ),
    stat = "identity",
    width = 0.7
  ) +
  geom_bar(
    data = cyl_6,
    aes(
      x = Mpg,
      y = reorder(Car, -Mpg),
      fill = "6"
    ),
    stat = "identity",
    width = 0.7
  ) +
  geom_bar(
    data = cyl_8,
    aes(
      x = Mpg,
      y = reorder(Car, -Mpg),
      fill = "8"
    ),
    stat = "identity",
    width = 0.7
  ) +
  labs(
    title = "Plot1",
    x = "Miles Per Gallon",
    y = "",
    fill = "Cylinder Count"
  ) +
  scale_fill_manual(
    values = c(
      "4" = "skyblue",
      "6" = "darkblue",
      "8" = "lightgreen"
    )
  ) +
  theme_minimal() +
  theme(legend.position = "top")

ggsave("plot.pdf", plot, width = 13, height = 15, units = "cm", bg = "white")
