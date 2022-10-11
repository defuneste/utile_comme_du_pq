# utile_comme_du_pq

This used to be a small repo with few files I needed to grab(yeah for french reader I created it when people were hoarding toilette papers ...) but I guess now it is more about checking geometries! 

The goal is to make a small shiny app that help myself (and maybe other see: https://github.com/Robinlovelace/geocompr/issues/811) understand how various algorithms and their implementations are used to correct non valid geometries. 

The source of inspirations started with this great post from Paul Ramsey (see: https://www.crunchydata.com/blog/waiting-for-postgis-3.2-st_makevalid and http://s3.cleverelephant.ca/invalid.html) about a new implementation of `MakeValid()` in postGIS. 

I tried to reproduce some of this post with R in `erreur_topo.R` but some are still missing.  
