##################################
# Munge file for NSCH project
##################################

# Rename data file for easier referencing
data <- DRC.2011.2012.NSCH
rm(DRC.2011.2012.NSCH)

##################################
# Any variables that need to be cleaned follow this line:
##################################

##################################
# How old is the child at the start of services in months?
# K4Q37, K4Q37_A -> service.months
##################################
service.months <- rep(NA, 95677)

# Generate new variable that is TRUE if the units are years (level 2 in this variable)
selectedrows <- rep(NA, 95677)
selectedrows <- as.integer(data$K4Q37_A) == 2

# Make all NAs also into FALSES
selectedrows[is.na(selectedrows)] <- F

# Make the service.months variable 12 months times the # of years in the service start age
service.months[selectedrows] <- data$K4Q37[selectedrows] * 12 
summary(data$K4Q37_A == "2 - YEARS")

# Now select just the rows that are months
# Set selectedrows variable to TRUE if the units are months (level 1 in this variable)
levels(data$K4Q37_A)
selectedrows <- rep(NA, 95677)
selectedrows <- as.integer(data$K4Q37_A) == 1

# Make all NAs also into FALSES
selectedrows[is.na(selectedrows)] <- F

# Copy into the service.months variable the # of months in the original service start age variable
service.months[selectedrows] <- data$K4Q37[selectedrows] 

     
##################################
# Specify survey design to include all cleaned variables
##################################
nsch.design <- svydesign(id=~IDNUMR, strata = ~STATE + SAMPLE, data = data, weights = ~NSCHWT)
# nsch.design