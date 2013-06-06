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
# Age of autism diagnosis
# K2Q35A_1 and K2Q35A_2
# Make new variable in months
##################################

ASD.dx.mos <- rep(NA, 95677)
selectedrows <- rep(NA, 95677)
# str(data$K2Q35A_2)
ASD.dx.mos[which(as.integer(data$K2Q35A_2) == 2)] <- data$AGEYR_CHILD[which(as.integer(data$K2Q35A_2) == 2)] * 12
ASD.dx.mos[which(as.integer(data$K2Q35A_2) == 1)] <- data$AGEYR_CHILD[which(as.integer(data$K2Q35A_2) == 1)]
# str(data$K2Q35A_1)
# summary(data$K2Q35A_1)
# table(data$K2Q35A_1) # We have some 30 Refused and 7 Don't Know. We can impute, possibly by median. 
# table(ASD.dx.mos)
# hist(ASD.dx.mos)

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
# summary(data$K4Q37_A == "2 - YEARS")

# Now select just the rows that are months
# Set selectedrows variable to TRUE if the units are months (level 1 in this variable)
# levels(data$K4Q37_A)
selectedrows <- rep(NA, 95677)
selectedrows <- as.integer(data$K4Q37_A) == 1

# Make all NAs also into FALSES
selectedrows[is.na(selectedrows)] <- F

# Copy into the service.months variable the # of months in the original service start age variable
service.months[selectedrows] <- data$K4Q37[selectedrows] 

# Need to deal with the ones where K4Q37 == 96 or 97. For now we'll make them 9999.
# str(data$K4Q37)
service.months[data$K4Q37 == 96 | data$K4Q37 == 97] <- 9999

# Attach service.months
data$service.start.months <- service.months
     

##################################
# change birthweight into grams
# 47 ounces was the minimum and 163 ounces was the maximum recorded
# if lower or higher, they were made into 47 or 163
##################################
# summary(data$K2Q04R==47)
# summary(data$K2Q04R==163)
BWgrams <- rep(NA, 95677)
BWgrams <- data$K2Q04R*30
# summary(BWgrams)
data$BWgrams <- BWgrams
rm(BWgrams)

##################################
# Create 6 month age variables under 2
##################################

# summary(data$AGEYR_CHILD)
# summary(data$FLG_06_MNTH) # 2319 children are under 6 months
# xtabs(~AGEYR_CHILD + FLG_06_MNTH, data) # 2803 are 6-12 months
# xtabs(~AGEYR_CHILD + FLG_18_MNTH, data) # 2936 are 12-18 mos, 1982 are 18-24 mos
# Create new toddler.age variable

toddler.age <- rep(NA, 95677)

# Under 6 mos is the FLG_06_MNTH variable
toddler.age[as.integer(data$FLG_06_MNTH) == 2] <- 1

# 6-12 mos are the ones who are No on FLG_06_MNTH and 0 years old on AGEYR_CHILD
toddler.age[as.integer(data$FLG_06_MNTH) == 1 & data$AGEYR_CHILD == 0] <- 2

# 12-18 mos are Yes on FLG_18_MNTH and 1 year old on AGEYR_CHILD
toddler.age[as.integer(data$FLG_18_MNTH) == 2 & data$AGEYR_CHILD == 1] <- 3

# 18-24 mos are No on FLG_18_MNTH and 1 year old on AGEYR_CHILD
toddler.age[as.integer(data$FLG_18_MNTH) == 1 & data$AGEYR_CHILD == 1] <- 4

toddler.age <- ordered(toddler.age, levels = 1:4, labels = c("0-5 mos", "6-11 mos", "12-17 mos", "18-23 mos"))
# table(toddler.age, useNA = "ifany")

# Attach toddler.age to the dataframe
data$toddler.age <- toddler.age
rm(toddler.age)

##################################
# Specify survey design to include all cleaned variables
##################################
nsch.design <- svydesign(id=~IDNUMR, strata = ~STATE + SAMPLE, data = data, weights = ~NSCHWT)
# nsch.design