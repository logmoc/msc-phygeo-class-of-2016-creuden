# ------------- GRASS utility function for raster to point conversion
# (GRASS)   raster to vector points 
ras2vecpoiGRASS <- function(fNinput,retSP=FALSE){
  # (GRASS) import
  rgrass7::execGRASS('r.import',  
                     flags=c('o',"overwrite","quiet"),
                     input=fNinput,
                     output="rt_treeNodes",
                     band=1
  )
  # (GRASS) raster to vector
  rgrass7::execGRASS('r.to.vect',  
                     flags=c('s',"overwrite","quiet"),
                     input="rt_treeNodes",
                     output="rt_treeNodes",
                     type="point",
                     column="Z")
  # cluster identify clusters
  
  rgrass7::execGRASS('v.cluster',  
                     flags=c("overwrite","quiet"),
                     input="rt_treeNodes",
                     output="rt_cluster_trees",
                     method="density")
  
  rgrass7::execGRASS('v.out.ogr',  
                     flags = c("overwrite","quiet"),
                     input = "rt_cluster_trees",
                     output = paste0(pd_gi_run,"rt_cluster_trees.shp"),
                     format = "ESRI_Shapefile")
  # (GRASS) export
  rgrass7::execGRASS('v.out.ogr',  
                     flags = c("overwrite","quiet"),
                     input = "rt_treeNodes",
                     output = paste0(tools::file_path_sans_ext(fNinput),".shp"),
                     format = "ESRI_Shapefile")
  treesR <- rgdal::readOGR(pd_gi_run,basename(tools::file_path_sans_ext(fNinput)))
  if (retSP) return( treesR) 
}

