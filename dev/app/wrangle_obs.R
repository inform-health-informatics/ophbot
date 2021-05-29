# Grab user name and password. I store my 'secrets' in an environment file that
# remains out of version control (.Renviron). You can see an example in
# 'example-config-files'. The .Renviron should be at the root of your project or
# in your 'home'.

emapR::udsConnect()

# Load recent vitals
# ==================
query <- readr::read_file('sql/query_recent_inpatient_vitals.sql')
dtobs <- DBI::dbGetQuery(ctn, query)
setDT(dtobs)


emapR::udsDisconnect()
