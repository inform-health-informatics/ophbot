# Load libraries and configuration

# 2021-05-29
# manual install since renv does not work on DS Desktop
# TODO: automatically detect environment 
datascience_desktop_install <- FALSE

if (datascience_desktop_install) {
  install.packages('strex')
  install.packages('rms')
  install.packages('lme4')
  install.packages('broom.mixed')
  install.packages('collections')
  install.packages('checkmate')
}

# Libraries
# =========

# CRAN
library(tidyverse)
library(strex)
library(lubridate)
library(rms)
library(Hmisc)
library(lme4)
library(broom.mixed)
library(collections)
library(checkmate)
library(data.table)

# Github
library(emapR) # see setup.R for installation

