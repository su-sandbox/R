PlantGrowth <-
data.frame(weight = c(4.17, 5.58, 5.18, 6.11, 4.5, 4.61, 5.17, 4.53,
5.33, 5.14, 4.81, 4.17, 4.41, 3.59, 5.87, 3.83, 6.03, 4.89, 4.32, 4.69,
6.31, 5.12, 5.54, 5.5, 5.37, 5.29, 4.92, 6.15, 5.8, 5.26),
group = factor(c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2,
2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3), levels=1:3,
labels = c("ctrl", "trt1", "trt2")))
