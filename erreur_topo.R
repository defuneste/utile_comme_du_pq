# Date: 2022-09-08
# Author: Olivier Leroy  www.branchtwigleaf.com/
# Goal:
# Produce a set of topology errors to test tehm against classic 
# functions to correct them
# I elected to work with list because some topology errors require more than one
# polygon
# library used sf, sfheaders
# inspiration : 
# http://s3.cleverelephant.ca/invalid.html from P.Ramsey
# library used sf, sfheaders

library(sf)
library(sfheaders)

## 1.  usefull functions  ========================================================
### function to convert sfheaders to sf and plot it
quick_plot <- function(df){
    plot(sfheaders::sf_polygon(df))
} 

### scaling sfheader 
# used to decrease sized of already made polygons

scaling_sfheader <- function(df, scales = 0.8){
    df_sf = sfheaders::sf_polygon(df)
    df_centroid = sf::st_centroid(df_sf)
    df_scale = (df_sf - df_centroid) * scales + df_centroid
        return(st_coordinates(df_scale$geometry)[,1:2])
}

### convert polygon into sf with an id = char

transform_in_sf <- function(pol, char) {
    pol_sfc = sf::st_sfc(pol)
    pol_df = data.frame(id = char)
    pol_sf = sf::st_sf(pol_df, geometry = pol_sfc)
    return(pol_sf)
}

## 2. Creating a big list of error =============================================
# TODO maybe divide name into "family of errors"

##  1. Polygon - Exverted shell, point touch

df <- data.frame(
    x = c(1, 1, 4, 8, 8, 4, 1),
    y = c(1, 8, 6, 1, 8, 6, 1)
)

df1 <- sfheaders::sf_polygon(df)
df1$id <- "Polygon - Exverted shell, point touch"
errors <- list("Polygon - Exverted shell, point touch" = df1)

##  2. Polygon - Exverted shell, point-line touch

df <- data.frame(
    x = c(1, 1, 8, 8, 5, 1),
    y = c(1, 8, 8, 1, 8, 1)
)

## add to the list 

df2 <- sfheaders::sf_polygon(df)
df2$id <- "Polygon - Exverted shell, point-line touch"
errors[["Polygon - Exverted shell, point-line touch"]] <- df2

##  3. Polygon - Exverted shell, line touch

df <- data.frame(
    x = c(1, 1, 8, 8, 5, 3, 1),
    y = c(1, 8, 8, 1, 8, 8, 1)
)

df3 <- sfheaders::sf_polygon(df)
df3$id <- "Polygon - Exverted shell, line touch"
errors[[df3$id]] <- df3

## 4. Polygon - Inverted shell, point touch

df <- data.frame(
    x = c(1, 1, 4, 2, 6, 4, 8, 8, 1),
    y = c(1, 8, 8, 5, 5, 8, 8, 1, 1)
)

df_sf <- sfheaders::sf_polygon(df)
df_sf$id <- "Polygon - Inverted shell, point touch"
errors[[df_sf$id]] <- df_sf

## 5. Polygon - Inverted shell, point-line touch

df <- data.frame(
    x = c(1, 1, 3, 3, 7, 3, 8, 8, 1),
    y = c(1, 8, 8, 2, 2, 5, 5, 1, 1)
)

#quick_plot(df)

df_sf <- sfheaders::sf_polygon(df)
df_sf$id <- "Polygon - Inverted shell, point-line touch"
errors[[df_sf$id]] <- df_sf

## 6. Polygon - Inverted shell, line touch, exterior

df <- data.frame(
    x = c(1, 1, 6, 6, 3, 3, 8, 8, 1),
    y = c(1, 8, 8, 4, 4, 8, 8, 1, 1)
)

df_sf <- sfheaders::sf_polygon(df)
df_sf$id <- "Polygon - Inverted shell, line touch, exterior"
errors[[df_sf$id]] <- df_sf

## 7. Polygon - Inverted shell, line touch, interior

df <- data.frame(
    x = c(1, 1, 4.5, 4.5, 3,   6,   4.5, 4.5, 8, 8, 1  ),
    y = c(1, 8, 8,   6  , 3.5, 3.5, 6,   8, 8,  1, 1  )
)

df_sf <- sfheaders::sf_polygon(df)
df_sf$id <- "Polygon - Inverted shell, line touch, interior"
errors[[df_sf$id]] <- df_sf

## 8 polygon/hole Exverted hole, point touch  
# here I think I need sf 

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,2), c(2,6), c(4,5), c(6,2), c(6,6), c(4,5), c(2,2))
pol <-st_polygon(list(p1,p2))

pol_sf1 <- transform_in_sf(pol, "polygon/hole Exverted hole, point touch")
errors[[pol_sf1$id]] <- pol_sf1

## 9 Polygon/hole Exverted hole, point-line touch 

p2 <- rbind(c(2,2), c(2,6), c(6,6), c(6,2), c(4,6), c(2,2))
pol <-st_polygon(list(p1,p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/hole Exverted hole, point-line touch")
errors[[pol_sf1$id]] <- pol_sf1

## 10 Polygon/Hole Exverted hole, line touch

p2 <- rbind(c(2,2), c(2,6), c(3,5), c(4,5), c(6,6), c(6,2), c(4,5), c(3,5), c(2,2))
pol <-st_polygon(list(p1,p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole Exverted hole, line touch")
errors[[pol_sf1$id]] <- pol_sf1

## 11 Polygon/hole - Inverted hole, point touch 

inner <- data.frame(
    x = c(1, 1, 4, 2, 6, 4, 8, 8, 1),
    y = c(1, 8, 8, 5, 5, 8, 8, 1, 1)
)

# scaling 

p2 <- scaling_sfheader(inner)
pol <-st_polygon(list(p1,p2))
pol_sf1 <- transform_in_sf(pol, "Polygon/hole - Inverted hole, point touch")
errors[[pol_sf1$id]] <- pol_sf1

## 12 Polygon/Hole - Inverted hole, point-line touch

inner <- data.frame(
    x = c(1, 1, 3, 3, 7, 3, 8, 8, 1),
    y = c(1, 8, 8, 2, 2, 5, 5, 1, 1)
)

p2 <- scaling_sfheader(inner)
pol <-st_polygon(list(p1,p2))
pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Inverted hole, point-line touch")
errors[[pol_sf1$id]] <- pol_sf1

## 13. Polygon/Hole - Inverted hole, line touch, interior

inner <- data.frame(
    x = c(1, 1, 6, 6, 3, 3, 8, 8, 1),
    y = c(1, 8, 8, 4, 4, 8, 8, 1, 1)
)

p2 <- scaling_sfheader(inner)
pol <-st_polygon(list(p1,p2))
pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Inverted hole, line touch, interior")
errors[[pol_sf1$id]] <- pol_sf1

## 14. Polygon/Hole - Inverted hole, line touch, exterior 

p2 <- rbind(c(2,2), c(7, 2), c(4.5, 7), c(4.5, 5), c(3.5, 3.5), c(5.5, 3.5),
            c(4.5, 5), c(4.5, 7), c(2,2))
pol <-st_polygon(list(p1,p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Inverted hole, line touch, exterior")
errors[[pol_sf1$id]] <- pol_sf1

## 15. Polygon/Hole - Exverted shell, point touch; exverted hole, point touch

p1 <- rbind(c(1,1), c(1,8), c(8,1), c(8,8), c(1,1))
p2 <- rbind(c(2,3), c(2,6), c(7,3), c(7,6), c(2,3))
pol <-st_polygon(list(p1,p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Exverted shell, point touch; exverted hole, point touch")
errors[[pol_sf1$id]] <- pol_sf1

## 16. Polygon/Hole - Exverted shell, point touch; exverted hole, line touch 

p2 <- rbind(c(2,3), c(2,6), c(3.5, 4.5), c(5.5, 4.5)
            , c(7,3), c(7,6), 
            c(5.5, 4.5), c(3.5, 4.5),
            c(2,3))
pol <-st_polygon(list(p1,p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Exverted shell, point touch; exverted hole, line touch")
errors[[pol_sf1$id]] <- pol_sf1

## 17. Polygon/Hole - Exverted shell, line touch; exverted hole, line touch 

p1 <- rbind(c(1,1), c(1,8), c(3.5, 4.5), c(5.5, 4.5), c(8,1), c(8,8), 
            c(5.5, 4.5), c(3.5, 4.5),  c(1,1))
p2 <- rbind(c(2,3), c(2,6), c(3, 4.5), c(6, 4.5), c(7,3), c(7,6),
            c(6, 4.5), c(3, 4.5), c(2,3))
pol <-st_polygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Exverted shell, line touch; exverted hole, line touch")
errors[[pol_sf1$id]] <- pol_sf1

## 18. Polygon/Hole - Adjacent

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(5, 3), c(5,6), c(8,6), c(8, 3), c(5,3))
pol <-st_polygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Adjacent")
errors[[pol_sf1$id]] <- pol_sf1

## 19. Polygon/Holes - Adjacent holes

p2 <- rbind(c(3, 3), c(3,6), c(4.5,6), c(4.5, 3), c(3,3))
p3 <- rbind(c(4.5, 4), c(4.5, 5), c(5.5, 5), c(5.5, 4), c(4.5, 4))
pol <-st_polygon(list(p1, p2, p3))

pol_sf1 <- transform_in_sf(pol, "Polygon/Holes - Adjacent holes")
errors[[pol_sf1$id]] <- pol_sf1

## 20. Polygon/Holes - Exverted holes crossing at point 
# I think it is two inner rings but could be wrong
# I should check if middle point is needed 

p2 <- rbind(c(4, 7), c(5, 7), c(4.5, 4.5), c(4,2), c(5,2), c(4.5, 4.5),  c(4, 7))
p3 <- rbind(c(2, 4), c(2, 5),  c(4.5, 4.5), c(7, 4), c(7,5),  c(4.5, 4.5), c(2,4))
pol <-st_polygon(list(p1, p2, p3))

pol_sf1 <- transform_in_sf(pol, "Polygon/Holes - Exverted holes crossing at point")
errors[[pol_sf1$id]] <- pol_sf1

## 21. Polygon/Holes - Exverted holes crossing at line

p2 <- rbind(c(4, 7), c(5, 7),c(4.5, 6), c(4.5, 3), 
            c(4,2), c(5,2), c(4.5, 3), c(4.5, 6), c(4,7))
p3 <- rbind(c(2, 4), c(2, 5), c(3, 4.5), c(6, 4.5), 
            c(7, 4), c(7,5), c(6, 4.5),  c(3, 4.5), c(2,4))
pol <-st_polygon(list(p1, p2, p3))

pol_sf1 <- transform_in_sf(pol, "Polygon/Holes - Exverted holes crossing at line")
errors[[pol_sf1$id]] <- pol_sf1

## 22. Polygon - Zero area

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(1,8), c(1,1))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Polygon - Zero area")
errors[[pol_sf1$id]] <- pol_sf1

## 23. Polygon - Zero-width gore

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(4.5, 4.5), c(8,8), c(8,1), c(1,1))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Polygon - Zero-width gore")
errors[[pol_sf1$id]] <- pol_sf1

## 24. Polygon - Zero-width gore splitting

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(1, 1), c(8,8), c(8,1), c(1,1))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Polygon - Zero-width gore splitting")
errors[[pol_sf1$id]] <- pol_sf1

## 25. Polygon - Zero-width spike

p1 <- rbind(c(4,1), c(1,1), c(1,4), c(4,4), c(8, 8), c(4,4), c(4,1))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Polygon - Zero-width spike")
errors[[pol_sf1$id]] <- pol_sf1

## 26. Zero-width spike along boundary

p1 <- rbind(c(1,1), c(1,8), c(6,8), c(3,8), c(8,8), c(8,1), c(1,1))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Zero-width spike along boundary")
errors[[pol_sf1$id]] <- pol_sf1

## 27. Polygon/Hole - Zero-width spike splitting hole 

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(3,3), c(3, 6), c(6,6), c(6,3), c(5,3), c(3,5), c(5,3), c(3,3)) 
pol <-st_polygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Zero-width spike splitting hole")
errors[[pol_sf1$id]] <- pol_sf1

## 28. Polygon - Zero-width spike enclosing area
# unsure of this one 

p1 <- rbind(c(1,1), c(1,8), c(4,8), c(8,5), c(4,1), c(4,8), c(4,1), c(1,1))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Polygon - Zero-width spike enclosing area")
errors[[pol_sf1$id]] <- pol_sf1

## 29. MultiPolygon - Adjacent

df <- data.frame(
    id = c(1,1,1,1,2,2,2,2)
    , x = c(1,1,4,4,4,4,6,6)
    , y = c(1,8,8,1,3,6,6,3)
)
multipol <- sfheaders::sf_multipolygon(df, 
                            multipolygon_id = "id", 
                            polygon_id = "id",
                            linestring_id = "id")

df$id <- "MultiPolygon - Adjacent"
errors[["MultiPolygon - Adjacent"]] <- multipol

## 30. MultiPolygon - Exverted crossing at point

df <- data.frame(
     id = c(1,1,1  ,1,1, 2,2,2  ,2,2)
    , x = c(2,7,4.5,2,7, 2,2,4.5,7,7)
    , y = c(1,1,4.5,8,8, 2,7,4.5,2,7)
)
multipol <- sfheaders::sf_multipolygon(df, 
                                       multipolygon_id = "id", 
                                       polygon_id = "id",
                                       linestring_id = "id")

errors[["MultiPolygon - Exverted crossing at point"]] <- multipol

## 31. MultiPolygon - Exverted crossing at line 

df <- data.frame(
     id = c(1,   1,  1  ,1  , 1  ,1  ,1  ,1  ,2  ,2,2,2  ,2  ,2,2,2   )
    , x = c(3.5, 1,  1  ,3.5, 5.5,8  ,8  ,5.5,4.5,2,7,4.5,4.5,2,7,4.5   )
    , y = c(4.5, 1.5,7.5,4.5, 4.5,7.5,1.5,4.5,3.5,1,1,3.5,5.5,8,8,5.5   )
)
multipol <- sfheaders::sf_multipolygon(df, 
                                       multipolygon_id = "id", 
                                       polygon_id = "id",
                                       linestring_id = "id")

errors[["MultiPolygon - Exverted crossing at line"]] <- multipol


## 32. Polygon - Bowtie (Figure 8)

p1 <- rbind(c(1,1), c(1,8), c(8,1), c(8,8), c(1,1))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Polygon - Bowtie (Figure 8)")
errors[[pol_sf1$id]] <- pol_sf1


## 33. Polygon - Bowtie Multiple

p1 <- rbind(c(1,4), c(1,5), c(5,1), c(4,1), c(8,5), c(8,4), c(4,8), c(5,8), c(1,4))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Polygon - Bowtie Multiple")
errors[[pol_sf1$id]] <- pol_sf1

## 34. Polygon - Bowtie, self-overlap

p1 <- rbind(c(1,1.5), c(1,8), c(6,8), c(6,1), c(8,1), c(8,3), c(4,3)
            , c(4,2), c(6.5,2), c(6.5, 1.5), c(1, 1.5))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Polygon - Bowtie, self-overlap")
errors[[pol_sf1$id]] <- pol_sf1

## 35. Polygon - Self-overlap Multiple

p1 <- rbind(c(4,8), c(4,2), c(2,2), c(2,3), c(8,3), c(8,7), c(2.5,7)
            , c(2.5,2.5), c(3.5,2.5), c(3.5, 6), c(7, 6), c(7,4), c(1,4),
            c(1,1), c(5,1), c(5,8), c(4,8))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Polygon - Self-overlap Multiple")
errors[[pol_sf1$id]] <- pol_sf1

## 36. Polygon - Self-overlap; Pos and Neg winding

p1 <- rbind(c(1,1), c(8,1), c(8,7), c(3,7), c(3,5), c(7,5), c(7,3)
            , c(5,3), c(5,8), c(1, 8), c(1,1))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Polygon - Self-overlap; Pos and Neg winding")
errors[[pol_sf1$id]] <- pol_sf1

## 37. Polygon - Self-overlap; double Pos and single Neg winding 

p1 <- rbind(c(2,1), c(2,7), c(6,7), c(6,2), c(3,2), c(3,6), c(5,6)
            , c(5,3), c(8,3), c(8, 5), c(1,5), c(1,8),c(7,8), c(7,1), c(2,1))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Self-overlap; double Pos and single Neg winding")
errors[[pol_sf1$id]] <- pol_sf1

## 38. Polygon - Self-overlap - Pos and Neg winding 

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(6,1), c(3,3), c(7,6)
            , c(6,7.5), c(3.5, 5.5), c(5.5,5.5), c(3,7.5),c(2,6)
            , c(6,3), c(3,1),  c(1,1))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Polygon - Self-overlap - Pos and Neg winding")
errors[[pol_sf1$id]] <- pol_sf1

## 39. Polygon - Self-overlap; exterior

p1 <- rbind(c(1,1), c(1,3), c(7,3), c(7,6), c(1,6), c(1,8), c(3,8)
            , c(3,2), c(5,2), c(5, 8), c(8,8), c(8,1), c(1,1))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Polygon - Self-overlap; exterior")
errors[[pol_sf1$id]] <- pol_sf1

## 40. Polygon - Self-overlap; Spiral with Pos winding

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,2), c(2,2), c(2,7), c(7,7)
            , c(7,3), c(3,3), c(3, 6), c(6,6), c(6,4), c(4,4), c(4,5), c(5,5),
            c(5,1), c(1,1))
pol <-st_polygon(list(p1))

pol_sf1 <- transform_in_sf(pol, "Polygon - Self-overlap; Spiral with Pos winding")
errors[[pol_sf1$id]] <- pol_sf1

## 41. Polygon/Hole - Bowties 

p1 <- rbind(c(1,1), c(8,8), c(1,8), c(8,1), c(1,1))
p2 <- rbind(c(3,2), c(6,7), c(3,7), c(6,2), c(3,2))
pol <-st_polygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Bowties")
errors[[pol_sf1$id]] <- pol_sf1

## 42. Polygon/Hole - Bowties, overlap

p1 <- rbind(c(2,1), c(8,8), c(2,8), c(8,1), c(2,1))
p2 <- rbind(c(1,2), c(4.5,7), c(1,7), c(4.5,2), c(1,2))
pol <-st_polygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Bowties, overlap")
errors[[pol_sf1$id]] <- pol_sf1

## 43. Polygon/Hole - Hole Self-overlap - interior

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,2), c(2,6), c(7,6), c(7,4.5), c(3,4.5)
            , c(3, 3), c(4.5, 3), c(4.5,7), c(6,7), c(6,2), c(2,2))
pol <-st_polygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Hole Self-overlap - interior")
errors[[pol_sf1$id]] <- pol_sf1

## 44.  Polygon/Hole - Hole Self-overlap - Spiral with Neg winding

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,2), c(2,7), c(7,7), c(7,2.5), c(2.5,2.5)
            , c(2.5, 6.5), c(6.5, 6.5), c(6.5,3), c(3,3), c(3,6), c(6,6),
            c(6,3.5), c(3.5,3.5), c(3.5,5.5), c(5.5,5.5), c(5.5,2), c(2,2))
pol <-st_polygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Hole Self-overlap - Spiral with Neg winding")
errors[[pol_sf1$id]] <- pol_sf1

## 45. Polygon/Hole - Hole Self-overlap - exterior

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,2), c(2,7), c(3.5,7), c(3.5,3.5), c(5,3.5)
            , c(5, 7), c(7, 7), c(7,6), c(3,6), c(3,5), c(7,5),
            c(7,2), c(2,2))
pol <-st_polygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Hole Self-overlap - exterior")
errors[[pol_sf1$id]] <- pol_sf1

## XX. Polygon/Hole - Outside
# no idea

## XX. Polygon/Hole - Overlap
# no idea

## 46. Polygon/Hole - Equal

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
pol <-st_polygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Equal")
errors[[pol_sf1$id]] <- pol_sf1

##. Polygon/Hole - Disconnected interior
# no idea

## 47. Polygon/Hole - Collapsed shell 

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(1,8), c(1,1))
p2 <- rbind(c(2,4), c(2,6), c(4,6), c(4,4), c(2,4))
pol <-st_polygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Collapsed shell")
errors[[pol_sf1$id]] <- pol_sf1

## 48. Polygon/Hole - Collapsed hole

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,4), c(2,6), c(4,6), c(2,6), c(2,4))
pol <-st_polygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Hole - Collapsed hole")
errors[[pol_sf1$id]] <- pol_sf1

## 49. Polygon/Holes - Overlap

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,2), c(2,6), c(6,6), c(6,2), c(2,2))
p3 <- rbind(c(3,3), c(3,7), c(7,7), c(7,3), c(3,3))
pol <-st_polygon(list(p1, p2, p3))

pol_sf1 <- transform_in_sf(pol, "Polygon/Holes - Overlap")
errors[[pol_sf1$id]] <- pol_sf1

## 50. Polygon/Holes - Cover Exactly 

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(1,1), c(1,4.5), c(4.5,4.5), c(4.5,1), c(1,1))
p3 <- rbind(c(1,4.5), c(1,8), c(4.5,8), c(4.5,4.5), c(1,4.5))
p4 <- rbind(c(4.5,4.5), c(4.5,8), c(8,8), c(8,4.5), c(4.5,4.5))
p5 <- rbind(c(4.5,1), c(4.5,4.5), c(8,4.5), c(8,1), c(4.5,1))
pol <-st_polygon(list(p1, p2, p3, p4, p5))

pol_sf1 <- transform_in_sf(pol, "Polygon/Holes - Cover Exactly")
errors[[pol_sf1$id]] <- pol_sf1

## 51. Polygon/Holes - Nested 

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,2), c(2,7), c(7,7), c(7,2), c(2,2))
p3 <- rbind(c(3,3), c(3,6), c(6,6), c(6,3), c(3,3))
pol <-st_polygon(list(p1, p2, p3))

pol_sf1 <- transform_in_sf(pol, "Polygon/Holes - Nested")
errors[[pol_sf1$id]] <- pol_sf1

## 52. Polygon/Holes - Disconnected interior, point touch

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,4.5), c(4.5,7), c(7,4.5), c(4.5,2), c(6,5.5), 
            c(3, 5.5), c(4.5,2), c(2,4.5))
pol <-st_polygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "Polygon/Holes - Disconnected interior, point touch")
errors[[pol_sf1$id]] <- pol_sf1

## 53. Polygon/Holes - Disconnected interior, point-line touch 

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,5), c(6,7), c(6,5), c(2,5)) 
p3 <- rbind(c(3,5), c(3,2), c(6,2), c(3,5))
p4 <- rbind(c(7,6), c(7,3.5), c(4.5,3.5), c(7,6))
pol <-st_polygon(list(p1, p2, p3, p4))

pol_sf1 <- transform_in_sf(pol, "Polygon/Holes - Disconnected interior, point-line touch")
errors[[pol_sf1$id]] <- pol_sf1

## 54. Polygon/Holes - Disconnected interior, line touch

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,2), c(2,7), c(4.5,4.5), c(4.5,2), c(2,2)) 
p3 <- rbind(c(4.5,2), c(4.5,4.5), c(7,7), c(7,2), c(4.5,2))
p4 <- rbind(c(2,7), c(4.5,7.5), c(7,7), c(6,6), c(3,6), c(2,7))
pol <-st_polygon(list(p1, p2, p3, p4))

pol_sf1 <- transform_in_sf(pol, "Polygon/Holes - Disconnected interior, line touch")
errors[[pol_sf1$id]] <- pol_sf1

## 55. Polygon/Holes - Disconnected interior, overlapping bowtie holes

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2,2), c(6,2), c(2,7), c(6,7), c(2,2)) 
p3 <- rbind(c(4,3), c(7,3), c(4,6), c(7,6), c(4,3))
pol <-st_polygon(list(p1, p2, p3))

pol_sf1 <- transform_in_sf(pol, "Polygon/Holes - Disconnected interior, overlapping bowtie holes")
errors[[pol_sf1$id]] <- pol_sf1

## 56. Polygon/Holes - Disconnected interior, overlapping zero-area holes 

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(3,2), c(3,6), c(7,6), c(3,6), c(3,2)) 
p3 <- rbind(c(2,3), c(6,3), c(6,7), c(6,3), c(2,3))
pol <-st_polygon(list(p1, p2, p3))

pol_sf1 <- transform_in_sf(pol, "Polygon/Holes - Disconnected interior, overlapping zero-area holes")
errors[[pol_sf1$id]] <- pol_sf1
            
## 57. Polygon/Holes - Disconnected interior, overlapping holes

p1 <- rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1))
p2 <- rbind(c(2.5,1.5), c(2.5,6.5), c(7,6.5), c(7,6), c(3,6), c(3,1.5), c(2.5, 1.5)) 
p3 <- rbind(c(2,2), c(6.5,2), c(6.5,7), c(6,7), c(6,2.5), c(2, 2.5), c(2,2))
pol <-st_polygon(list(p1, p2, p3))

pol_sf1 <- transform_in_sf(pol, "Polygon/Holes - Disconnected interior, overlapping holes")
errors[[pol_sf1$id]] <- pol_sf1

## 58. MultiPolygon - Nested Polygons

p1 <- list(rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1)))
p2 <- list(rbind(c(3,3), c(3,6), c(6,6), c(6,3), c(3,3))) 
pol <-st_multipolygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "MultiPolygon - Nested Polygons")
errors[[pol_sf1$id]] <- pol_sf1

## 59. MultiPolygon - Multiple Nested Polygons
# not sure it can be well display
# check also the sfg object

p1 <- list(rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1)))
p2 <- list(rbind(c(3,3), c(3,6), c(6,6), c(6,3), c(3,3))) 
p3 <- list(rbind(c(2,2), c(2,7), c(7,7), c(7,2), c(2,2)))
pol <-st_multipolygon(list(p1, p2, p3))

pol_sf1 <- transform_in_sf(pol, "MultiPolygon - Multiple Nested Polygons")
errors[[pol_sf1$id]] <- pol_sf1

## 60. MultiPolygon - Overlapping Polygons

p1 <- list(rbind(c(1,1), c(1,8), c(5,8), c(5,1), c(1,1)))
p2 <- list(rbind(c(3,2), c(3,7), c(7,7), c(7,2), c(3,2))) 
pol <-st_multipolygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "MultiPolygon - Overlapping Polygons")
errors[[pol_sf1$id]] <- pol_sf1

## 61. MultiPolygon - Multiple Overlapping Polygons

p1 <- list(rbind(c(1,1), c(1,6), c(6,6), c(6,1), c(1,1)))
p2 <- lapply(p1, function(x) x + 1 )
p3 <- lapply(p1, function(x) x + 2 )
pol <-st_multipolygon(list(p1, p2, p3))

pol_sf1 <- transform_in_sf(pol, "MultiPolygon - Multiple Overlapping Polygons")
errors[[pol_sf1$id]] <- pol_sf1

## 62. MultiPolygon - Multiple Overlapping Polygons (5) 

p1 <- list(rbind(c(1,2), c(1,7), c(3,7), c(3,2), c(1,2)))
p2 <- list(rbind(c(5,2), c(5,7), c(7,7), c(7,2), c(5,2)))
p3 <- list(rbind(c(2,6), c(2,8), c(6,8), c(6,6), c(2,6)))
p4 <- list(rbind(c(2,1), c(2,3), c(6,3), c(6,1), c(2,1)))
p5 <- list(rbind(c(2.5,2.5), c(2.5,6.5), c(5.5,6.5), c(5.5,2.5), c(2.5,2.5)))
pol <-st_multipolygon(list(p1, p2, p3, p4, p5))

pol_sf1 <- transform_in_sf(pol, "MultiPolygon - Multiple Overlapping Polygons (5)")
errors[[pol_sf1$id]] <- pol_sf1

## 63. MultiPolygon - Polygon/Hole-overlap overlaps Polygon covering hole 
# unsure if correct

p1 <- list(rbind(c(1,1), c(1,8), c(5,8), c(5,1), c(1,1)))
p2_holes <- rbind(c(4,3), c(4,6), c(6,6), c(6,3), c(4,3))
p2 <- list(rbind(c(3,2), c(3,7), c(7,7), c(7,2), c(3,2)), p2_holes) 
pol <-st_multipolygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "MultiPolygon - Polygon/Hole-overlap overlaps Polygon covering hole")
errors[[pol_sf1$id]] <- pol_sf1

## XX. MultiPolygon - Polygon/Hole-overlap overlaps Polygon inside hole
# no idea

## 64. MultiPolygon - Polygon/Hole-overlap hole overlaps Polygon
# unsure

p1 <- list(rbind(c(1,2), c(1,7), c(3,7), c(3,2), c(1,2)))
p2 <- list(rbind(c(5,2), c(5,7), c(7,7), c(7,2), c(5,2)))
t3 <- rbind(c(2,3), c(2,6), c(6,6), c(6,3), c(2,3))
p3 <- list(t3,t3)
pol <-st_multipolygon(list(p1, p2,p3))

pol_sf1 <- transform_in_sf(pol, "MultiPolygon - Polygon/Hole-overlap hole overlaps Polygon")
errors[[pol_sf1$id]] <- pol_sf1

## 65. MultiPolygon - Polygon overlaps Polygon/Hole 
# unsure

p1 <- list(rbind(c(1,1), c(1,8), c(5,8), c(5,1), c(1,1)))
p2_holes <- rbind(c(4,3), c(4,6), c(6,6), c(6,3), c(4,3))
p2 <- list(rbind(c(3,2), c(3,7), c(7,7), c(7,2), c(3,2)), p2_holes) 
p3 <- list(p2_holes)
pol <-st_multipolygon(list(p1, p2,p3))

pol_sf1 <- transform_in_sf(pol, "MultiPolygon - Polygon overlaps Polygon/Hole")
errors[[pol_sf1$id]] <- pol_sf1

## XX. MultiPolygon - Polygon/Hole-overlap overlaps Polygon
# out of idea

## 66. MultiPolygon - Polygon partially fills Polygon/Hole

p1_holes <- rbind(c(3,2), c(3,7), c(6,7), c(6,2), c(3,2))
p1 <- list(rbind(c(1,1), c(1,8), c(8,8), c(8,1), c(1,1)), p1_holes)
p2 <- list(rbind(c(3,3), c(3,6), c(6,6),c(6,3), c(3,3)))
pol <-st_multipolygon(list(p1, p2))

pol_sf1 <- transform_in_sf(pol, "MultiPolygon - Polygon partially fills Polygon/Hole")
errors[[pol_sf1$id]] <- pol_sf1

## XX. MultiPolygon - Grid of adjacent Polygons
## no idea

## XX. MultiPolygon - Ring of adjacent Polygons 
#no idea