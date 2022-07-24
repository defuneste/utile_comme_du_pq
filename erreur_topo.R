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

scaling_sfheader <- function(df, scales = 0.8){
    df_sf = sfheaders::sf_polygon(df)
    df_centroid = sf::st_centroid(df_sf)
    df_scale = (df_sf - df_centroid) * scales + df_centroid
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

p1 <- rbind(c(1,1), c(1,8), c(3.5, 4.5), c(5.5, 4.5), c(8,1), c(8,8), 
            c(5.5, 4.5), c(3.5, 4.5),  c(1,1))
p2 <- rbind(c(2,3), c(2,6), c(3, 4.5), c(6, 4.5), c(7,3), c(7,6),
            c(6, 4.5), c(3, 4.5), c(2,3))

pol <-st_polygon(list(p1, p2))
plot(pol)


## 18. Polygon/Hole - Adjacent

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(5, 3), c(5,6), c(8,6), c(8, 3), c(5,3))

pol <-st_polygon(list(p1, p2))
plot(pol)

## 19. Polygon/Holes - Adjacent holes

p2 <- rbind(c(3, 3), c(3,6), c(4.5,6), c(4.5, 3), c(3,3))
p3 <- rbind(c(4.5, 4), c(4.5, 5), c(5.5, 5), c(5.5, 4), c(4.5, 4))

pol <-st_polygon(list(p1, p2, p3))
plot(pol)

## 20. Polygon/Holes - Exverted holes crossing at point 
# I think it is two inner rings but could be wrong
# I should check if middle point is needed 

p2 <- rbind(c(4, 7), c(5, 7), c(4.5, 4.5), c(4,2), c(5,2), c(4.5, 4.5),  c(4, 7))
p3 <- rbind(c(2, 4), c(2, 5),  c(4.5, 4.5), c(7, 4), c(7,5),  c(4.5, 4.5), c(2,4))

pol <-st_polygon(list(p1, p2, p3))
plot(pol)

## 21. Polygon/Holes - Exverted holes crossing at line

p2 <- rbind(c(4, 7), c(5, 7),c(4.5, 6), c(4.5, 3), 
            c(4,2), c(5,2), c(4.5, 3), c(4.5, 6), c(4,7))
p3 <- rbind(c(2, 4), c(2, 5), c(3, 4.5), c(6, 4.5), 
            c(7, 4), c(7,5), c(6, 4.5),  c(3, 4.5), c(2,4))

pol <-st_polygon(list(p1, p2, p3))
plot(pol)

## 22. Polygon - Zero area

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(1,8), c(1,1))

pol <-st_polygon(list(p1))
plot(pol)

## 23. Polygon - Zero-width gore

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(4.5, 4.5), c(8,8), c(8,1), c(1,1))

pol <-st_polygon(list(p1))
plot(pol)

## 24. Polygon - Zero-width gore splitting

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(1, 1), c(8,8), c(8,1), c(1,1))

pol <-st_polygon(list(p1))
plot(pol)

## 24. Polygon - Zero-width spike

p1 <- rbind(c(4,1), c(1,1), c(1,4), c(4,4), c(8, 8), c(4,4), c(4,1))

pol <-st_polygon(list(p1))
plot(pol)

## 25. Zero-width spike along boundary

p1 <- rbind(c(1,1), c(1,8), c(6,8), c(3,8), c(8,8), c(8,1), c(1,1))

pol <-st_polygon(list(p1))
plot(pol)

## 26. Polygon/Hole - Zero-width spike splitting hole 


p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(3,3), c(3, 6), c(6,6), c(6,3), c(5,3), c(3,5), c(5,3), c(3,3)) 

pol <-st_polygon(list(p1, p2))
plot(pol)

## 27. Polygon - Zero-width spike enclosing area
# unsure of this one 

p1 <- rbind(c(1,1), c(1,8), c(4,8), c(8,5), c(4,1), c(4,8), c(4,1), c(1,1))

pol <-st_polygon(list(p1))
plot(pol)

## 28. MultiPolygon - Adjacent

df <- data.frame(
    id = c(1,1,1,1,2,2,2,2)
    , x = c(1,1,4,4,4,4,6,6)
    , y = c(1,8,8,1,3,6,6,3)
)

multipol <- sfheaders::sf_multipolygon(df, 
                            multipolygon_id = "id", 
                            polygon_id = "id",
                            linestring_id = "id")

plot(multipol)

## 29. MultiPolygon - Exverted crossing at point

df <- data.frame(
     id = c(1,1,1  ,1,1, 2,2,2  ,2,2)
    , x = c(2,7,4.5,2,7, 2,2,4.5,7,7)
    , y = c(1,1,4.5,8,8, 2,7,4.5,2,7)
)

multipol <- sfheaders::sf_multipolygon(df, 
                                       multipolygon_id = "id", 
                                       polygon_id = "id",
                                       linestring_id = "id")

plot(multipol)

## 30. MultiPolygon - Exverted crossing at line 

df <- data.frame(
     id = c(1,   1,  1  ,1  , 1  ,1  ,1  ,1  ,2  ,2,2,2  ,2  ,2,2,2   )
    , x = c(3.5, 1,  1  ,3.5, 5.5,8  ,8  ,5.5,4.5,2,7,4.5,4.5,2,7,4.5   )
    , y = c(4.5, 1.5,7.5,4.5, 4.5,7.5,1.5,4.5,3.5,1,1,3.5,5.5,8,8,5.5   )
)

multipol <- sfheaders::sf_multipolygon(df, 
                                       multipolygon_id = "id", 
                                       polygon_id = "id",
                                       linestring_id = "id")

plot(multipol)

## 31. Polygon - Bowtie (Figure 8)

p1 <- rbind(c(1,1), c(1,8), c(8,1), c(8,8), c(1,1))

pol <-st_polygon(list(p1))
plot(pol)

## 32. Polygon - Bowtie Multiple

p1 <- rbind(c(1,4), c(1,5), c(5,1), c(4,1), c(8,5), c(8,4), c(4,8), c(5,8), c(1,4))

pol <-st_polygon(list(p1))
plot(pol)

## 33. Polygon - Bowtie, self-overlap

p1 <- rbind(c(1,1.5), c(1,8), c(6,8), c(6,1), c(8,1), c(8,3), c(4,3)
            , c(4,2), c(6.5,2), c(6.5, 1.5), c(1, 1.5))

pol <-st_polygon(list(p1))
plot(pol)

## 34. Polygon - Self-overlap Multiple

p1 <- rbind(c(4,8), c(4,2), c(2,2), c(2,3), c(8,3), c(8,7), c(2.5,7)
            , c(2.5,2.5), c(3.5,2.5), c(3.5, 6), c(7, 6), c(7,4), c(1,4),
            c(1,1), c(5,1), c(5,8), c(4,8))

pol <-st_polygon(list(p1))
plot(pol)

## 35. Polygon - Self-overlap; Pos and Neg winding

p1 <- rbind(c(1,1), c(8,1), c(8,7), c(3,7), c(3,5), c(7,5), c(7,3)
            , c(5,3), c(5,8), c(1, 8), c(1,1))

pol <-st_polygon(list(p1))
plot(pol)


## 36. Polygon - Self-overlap; double Pos and single Neg winding 

p1 <- rbind(c(1,1), c(1,8), c(4.5,8), c(4.5,2), c(6,2), c(6,4), c(3,4)
            , c(3,6), c(8,6), c(8, 1), c(1,1))

pol <-st_polygon(list(p1))
plot(pol)

## 37. Polygon - Self-overlap; double Pos and single Neg winding 

p1 <- rbind(c(2,1), c(2,7), c(6,7), c(6,2), c(3,2), c(3,6), c(5,6)
            , c(5,3), c(8,3), c(8, 5), c(1,5), c(1,8),c(8,8), c(7,1), c(2,1))

pol <-st_polygon(list(p1))
plot(pol)

## 38. Polygon - Self-overlap - Pos and Neg winding 

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(6,1), c(3,3), c(7,6)
            , c(6,7.5), c(3.5, 5.5), c(5.5,5.5), c(3,7.5),c(2,6)
            , c(6,3), c(3,1),  c(1,1))

pol <-st_polygon(list(p1))
plot(pol)

## 39. Polygon - Self-overlap; exterior

p1 <- rbind(c(1,1), c(1,3), c(7,3), c(7,6), c(1,6), c(1,8), c(3,8)
            , c(3,2), c(5,2), c(5, 8), c(8,8), c(8,1), c(1,1))

pol <-st_polygon(list(p1))
plot(pol)

## 40. Polygon - Self-overlap; Spiral with Pos winding

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,2), c(2,2), c(2,7), c(7,7)
            , c(7,3), c(3,3), c(3, 6), c(6,6), c(6,4), c(4,4), c(4,5), c(5,5),
            c(5,1), c(1,1))

pol <-st_polygon(list(p1))
plot(pol)

## 41. Polygon/Hole - Bowties 

p1 <- rbind(c(1,1), c(8,8), c(1,8), c(8,1), c(1,1))
p2 <- rbind(c(3,2), c(6,7), c(3,7), c(6,2), c(3,2))

pol <-st_polygon(list(p1, p2))
plot(pol)

## 42. Polygon/Hole - Bowties, overlap

p1 <- rbind(c(2,1), c(8,8), c(2,8), c(8,1), c(2,1))
p2 <- rbind(c(1,2), c(4.5,7), c(1,7), c(4.5,2), c(1,2))

pol <-st_polygon(list(p1, p2))
plot(pol)

## 43. Polygon/Hole - Hole Self-overlap - interior

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,2), c(2,6), c(7,6), c(7,4.5), c(3,4.5)
            , c(3, 3), c(4.5, 3), c(4.5,7), c(6,7), c(6,2), c(2,2))

pol <-st_polygon(list(p1, p2))
plot(pol)

## 44.  Polygon/Hole - Hole Self-overlap - Spiral with Neg winding

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,2), c(2,7), c(7,7), c(7,2.5), c(2.5,2.5)
            , c(2.5, 6.5), c(6.5, 6.5), c(6.5,3), c(3,3), c(3,6), c(6,6),
            c(6,3.5), c(3.5,3.5), c(3.5,5.5), c(5.5,5.5), c(5.5,2), c(2,2))

pol <-st_polygon(list(p1, p2))
plot(pol)

## 45. Polygon/Hole - Hole Self-overlap - exterior

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,2), c(2,7), c(3.5,7), c(3.5,3.5), c(5,3.5)
            , c(5, 7), c(7, 7), c(7,6), c(3,6), c(3,5), c(7,5),
            c(7,2), c(2,2))

pol <-st_polygon(list(p1, p2))
plot(pol)

## 46. Polygon/Hole - Outside
# no idea

## 47. Polygon/Hole - Overlap
# no idea

## 48. Polygon/Hole - Equal

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))

pol <-st_polygon(list(p1, p2))
plot(pol)



## XX Polygon/Holes - Disconnected interior, point touch

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,4.5), c(4.5,7), c(7,4.5), c(4.5,2), c(6,5.5), 
            c(3, 5.5), c(4.5,2), c(2,4.5))

pol <-st_polygon(list(p1, p2))
plot(pol)

## XX+1 Polygon/Holes - Disconnected interior, point-line touch 

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(3,2), c(3,5), c(2,5), c(6,7), c(6,5), 
            c(7,6), c(7,3.5), c(4.5,3.5), c(6,5), c(3,5), c(6,2), c(3,2))

pol <-st_polygon(list(p1, p2))
plot(pol)