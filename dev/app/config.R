debug <- FALSE
if (debug) rlang::inform('!!! debug mode ON')

# *************
# Configuration
# *************

llabel <- 'Pulse'
wwindow <- -72

# Input schema 
input_schema <- 'star'

# Output schema
target_schema <- 'icu_audit'
target_table <- 'vitals_tower_predictor'
target_table_path <- DBI::Id(schema=target_schema, table=target_table)

# Wards of interest
wards <- c(
   'T01'
  ,'T01ECU'
  ,'T03'
  ,'T06C'
  ,'T06G'
  ,'T06H'
  ,'T07'
  ,'T07CV'
  ,'T08N'
  ,'T08S'
  ,'T09N'
  ,'T09S'
  ,'T10O'
  ,'T10S'
  ,'T11D'
  ,'T11E'
  ,'T11N'
  ,'T11S'
  ,'T12N'
  ,'T12S'
  ,'T13N'
  ,'T13S'
  ,'T14N'
  ,'T14S'
  ,'T16N'
  ,'T16S'
  ,'TYAAC'
  ,'HS15'
)

# set up vitals labels
vitals_dict <- dict()
vitals_dict$set('10', 'SpO2')
vitals_dict$set('5', 'BP')
vitals_dict$set('6', 'Temp')
vitals_dict$set('8', 'Pulse')
vitals_dict$set('9', 'Resp')
vitals_dict$set('28315', 'NEWS - SpO2 scale 1')
vitals_dict$set('28316', 'NEWS - SpO2 scale 2')
vitals_dict$set('3040109304', 'Room Air or Oxygen')
vitals_dict$set('6466', 'Level of consciousness')
vitals_dict$as_list()
vitals_dict$keys()
