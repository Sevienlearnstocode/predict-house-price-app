library(sf)
library(dplyr)
library(ggplot2)
library(lattice)
library(caret)

# Import data
data1 <- read.csv("geometry_solved_attribute_data_after_preprocessing6.csv")
head(data1)

data2 <- st_read("geometry_solved_index_geometry_add_attractions6_centroid.shp")
head(data2)

# Only keep rows that are in both X and Y
dataset <- inner_join(data1, data2, by = "no")
nrow(dataset)

library(sf)
library(spData)
library(spdep)  # Load the spdep package

# Assuming 'dataset_rumah' is already loaded as a data frame
# Filter 'dataset_rumah' to only include rows with 'tipe_properti' equal to 'Rumah'
dataset_rumah <- subset(dataset, tipe_properti == 'Rumah')

# Check the number of rows in 'dataset_rumah'
nrow(dataset_rumah)

# Convert dataset_rumah to a spatial data frame
dataset_rumah <- st_as_sf(dataset_rumah)

# Assuming dataset_rumah is your dataframe
dataset_rumah <- subset(dataset_rumah, select = -tipe_iklan)

# Load the spdep package
library(spatialreg)

options(scipen=12)

dataset_rumah$harga

length(unique(st_geometry(dataset_rumah)))

hist(dataset_rumah$harga)

# # Calculate the IQR
# Q1 <- quantile(dataset_rumah$harga, 0.25)
# Q3 <- quantile(dataset_rumah$harga, 0.75)
# IQR <- Q3 - Q1
# 
# # Define the upper and lower bounds for outliers
# lower_bound <- Q1 - 1.5 * IQR
# upper_bound <- Q3 + 1.5 * IQR
# 
# # Filter out rows where 'harga' is outside the bounds
# dataset_rumah_filtered <- dataset_rumah[dataset_rumah$harga >= lower_bound & dataset_rumah$harga <= upper_bound, ]
# nrow(dataset_rumah_filtered)

# Step1: Define neighboring polygons
queen.nb <- poly2nb(dataset_rumah)
rook.nb <- poly2nb(dataset_rumah, queen=FALSE)

# Step2: Assign weights to the neighbors
queen.listw <- nb2listw(queen.nb, style="W", zero.policy=TRUE)
rook.listw <- nb2listw(rook.nb, style="W", zero.policy=TRUE)
listw1 <- queen.listw

# Logarithmic transformation
dataset_rumah <- dataset_rumah %>%
  mutate(log_transformed_harga = log(dataset_rumah$harga + 1))  # Adding 1 to handle zero values

# dataset_rumah <- dataset_rumah %>%
#   mutate(sqrt_transformed_harga = sqrt(dataset_rumah$harga))

formula <- log_transformed_harga ~ banyak_kamar_tidur+banyak_toilet+luas_gedung+daya_listrik+lebar_jalan+
  jumlah_populasi+luas_tanah+halte+apotek+saluran+sungai+cagar_buda+danau_embu+daya_tarik+gdf_bandar+
  spbg+pemerintah
# formula <- sqrt_transformed_harga ~ luas_gedung + daya_listrik + luas_tanah + sarana_iba + cagar_buda + daya_tarik + pemerintah + panti_asuh

# 1. GWR
library(sp)
library(spgwr)

# Bandwidth selection
weight.gwr <- gwr.sel(formula, data = dataset_rumah,
                      coords = cbind(dataset_rumah$longitude, dataset_rumah$latitude))

# Fitting GWR model
modelgwr <- gwr(formula, data = dataset_rumah,
                coords = cbind(dataset_rumah$longitude, dataset_rumah$latitude),
                bandwidth = weight.gwr)


summary(modelgwr)

n <- nrow(dataset_rumah)
RSS <- sum(residuals(modelgwr$lm)^2)
k <- length(coef(modelgwr$lm))  # Number of coefficients in the model, including intercept

AIC_value <- n * log(RSS/n) + 2 * k
AIC_value

BIC_value <- n * log(RSS/n) + k * log(n)
BIC_value

# Compute the AICc value manually from RSS
sigma_squared <- RSS / (n - k)  # Estimate of the error variance

# Calculate log-likelihood
log_likelihood <- -n/2 * log(2 * pi) - n/2 * log(sigma_squared) - RSS / (2 * sigma_squared)

# Calculate AICc
AICc_value <- -2 * log_likelihood + 2 * k + 2 * k * (k + 1) / (n - k - 1)
AICc_value

# Calculate Mean Squared Error (MSE)
MSE <- mean(residuals(modelgwr$lm)^2)
MSE

# Calculate SSE (Sum of Squared Errors)
SSE <- sum(residuals(modelgwr$lm)^2)
SSE


# Fit SAR model after handling missing values
sar_model <- lagsarlm(formula,
                      data = dataset_rumah,
                      listw = listw1,
                      method = "LU",
                      Durbin = TRUE,
                      tol.solve = 1e-5,
                      zero.policy = TRUE)

AIC(sar_model)
BIC(sar_model)

# Calculate AICc using bbmle package
install.packages("MuMIn")
library(MuMIn)
AICc(sar_model)

#calculate MSE
mean(sar_model$residuals^2)

# Calculate SSE (Sum of Squared Errors)
sum(sar_model$residuals^2)

# Fit spatial error model
sem_model <- errorsarlm(formula,
                        data = dataset_rumah,
                        listw = listw1,
                        method = "LU",
                        Durbin = TRUE,
                        tol.solve = 1e-5,
                        zero.policy = TRUE)

AIC(sem_model)
BIC(sem_model)
AICc(sem_model)

#calculate MSE
mean(sem_model$residuals^2)

# Calculate SSE (Sum of Squared Errors)
sum(sem_model$residuals^2)

saveRDS(sar_model, "sar_model6.rds")
saveRDS(sem_model, "sem_model6.rds")
