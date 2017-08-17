###Chapter 2 Data.table yeoman

###Chaining, The Basics
# The data.table package has already been loaded

# Build DT
DT <- data.table(A = rep(letters[2:1], each = 4L), 
                 B = rep(1:4, each = 2L), 
                 C = sample(8)) 

# Combine the two steps in a one-liner
DT[, .(C = cumsum(C)), by = .(A, B)][, .(C = tail(C, 2)), by = A]

###Chaining Your Iris Dataset
# The data.table DT is loaded in your workspace
DT <- as.data.table(iris)

# Perform chained operations on DT
DT[, .(Sepal.Length = median(Sepal.Length), 
       Sepal.Width = median(Sepal.Width), 
       Petal.Length = median(Petal.Length),
       Petal.Width = median(Petal.Width)), by = Species][order(-Species)]

###Programming Time vs Readability
# Print out the pre-loaded data.table DT
DT

# Mean of columns
DT[, lapply(.SD, mean), by = x]

# Median of columns
DT[, lapply(.SD, median), by = x]

###Introducing .SDcols
# Print out the new data.table DT
DT

# Calculate the sum of the Q columns
DT[, lapply(.SD, sum), .SDcols=2:4]

# Calculate the sum of columns H1 and H2 
DT[,lapply(.SD,sum), .SDcols=paste0("H",1:2)]

# Select all but the first row of groups 1 and 2, returning only the grp column and the Q columns. 
DT[,.SD[-1], by=grp, .SDcols=paste0("Q",1:3)]

###Mixing It Together: lapply, .SD, .SDcols and .N
# DT is pre-loaded

# Sum of all columns and the number of rows
DT[, c(lapply(.SD, sum), .N), by=x, .SDcols=c("x", "y", "z")]

# Cumulative sum of column x and y while grouping by x and z > 8
DT[, lapply(.SD, cumsum), by = .(by1 = x, by2 = z > 8), .SDcols = c("x", "y")]

# Chaining
DT[, lapply(.SD, cumsum), by = .(by1 = x, by2 = z > 8), .SDcols = 1:2][, lapply(.SD, max), by = by1, .SDcols = c("x", "y")]

###Adding, Updating And Removing Columns
# The data.table DT
DT <- data.table(A = letters[c(1, 1, 1, 2, 2)], B = 1:5)

# Add column by reference: Total
DT[, Total := sum(B) , by = A]

# Add 1 to column B
DT[c(2, 4), B := B + 1L]

# Add a new column Total2
DT[2:4, Total2 := sum(B), by = A]

# Remove the Total column
DT[, Total := NULL]

# Select the third column using `[[`
DT[[3]]  
DT[[3L]] ## Also works

###The Functional Form
# A data.table DT has been created for you
DT <- data.table(A = c(1, 1, 1, 2, 2), B = 1:5)

# Update B, add C and D
DT[, `:=`(B = B + 1,  C = A + B, D = 2)]

# Delete my_cols
my_cols <- c("B", "C")
DT[, (my_cols) := NULL]

# Delete column 2 by number
DT[, 2 := NULL]

###Ready, set(), go!
# Set the seed
set.seed(1)

# Check the DT that is made available to you
DT

# For loop with set
for (i in 2:4)
  set(DT, sample(10, 3), i, NA)

# Change the column names to lowercase
setnames(DT, tolower(names(DT)))

# Print the resulting DT to the console
DT

###The set() Family
# Define DT
DT <- data.table(a = letters[c(1, 1, 1, 2, 2)], b = 1)

# Add the postfix "_2" to all column names
setnames(DT, paste0(names(DT),"_2"))

# Change column name a_2 to A2
setnames(DT, "a_2", "A2")

# Reverse the order of the columns
setcolorder(DT, 2:1)

