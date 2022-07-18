library(sf)
library(sfheaders)

# inspiration : 
# http://s3.cleverelephant.ca/invalid.html

quick_plot <- function(df){
    plot(sfheaders::sf_polygon(df))
} 

##  1. Exverted shell, point touch
df <- data.frame(
x = c(1, 1, 4, 8, 8, 4, 1),
y = c(1, 8, 6, 1, 8, 6, 1)
)

quick_plot(df)

##  2. Exverted shell, point-line touch

df <- data.frame(
    x = c(1, 1, 8, 8, 5, 1),
    y = c(1, 8, 8, 1, 8, 1)
)

quick_plot(df)


##  3. EExverted shell, line touch

df <- data.frame(
    x = c(1, 1, 8, 8, 5, 3, 1),
    y = c(1, 8, 8, 1, 8, 8, 1)
)

quick_plot(df)


## 4. Inverted shell, point touch

df <- data.frame(
    x = c(1, 1, 4, 2, 6, 4, 8, 8, 1),
    y = c(1, 8, 8, 5, 5, 8, 8, 1, 1)
)

quick_plot(df)

## 5. Inverted shell, point-line touch

df <- data.frame(
    x = c(1, 1, 3, 3, 7, 3, 8, 8, 1),
    y = c(1, 8, 8, 2, 2, 5, 5, 1, 1)
)

quick_plot(df)

## 6. Inverted shell, line touch, exterior

df <- data.frame(
    x = c(1, 1, 6, 6, 3, 3, 8, 8, 1),
    y = c(1, 8, 8, 4, 4, 8, 8, 1, 1)
)

quick_plot(df)

## 7. Inverted shell, line touch, interior

df <- data.frame(
    x = c(1, 1, 4.5, 4.5, 3,   6,   4.5, 4.5, 8, 8, 1  ),
    y = c(1, 8, 8,   6  , 3.5, 3.5, 6,   8, 8,  1, 1  )
)

quick_plot(df)

## 8 polygon/hole Exverted hole, point touch  
# here I think I need sf 

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,2), c(2,6), c(4,5), c(6,2), c(6,6), c(4,5), c(2,2))
pol <-st_polygon(list(p1,p2))

plot(pol)

## 9 Polygon/hole Exverted hole, point-line touch 

p2 <- rbind(c(2,2), c(2,6), c(6,6), c(6,2), c(4,6), c(2,2))
pol <-st_polygon(list(p1,p2))

plot(pol)

## 10 Polygon/Hole Exverted hole, line touch

p2 <- rbind(c(2,2), c(2,6), c(3,5), c(4,5), c(6,6), c(6,2), c(4,5), c(3,5), c(2,2))
pol <-st_polygon(list(p1,p2))

plot(pol)


## 11 Polygon/hole - Inverted hole, point touch 

inner <- data.frame(
    x = c(1, 1, 4, 2, 6, 4, 8, 8, 1),
    y = c(1, 8, 8, 5, 5, 8, 8, 1, 1)
)

inner_sf <- sfheaders::sf_polygon(inner)
inner_centroid <- sf::st_centroid(inner_sf)
inner_scale <- (inner_sf - inner_centroid) * 0.8 + inner_centroid

# scaling

plot(sfheaders::sf_polygon(small_inner))
