# rs-ws-04-1
# MOC - Advanced GIS/Remote Sensing/Data Analysis (T. Nauss, C. Reudenbach)
#'
#' setPathGlobal
#'@return 
#' defines and creates (if necessary) all folders variables
#' set the SAGA path variables and other system variables
#' exports all variables to the global environment
#'
#'@param filepath_git  project github root directory (your github name)
#'@param csess= current session "01",
#'@param ccourse current course options are "gi", "rs", "da"
#'@param moc=TRUE creates a folder structure according to the needs of the MOC courses, FALSE creates a simple project structure
#'\preformatted{
#'   If moc=TRUE the following folderstructure is exported. If folders do not exist thesy will be created.
#'.
#'├── data
#'│   ├── data_analysis
#'│   │   ├── csv
#'│   │   └── raw
#'│   ├── gis
#'│   │   ├── input
#'│   │   ├── output
#'│   │   ├── RData
#'│   │   ├── run
#'│   │   └── temp
#'│   └── remote_sensing
#'│       ├── aerial
#'│       ├── aerial_croped
#'│       ├── aerial_merged
#'│       ├── input
#'│       ├── RData
#'│       ├── run
#'│       └── temp
#'└── MOC
#'    ├── data_analysis
#'    │   └── da-ws-01
#'    │       └── rmds
#'    │       └── scripts
#'    ├── fun
#'    ├── gis
#'    │   └── gi-ws-01
#'    │       └── rmds
#'    │       └── scripts
#'    └── remote_sensing
#'        └── rs-ws-01
#'    │       └── rmds
#'            └── scripts
#'
#' 
#' ############
#' 
#' if moc=FALSE
#' .
#' └── project1
#'     ├── control
#'     │   └── log
#'     ├── data
#'     │   ├── input
#'     │   └── output
#'     ├── run
#'     └── src
#'         └── fun
#'   } 
#'
#'@author Thomas Nauss, Chris Reudenbach
#'
#'@return  setPathGlobal< creates if necessary the directories and export the corresponding pathes as global variables\cr

setPathGlobal<- function(filepath_git,csess=15,ccourse="gi", moc=TRUE) {
  
  # switch backslash to slash and expand path to full path
  filepath_git<-gsub("\\\\", "/", path.expand(filepath_git))  
  
  # check  tailing / and if not existing append
  if (substr(filepath_git,nchar(filepath_git)-1,nchar(filepath_git)) != "/") {
    filepath_git<-paste0(filepath_git,"/")
  }
  
  ### moc = FALSE feel free to adapt 
  default_folders<- c(paste0(filepath_git,"src/"),
                      paste0(filepath_git,"src/fun/"),
                      paste0(filepath_git,"data/input/"),
                      paste0(filepath_git,"data/output/"),
                      paste0(filepath_git,"control/log/"),
                      paste0(filepath_git,"run/"))
  
  ### moc=TRUE
  # script and function folder for each course session can be adapted 
  session_working_folder<-c("/scripts/", "/rmds/")
  # currently implemented data folders can be adapted 
  data_working_folder<-list(list("aerial/","aerial_merged/","aerial_croped/","RData/","temp/","run/","input/"),
                            list("RData/","temp/","run/","input/","output/"),
                            list("csv/","raw/"))  
  
  if (moc) {
    # static course structure - better keep the below folders
    proj_root_git<-c(path.expand(filepath_git))
    proj_root_data<-paste0(substr(proj_root_git,1,gregexpr(pattern ='/',proj_root_git)[[1]][as.numeric(lengths(gregexpr(pattern ='/',proj_root_git))[[1]]-2)]),"data/")
    sub_root<-c("remote_sensing/","gis/","data_analysis/")
    session_ID<-c("rs-ws-","gi-ws-","da-ws-")
    
    # create sessionstring
    ns<-1:csess
    session_number<- sapply(ns, function(ns){
      if (ns<10) {ns<-paste0("0",ns)}
      return(ns)
    })
    
    # create folder and varibales 
    # function folder for all courses
    name<-paste0("pgit_fun")
    value<-paste0(filepath_git,"/fun/")
     makGlobalVar(name, value)
    # and the rest
    if (!file.exists(file.path(paste0(filepath_git,"/fun/")))) {
      dir.create(file.path(paste0(filepath_git,"/fun/")), recursive = TRUE)
    }  
    for (i in 1:length(proj_root_git)) {
      for (j in 1:length(sub_root)) {
        for (k in 1:length(session_ID)) {
          for (l in 1:length(session_number)) {
            for (m in 1:length(session_working_folder)) {
              name<-paste0("pg_", substr(session_ID[j],1,2),"_",as.character(gsub("/", "", session_number[l])),"_",as.character(gsub("/", "",session_working_folder[m])))
              value<- paste0(proj_root_git[i],sub_root[j],session_ID[j],session_number[l],session_working_folder[m])
               makGlobalVar(name, value)
              if (!file.exists(file.path(paste0(proj_root_git[i],sub_root[j],session_ID[j],session_number[l],session_working_folder[m])))) {
                dir.create(file.path(paste0(proj_root_git[i],sub_root[j],session_ID[j],session_number[l],session_working_folder[m])), recursive = TRUE)
              }
            }
          }
        }
      }
    }
    
    # data structure NOTE it is outside the proj_root_git folder
    for (i in 1:length(proj_root_data)){
      for (j in 1:length(sub_root)) {
        for (k in 1:length(data_working_folder[[j]])) {
          name<-paste0("pd_",substr(session_ID[j],1,2),"_",as.character(gsub("/", "",data_working_folder[[j]][k])))
          value<- paste0(proj_root_data[i],sub_root[j],data_working_folder[[j]][k])
           makGlobalVar(name, value)
          if (ccourse==substr(session_ID[j],1,2) && data_working_folder[[j]][k]=="run/"){
            path_temp<- value
          }
          if (!file.exists(file.path(paste0(proj_root_data[i],sub_root[j],data_working_folder[[j]][k])))) {
            dir.create(file.path(paste0(proj_root_data[i],sub_root[j],data_working_folder[[j]][k])), recursive = TRUE)
            
          }
        }
      }
    }
  } # end of moc=TRUE
  # create a default project structure
  else {
    # create directories if needed
    path_temp<-paste0(filepath_git,"run/")
    for(folder in default_folders){
      name<-paste0("p",as.character(gsub("/", "_",substr(folder,nchar(filepath_git),nchar(folder)-1))))
       makGlobalVar(name, folder)
      if (!file.exists(file.path(folder))) {
        dir.create(file.path(folder), recursive = TRUE)
      }
    }
  }
  
  # set rasteroptions to working directory
  raster::rasterOptions(tmpdir = path.expand(path_temp))
  
  # setting R environ temp folder to the current working directory
  Sys.setenv(TMPDIR = file.path(path_temp))
  
  # set R working directory
  setwd(file.path(path_temp))
  
}
