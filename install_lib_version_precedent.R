## petit script pour installer tous les packages d'un version précedente de R
# 30/04/2020
# il marche en prenant la version actuelle et demande l'ancienne version
# inspiration : https://community.rstudio.com/t/reinstalling-packages-on-new-version-of-r/7670/4

ancienne_version <- "4.1"  
chemins <- .libPaths() # trouver la liste des chemins

version <- format(as.numeric(R.Version()$major) + as.numeric(R.Version()$minor)/10, nsmall = 1) # on prend la version actuelle 

# on change le chemin actuel par l'ancien pour y chercher la list des packages
ancien_chemin <-  gsub(pattern = version, 
                       replacement =  ancienne_version, 
                       chemins[1]) # dans mon cas c'est le premier

to_install <- unname(installed.packages(lib.loc = ancien_chemin)[, "Package"])

install.packages(pkgs = to_install)

