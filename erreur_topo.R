library(sf)
library(sfheaders)

# inspiration : 
# http://s3.cleverelephant.ca/invalid.html

## usefull functions 
### function to convert sfheaders to sf and plot it
quick_plot <- function(df){
    plot(sfheaders::sf_polygon(df))
} 

### scaling sfheader 

scaling_sfheader <- function(df){
    df_sf = sfheaders::sf_polygon(df)
    df_centroid = sf::st_centroid(df_sf)
    df_scale = (df_sf - df_centroid) * 0.8 + df_centroid
        return(st_coordinates(df_scale$geometry)[,1:2])
}

##  1. Polygon - Exverted shell, point touch
df <- data.frame(
x = c(1, 1, 4, 8, 8, 4, 1),
y = c(1, 8, 6, 1, 8, 6, 1)
)

quick_plot(df)

##  2. Polygon - Exverted shell, point-line touch

df <- data.frame(
    x = c(1, 1, 8, 8, 5, 1),
    y = c(1, 8, 8, 1, 8, 1)
)

quick_plot(df)


##  3. Polygon - Exverted shell, line touch

df <- data.frame(
    x = c(1, 1, 8, 8, 5, 3, 1),
    y = c(1, 8, 8, 1, 8, 8, 1)
)

quick_plot(df)


## 4. Polygon - Inverted shell, point touch

df <- data.frame(
    x = c(1, 1, 4, 2, 6, 4, 8, 8, 1),
    y = c(1, 8, 8, 5, 5, 8, 8, 1, 1)
)

quick_plot(df)

## 5. Polygon - Inverted shell, point-line touch

df <- data.frame(
    x = c(1, 1, 3, 3, 7, 3, 8, 8, 1),
    y = c(1, 8, 8, 2, 2, 5, 5, 1, 1)
)

quick_plot(df)

## 6. Polygon - Inverted shell, line touch, exterior

df <- data.frame(
    x = c(1, 1, 6, 6, 3, 3, 8, 8, 1),
    y = c(1, 8, 8, 4, 4, 8, 8, 1, 1)
)

quick_plot(df)

## 7. Polygon - Inverted shell, line touch, interior

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

# scaling 

p2 <- scaling_sfheader(inner)

pol <-st_polygon(list(p1,p2))
plot(pol)

## 12 Polygon/Hole - Inverted hole, point-line touch

inner <- data.frame(
    x = c(1, 1, 3, 3, 7, 3, 8, 8, 1),
    y = c(1, 8, 8, 2, 2, 5, 5, 1, 1)
)

p2 <- scaling_sfheader(inner)

pol <-st_polygon(list(p1,p2))
plot(pol)


## 13. Polygon/Hole - Inverted hole, line touch, interior

inner <- data.frame(
    x = c(1, 1, 6, 6, 3, 3, 8, 8, 1),
    y = c(1, 8, 8, 4, 4, 8, 8, 1, 1)
)

p2 <- scaling_sfheader(inner)

pol <-st_polygon(list(p1,p2))
plot(pol)

## 14. Polygon/Hole - Inverted hole, line touch, exterior 

p2 <- rbind(c(2,2), c(7, 2), c(4.5, 7), c(4.5, 5), c(3.5, 3.5), c(5.5, 3.5),
            c(4.5, 5), c(4.5, 7), c(2,2))

pol <-st_polygon(list(p1,p2))
plot(pol)

## 15. Polygon/Hole - Exverted shell, point touch; exverted hole, point touch

p1 <- rbind(c(1,1), c(1,8), c(8,1), c(8,8), c(1,1))
p2 <- rbind(c(2,3), c(2,6), c(7,3), c(7,6), c(2,3))

pol <-st_polygon(list(p1,p2))
plot(pol)

## 16. Polygon/Hole - Exverted shell, point touch; exverted hole, line touch 

p2 <- rbind(c(2,3), c(2,6), c(3.5, 4.5), c(5.5, 4.5)
            , c(7,3), c(7,6), 
            c(5.5, 4.5), c(3.5, 4.5),
            c(2,3))

pol <-st_polygon(list(p1,p2))
plot(pol)

## 17. Polygon/Hole - Exverted shell, line touch; exverted hole, line touch 

