###Chapter 3 Data.table Expert

###Selecting Rows the Data.table Way
# The data.table package is pre-loaded

# Convert iris to a data.table
iris <- as.data.table(iris)

# Species is "virginica"
iris[Species == "virginica"]

# Species is either "virginica" or "versicolor"
iris[Species %in% c("virginica","versicolor")]

###Removing Columns And Adapting Your Column Names
# iris as a data.table
iris <- as.data.table(iris)

# Remove the Sepal. prefix... 
setnames(iris, gsub("^Sepal\\.", "", names(iris)))

# Remove the two columns starting with "Petal"
iris[, grep("^Petal", names(iris)) := NULL]

###Understanding Automatic Indexing
# Cleaned up iris data.table
iris

# Area is greater than 20 square centimeters
iris[ Width * Length > 20 ]

# Add new boolean column
iris[, is_large := Width * Length > 25]

# Now large observations with is_large
iris[is_large == TRUE]
iris[(is_large)] # Also OK

###Selecting Groups Or Parts Of Groups
# The 'keyed' data.table DT
DT <- data.table(A = letters[c(2, 1, 2, 3, 1, 2, 3)], 
                 B = c(5, 4, 1, 9,8 ,8, 6), 
                 C = 6:12)
setkey(DT,A,B)

# Select the "b" group
DT["b"]

# "b" and "c" groups
DT[c("b", "c")]

# The first row of the "b" and "c" groups
DT[c("b", "c"), mult = "first"]

# First and last row of the "b" and "c" groups
DT[c("b", "c"), .SD[c(1, .N)], by = .EACHI]

# Copy and extend code for instruction 4: add printout
DT[c("b", "c"), { print(.SD); .SD[c(1, .N)] }, by = .EACHI]

###Rolling Joins - Part One
# Keyed data.table DT
DT <- data.table(A = letters[c(2, 1, 2, 3, 1, 2, 3)], 
                 B = c(5, 4, 1, 9, 8, 8, 6), 
                 C = 6:12, 
                 key= "A,B")

# Key of `DT`
key(DT)

# Row where A == "b" & B == 6
DT[.("b", 6)]

# Return the prevailing row
DT[.("b", 6), roll = TRUE]

# Return the nearest row
DT[.("b", 6), roll = "nearest"]

###Rolling Joins - Part Two
# Keyed data.table DT
DT <- data.table(A = letters[c(2, 1, 2, 3, 1, 2, 3)], 
                 B = c(5, 4, 1, 9, 8, 8, 6), 
                 C = 6:12, 
                 key= "A,B")

# Look at the sequence (-2):10 for the "b" group
DT[.("b", (-2):10)]

# Add code: carry the prevailing values forwards
DT[.("b", (-2):10), roll = TRUE]

# Add code: carry the first observation backwards
DT[.("b", (-2):10), roll = TRUE, rollends = TRUE]
DT[.("b", (-2):10), roll = TRUE, rollends = c(TRUE, TRUE)] # also OK


