# Exploratory Data Analysis with enhanced plots, correlation heatmap, and density/violin

# install.packages("tidyverse")
# install.packages("palmerpenguins")
# install.packages("GGally")
# install.packages("reshape2")   # for correlation heatmap

library(tidyverse)
library(palmerpenguins)
library(GGally)
library(reshape2)

# Load and clean data 
data("penguins")
penguins <- drop_na(penguins)

# Basic structure and summary 
glimpse(penguins)
summary(penguins)

#  Scatterplot: Body mass vs Flipper length
p1 <- ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm, color = species)) +
  geom_point(size = 3, alpha = 0.8) +
  theme_minimal() +
  labs(
    title = "Penguin Body Mass vs Flipper Length by Species",
    x = "Body Mass (g)",
    y = "Flipper Length (mm)",
    color = "Species"
  ) +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

print(p1)
ggsave("C:/Users/hp/Desktop/Penguins/plots/body_flipper_scatter.png",
       plot = p1, width = 7, height = 5, dpi = 300)

#  Boxplot: Body mass by species 
p2 <- ggplot(penguins, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.7) +
  theme_minimal() +
  labs(
    title = "Distribution of Body Mass by Penguin Species",
    x = "Species",
    y = "Body Mass (g)",
    fill = "Species"
  ) +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

print(p2)
ggsave("C:/Users/hp/Desktop/Penguins/plots/body_mass_boxplot.png",
       plot = p2, width = 7, height = 5, dpi = 300)

#  Density/Violin Plot: Body Mass by Species 
p4 <- ggplot(penguins, aes(x = species, y = body_mass_g, fill = species)) +
  geom_violin(alpha = 0.6) +
  geom_jitter(width = 0.15, alpha = 0.6) +
  theme_minimal() +
  labs(
    title = "Violin Plot of Body Mass by Species",
    x = "Species",
    y = "Body Mass (g)",
    fill = "Species"
  ) +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

print(p4)
ggsave("C:/Users/hp/Desktop/Penguins/plots/body_mass_violin.png",
       plot = p4, width = 7, height = 5, dpi = 300)

#  Pairwise relationships 
p3 <- penguins %>%
  select(body_mass_g, bill_length_mm, bill_depth_mm, flipper_length_mm, species) %>%
  ggpairs(aes(color = species)) +
  theme_minimal() +
  labs(title = "Pairwise Relationships of Penguin Measurements") +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

print(p3)
ggsave("C:/Users/hp/Desktop/Penguins/plots/pairwise_plot.png",
       plot = p3, width = 9, height = 9, dpi = 300)

#  Correlation Heatmap 
numeric_vars <- penguins %>%
  select(body_mass_g, bill_length_mm, bill_depth_mm, flipper_length_mm)

cor_matrix <- round(cor(numeric_vars), 2)
cor_melt <- melt(cor_matrix)

p5 <- ggplot(cor_melt, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  geom_text(aes(label = value), color = "black", size = 4) +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0,
                       limit = c(-1,1), space = "Lab", name="Correlation") +
  theme_minimal() +
  labs(title = "Correlation Heatmap of Penguin Measurements") +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

print(p5)
ggsave("C:/Users/hp/Desktop/Penguins/plots/correlation_heatmap.png",
       plot = p5, width = 7, height = 5, dpi = 300)
