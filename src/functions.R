# Date: 2022-09-08
# Author: Olivier Leroy  www.branchtwigleaf.com/
# Goal:
# Produce a set of topology errors to test them against classic 
# functions to correct them
# I elected to work with list because some topology errors require more than one
# polygon
# library used sf, sfheaders
# inspiration : 
# http://s3.cleverelephant.ca/invalid.html from P.Ramsey
# library used sf, sfheaders
# errors are produced in erreur_topo.R

library(sf)
library(sfheaders)

## 1.  usefull functions  ======================================================
### function to convert sfheaders to sf and plot it
# TODO reorganize a bit function to get geometry vs functions to correct them
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

### extract the first word 
# here just split everywhite space and take the first

extract_first_word <- function(some_text) {
    unlist(
        strsplit(some_text, " - ")
    )[1]
}

### getting point of a polygon to get the vertex and 
## see potential simplification

st_cast_pt_no_error <- function(geom) {
    sf::st_cast(geom, "POINT", warn = FALSE)
    }

## convert sf to terra to use terra::makeValid() 
# then sf just to use same plot method

testing_terra_makevalid <- function(geom) {
                                terra::vect(geom) |>
                                terra::makeValid() |>
                                sf::st_as_sf()
                                }

## convert to list of x,y to use polyclip 
# I have an error with polyclip when I convert back to sf using sfheader

testing_polyclip_polyclip <- function(geom) {
    # convert to polyclip format
    sfheader_obj <- sfheaders::sf_to_df(geom)
    sfheader_obj <- sfheader_obj[1:nrow(sfheader_obj) - 1,]
    list_of_x_y <- list(x = sfheader_obj$x, y = sfheader_obj$y)
    # use of a part of spatstat : 
    # https://github.com/spatstat/spatstat.geom/blob/d90441de5ce18aeab1767d11d4da3e3914e49bc7/R/window.R#L230-L240
    xrange <- range(list_of_x_y$x)
    yrange <- range(list_of_x_y$y)
    xrplus <- mean(xrange) + c(-1,1) * diff(xrange)
    yrplus <- mean(yrange) + c(-1,1) * diff(yrange)
    # this tricks ..
    bignum <- (.Machine$integer.max^2)/2
    epsclip <- max(diff(xrange), diff(yrange))/bignum
    # getting poly B in right order and polyclip format
    poly_b <- list(list(x=xrplus[c(1,2,2,1)], y=yrplus[c(2,2,1,1)]))
    
    bb <- polyclip::polyclip(list_of_x_y, 
                             poly_b, 
                             "intersection",
                             fillA="nonzero", 
                             fillB="nonzero", 
                             eps=epsclip)
    # back to sf 
    list_of_sf <- lapply(bb, as.data.frame) |> 
        lapply(sfheaders::sf_polygon) 
    do.call(rbind, list_of_sf)
}


## using pprepr
# pprepr::st_pprepair(errors[[1]])
           
## doing a plot 

#using RColorBrewer
a_quick_palette <- c("#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3", "#A6D854")

plot_my_result <- function(geom, title = "some_text"){
    plot(geom$geometry, col = a_quick_palette, main = title)
    plot(st_cast_pt_no_error(geom)$geometry, 
         col = 2, pch = 15, cex = 2,
        add = TRUE)
    }
