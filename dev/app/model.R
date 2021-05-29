
# Modelling proof of principle
# https://m-clark.github.io/R-models/

model_vars <- c('tt', 'y', 'mrn')
nonmodel_vars <- setdiff(names(mdt), model_vars)
timeconstant_vars <- c('mrn', 'ward', 'room', 'wardi', 'bed', 'bedi', 'label' )

# try rescaling
summary(mdt$y)
mdt[, y_scaled := (y - mean(y, na.rm=TRUE))/ (2*sd(y, na.rm=TRUE))]
mdt[, tt_scaled := (tt - mean(tt, na.rm=TRUE))/ (2*sd(tt, na.rm=TRUE))]
# ggplot(mdt, aes(y,y_scaled)) + geom_jitter()
 
# model
###################################################
mdt <- na.exclude(mdt)
mmix <- lmer(y_scaled ~ tt_scaled + (1+rcs(tt_scaled, 3)|mrn), data=mdt)
###################################################

# Use augment to rapidly build in sample predictions
rdt <- augment(mmix)
rdt

# scale back
rdt$yhat <- mean(mdt$y, na.rm=TRUE) + (rdt$.fitted * (2* sd(mdt$y, na.rm=TRUE)))
rdt$tt <- mean(mdt$tt, na.rm=TRUE) + (rdt$tt_scaled * (2* sd(mdt$tt, na.rm=TRUE)))
rdt %>% select(.fitted, tt, yhat)

sdt <- tibble(mdt[,c(nonmodel_vars, 'y'),with=FALSE])
sdt <- bind_cols(sdt,rdt)
sdt <- sdt %>% select(c(nonmodel_vars, model_vars, yhat, tt_scaled))
setDT(sdt)
sdt

# build predictions out of sample (i.e for the last x hours)
new_data <- data.table(expand.grid(tt=wwindow:0, mrn=unique(sdt$mrn), label=llabel, new_data=TRUE))
new_data[, tt_scaled := (tt - mean(mdt$tt, na.rm=TRUE))/ (2*sd(mdt$tt, na.rm=TRUE))]
pdt <- data.table(yhat=predict(mmix, new_data))
pdt$yhat <- mean(mdt$y, na.rm=TRUE) + (pdt$yhat * (2* sd(mdt$y, na.rm=TRUE)))

pdt <- bind_cols(pdt,new_data)
udt <- unique(sdt[,timeconstant_vars, with=FALSE])
udt <- udt[pdt, on=c('mrn==mrn', 'label==label')]
mdt <- rbindlist(list(sdt,udt),fill=TRUE)
mdt[is.na(new_data), new_data := FALSE]
mdt[new_data==TRUE, observation_datetime := now() + dhours(tt) ]

# Thinking about recency # variable ordering
# mdt[order(-observation_datetime), ti := seq_len(.N), by=.(mrn, label) ]
# flag vitals that have not been measured for some time
setorder(mdt,mrn,label,-tt) # for the side effect of sorting
mdt[new_data==FALSE, ti := seq_len(.N), by=.(mrn,label)]
mdt[new_data==FALSE, tlast := -1 * max(tt), by=.(mrn,label)]
mdt[new_data==TRUE, tlast := NA]
Hmisc::describe(mdt$tlast)


if (debug) {
  # inspect
  # focus on who have not had a measurement in the last 8 hours
  choose_mrn <- unique(mdt[new_data==FALSE & tlast > 8,.(mrn)])
  gdt <- choose_mrn[mdt, on='mrn',nomatch=0]
  ggplot(gdt, aes(x=tt, group=mrn)) +
    geom_point(aes(y=y), colour='blue', size=0.1) +
    geom_line(data=gdt[new_data==TRUE], aes(y=yhat, colour=new_data)) +
    geom_line(data=gdt[new_data==FALSE], aes(y=yhat, colour=new_data)) +
    facet_wrap(~mrn) +
    # coord_cartesian(xlim=c(-24,0)) +
    ylab(llabel) +
    xlab('Time from now (Hours)') +
    theme_minimal()
}
