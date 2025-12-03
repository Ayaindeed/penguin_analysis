# Statistical tests & predictive models with PCA and LDA

# install.packages("tidyverse")
# install.packages("palmerpenguins")
# install.packages("caret")
# install.packages("rpart")
# install.packages("rpart.plot")
# install.packages("MASS")  # for LDA

library(tidyverse)
library(palmerpenguins)
library(caret)
library(rpart)
library(rpart.plot)
library(MASS)

#  Load & clean data 
data("penguins")
penguins <- drop_na(penguins)
penguins$species <- factor(penguins$species)

#  ANOVA Tests 
anova_mass <- aov(body_mass_g ~ species, data = penguins)
cat("\n ANOVA: Body Mass \n")
print(summary(anova_mass))
print(TukeyHSD(anova_mass))

anova_flipper <- aov(flipper_length_mm ~ species, data = penguins)
cat("\n ANOVA: Flipper Length \n")
print(summary(anova_flipper))
print(TukeyHSD(anova_flipper))

#  Correlations 
cat("\n Correlation Matrix \n")
print(
  cor(penguins %>% select(body_mass_g, bill_length_mm, bill_depth_mm, flipper_length_mm)) %>% round(2)
)

#  Split data 
set.seed(123)
train_index <- createDataPartition(penguins$species, p = 0.8, list = FALSE)
train <- penguins[train_index, ]
test <- penguins[-train_index, ]

# Logistic Regression
model_log <- train(
  species ~ bill_length_mm + bill_depth_mm + flipper_length_mm + body_mass_g,
  data = train,
  method = "multinom",
  trControl = trainControl(method = "cv", number = 5)
)

cat("\n Logistic Regression Model \n")
print(model_log)

pred_log <- predict(model_log, test)
cat("\n Logistic Regression Confusion Matrix \n")
print(confusionMatrix(pred_log, test$species))

predictions_df <- test %>%
  select(species, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
  mutate(predicted_species = pred_log)

cat("\n Sample Predictions \n")
print(head(predictions_df, 10))

# Decision Tree
model_tree <- rpart(
  species ~ bill_length_mm + bill_depth_mm + flipper_length_mm + body_mass_g,
  data = train
)

png("C:/Users/hp/Desktop/Penguins/plots/decision_tree.png", width = 800, height = 600)
rpart.plot(model_tree, main = "Decision Tree for Predicting Penguin Species")
dev.off()
cat("\nDecision tree plot saved to C:/Users/hp/Desktop/Penguins/plots/decision_tree.png\n")

pred_tree <- predict(model_tree, test, type = "class")
cat("\n Decision Tree Confusion Matrix \n")
print(confusionMatrix(pred_tree, test$species))

predictions_tree_df <- test %>%
  select(species, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
  mutate(predicted_species = pred_tree)

cat("\n Sample Predictions (Decision Tree) \n")
print(head(predictions_tree_df, 10))

# Principal Component Analysis (PCA)
numeric_vars <- penguins %>% select(body_mass_g, bill_length_mm, bill_depth_mm, flipper_length_mm)
pca <- prcomp(numeric_vars, center = TRUE, scale. = TRUE)

# Create data frame with PCA results
pca_df <- data.frame(pca$x, species = penguins$species)

# PCA plot
p_pca <- ggplot(pca_df, aes(x = PC1, y = PC2, color = species)) +
  geom_point(size = 3, alpha = 0.8) +
  theme_minimal() +
  labs(
    title = "PCA of Penguin Measurements",
    x = "PC1",
    y = "PC2",
    color = "Species"
  ) +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

print(p_pca)
ggsave("C:/Users/hp/Desktop/Penguins/plots/pca_plot.png",
       plot = p_pca, width = 7, height = 5, dpi = 300)

# Linear Discriminant Analysis (LDA)
lda_model <- lda(species ~ body_mass_g + bill_length_mm + bill_depth_mm + flipper_length_mm,
                 data = train)

# Predict LDA on test set
pred_lda <- predict(lda_model, test)
cat("\n LDA Confusion Matrix \n")
print(confusionMatrix(pred_lda$class, test$species))

# LDA plot (first 2 discriminants)
lda_df <- data.frame(LD1 = pred_lda$x[,1],
                     LD2 = pred_lda$x[,2],
                     species = test$species)

p_lda <- ggplot(lda_df, aes(x = LD1, y = LD2, color = species)) +
  geom_point(size = 3, alpha = 0.8) +
  theme_minimal() +
  labs(
    title = "LDA of Penguin Measurements (Test Set)",
    x = "LD1",
    y = "LD2",
    color = "Species"
  ) +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

print(p_lda)
ggsave("C:/Users/hp/Desktop/Penguins/plots/lda_plot.png",
       plot = p_lda, width = 7, height = 5, dpi = 300)
