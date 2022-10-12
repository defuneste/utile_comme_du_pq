# utile_comme_du_pq

This used to be a small repo with few files I needed to grab(yeah for french reader I created it when people were hoarding toilette papers ...) but I guess now it is more about checking geometries! 

The goal is to make a small shiny app that help myself (and maybe other see: https://github.com/Robinlovelace/geocompr/issues/811) understand how various algorithms and their implementations are used to correct non valid geometries. 

The source of inspirations started with this great post from Paul Ramsey (see: https://www.crunchydata.com/blog/waiting-for-postgis-3.2-st_makevalid and http://s3.cleverelephant.ca/invalid.html) about a new implementation of `MakeValid()` in postGIS. 

I tried to reproduce some of this post with R in `erreur_topo.R` but some are still missing.  

## Tools used to correct geometries

### polyclip 

Github: https://github.com/baddstats/polyclip

It use clipper: http://angusj.com/clipper2/Docs/Overview.htm (v1 or v2?) 

Implementation in {spatstat} is in the `owin` [function:]( https://github.com/spatstat/spatstat.geom/blob/d90441de5ce18aeab1767d11d4da3e3914e49bc7/R/window.R#L230-L240)

`polyclip` works on **closed polygon** and take as input a list of x and y but the last vertex should not repeat the first (as in simple feature standard). It can also take a list of list for several polygons (see: `?polyclip::polyclip`). Polygon `B` is created in the `spatstat.geom::owin` as a larger rectangle.

My implementation seems not to be perfect as converting to polyclip object to sf maybe bring some errors

### prepr

> Automatically repair broken GIS polygons using constrained triangulation and returns back a valid polygon.

it can be find here : https://gitlab.com/dickoa/prepr

or https://github.com/dickoa/prepr

More about here : 

Ledoux, H., Arroyo Ohori, K., and Meijers, M. (2014). A triangulation-based approach to automatically repair GIS polygons. Computers & Geosciences 66:121–131.



