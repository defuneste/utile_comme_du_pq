# Utile Comme du PQ

This used to be a small repo with few files I needed to grab(yeah for french reader I created it when people were hoarding toilette papers...) but I guess now it is more about checking polygons geometries! 
The goal is to make a small shiny app that help myself (and maybe other see: https://github.com/Robinlovelace/geocompr/issues/811) understand how various algorithms and their implementations are used to correct non valid geometries.

The source of inspirations started with this great post from Paul Ramsey (see: https://www.crunchydata.com/blog/waiting-for-postgis-3.2-st_makevalid and http://s3.cleverelephant.ca/invalid.html) about a new implementation of `MakeValid()` in postGIS. 

I tried to reproduce some of this post with R in `erreur_topo.R` but some are still missing. 

## What is a valid polygons ?

First I should clarified what is a valid polygons: 

> Polygons have the concept of *validity*. The rings of a valid polygon may only intersect at distinct points -- rings can't overlap, and they can't share a common boundary. A polygon whose inner rings partly lie outside its exterior ring is also invalid  (p.38 [PosGIS in Action][1])  

This is specified by the [Simple Features][2] set of standard

## List of tools that can be used 

- GEOS: https://libgeos.org/doxygen/geos__c_8h.html#acb2987c643bda31b1fcaecff8b62ce98  
- GRASS with V.clean : https://grass.osgeo.org/grass82/manuals/v.clean.html
    * See: https://github.com/rsbivand/rgrass
    
## Tools inplemeted to correct geometries

### sf::st_buffer(x, m)

A great way of "cleaning some mess" but sometimes it feels like we are hammering stuff! 

### [{terra}][3] and [{sf}][4]

Both have implementation of [GEOS](https://libgeos.org/) but {sf} can also use s2. The engine use in {sf} depend of your version of GEOS (currently mine is 3.10) and if you are using planar or spherical geometry.   

- `terra::makeValid()` : https://rspatial.github.io/terra/reference/isvalid.html

- `sf::st_make_valid()` : https://r-spatial.github.io/sf/reference/valid.html

Both implementation have the option to provide you with more insight  (see `reasons` in `st_make_valid` and `messages` in `makeValid()`).

### [{polyclip}][5] 

Github: https://github.com/baddstats/polyclip

It use clipper: http://angusj.com/clipper2/Docs/Overview.htm (v1 now but maybe v2 at one point) 

Implementation in {spatstat} is in the `owin` [function:]( https://github.com/spatstat/spatstat.geom/blob/d90441de5ce18aeab1767d11d4da3e3914e49bc7/R/window.R#L230-L240)

`polyclip` works on **closed polygon** and take as input a list of x and y but the last vertex should not repeat the first (as in simple feature standard). It can also take a list of list for several polygons (see: `?polyclip::polyclip`). Polygon `B` is created in the `spatstat.geom::owin` as a larger rectangle.

My implementation seems not to be perfect as converting to polyclip object to sf's class maybe bring some errors.

### [{prepr}][6]

> Automatically repair broken GIS polygons using constrained triangulation and returns back a valid polygon.

it can be find here : https://gitlab.com/dickoa/prepr

or https://github.com/dickoa/prepr

More about here : 

Ledoux, H., Arroyo Ohori, K., and Meijers, M. (2014). A triangulation-based approach to automatically repair GIS polygons. Computers & Geosciences 66:121–131.


## References:

[1] PostGIS in Action, Third Edition,   
[2] https://en.wikipedia.org/wiki/Simple_Features
[3] Hijmans R (2022). _terra: Spatial Data Analysis_. R package version 1.6-17,
  <https://CRAN.R-project.org/package=terra>.  
[4] Pebesma, E., 2018. Simple Features for R: Standardized Support for Spatial Vector Data. The R
  Journal 10 (1), 439-446, https://doi.org/10.32614/RJ-2018-009  
[5] Johnson A, Baddeley A (2019). _polyclip: Polygon Clipping_. R package version 1.10-0,
  <https://CRAN.R-project.org/package=polyclip>.  
[6] Dicko A (2020). _prepr: Automatic Repair of Single Polygons_. R package version 0.1.9000,
  <https://gitlab.com/dickoa/prepr>.
  
