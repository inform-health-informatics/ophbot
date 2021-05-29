# Grab user name and password. I store my 'secrets' in an environment file that
# remains out of version control (.Renviron). You can see an example in
# 'example-config-files'. The .Renviron should be at the root of your project or
# in your 'home'.

emapR::udsConnect()

# Load current inpatient filter
# =============================
query <- readr::read_file('sql/query_current_inpatients.sql')
dtpts <- DBI::dbGetQuery(ctn, query)
setDT(dtpts)
dtpts[, c('ward', 'room', 'bed') := data.table::tstrsplit(location_string, split='\\^')]

# Extract numeric position of ward and bed
regexp <- "[[:digit:]]+"
dtpts[, wardi := as.numeric( str_extract(ward, regexp))]
dtpts[, bedi := as.numeric( str_nth_number(bed, n=2))]

# Note that hospital_visit_id is NOT unique
# perhaps exists in more than one place b/c of temporary locations
uniqueN(dtpts$hospital_visit_id) == nrow(dtpts)
# Let's first filter out key locations in the tower
dtpts <- dtpts[ward %in% wards]
assertthat::assert_that(uniqueN(dtpts$hospital_visit_id) == nrow(dtpts))

emapR::udsDisconnect()

