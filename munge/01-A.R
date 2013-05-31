##################################
# Munge file for NSCH project
##################################

# Rename data file for easier referencing
data <- DRC.2011.2012.NSCH
rm(DRC.2011.2012.NSCH)

# Any variables that need to be cleaned follow this line:


# Specify survey design
nsch.design <- svydesign(id=~IDNUMR, strata = ~STATE + SAMPLE, data = data, weights = ~NSCHWT)
# nsch.design