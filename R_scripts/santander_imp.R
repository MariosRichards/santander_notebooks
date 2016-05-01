# Using airquality dataset
# data <- airquality
# data[4:10,3] <- rep(NA,7)
# data[1:5,4] <- NA

# probably want to give it numeric input *with* the survived column
# but without any string columns!

data = read.csv("C:\\Users\\Marios\\Desktop\\santander_kaggle\\santander_notebooks\\r_data_full.csv")

# got a copy of the original Survived column so we can reset later before outputting

old_surv <- data$TARGET

# Removing categorical variables
#data <- airquality[-c(5,6)]
###summary(data)

#-------------------------------------------------------------------------------
# Look for missing > 5% variables
pMiss <- function(x){sum(is.na(x))/length(x)*100}

# Check each column
apply(data,2,pMiss)

# Check each row
apply(data,1,pMiss)

#-------------------------------------------------------------------------------
# Missing data pattern
library(mice)

# Missing data pattern
md.pattern(data)

library(VIM)
# Plot of missing data pattern
####aggr_plot <- aggr(data, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, labels=names(data), cex.axis=.7, gap=3, ylab=c("Histogram of missing data","Pattern"))

# Box plot
marginplot(data[c(1,2)])

#-------------------------------------------------------------------------------
# Impute missing data using mice

num_datasets <- 5

tempData <- mice(data,m=num_datasets,maxit=50,meth='pmm',seed=500)
###summary(tempData)

# Get imputed data (for the Ozone variable)
# tempData$imp$Ozone

# Possible imputation models provided bymice() are
# methods(mice)

# What imputation method did we use?
# tempData$meth

# Get completed datasets (observed and imputed)
###completedData <- complete(tempData,1)
###summary(completedData)

# output to csv
#write.csv(completedData,"C:\\Users\\Marios\\Desktop\\Programming Projects\\StackSocial Courses\\Professional Python Programmer\\titanic_kaggle\\R_scripts\\output.csv")


#train_test_split = 75818
#train_test_size = 75818 + 76020




file_directory = "C:\\Users\\Marios\\Desktop\\santander_notebooks\\R_scripts\\"
filename_base = "imp_santander_"
for(i in 1:num_datasets)
{
  filename <- paste(file_directory, filename_base, as.character(i), ".csv")
  filename_test <- paste(file_directory , filename_base,"_test_"  ,as.character(i), ".csv")
  filename_train <- paste(file_directory, filename_base,"_train_" ,as.character(i), ".csv")

  output_data = complete(tempData,i)

  output_data$TARGET <- old_surv

  output_test_data = output_data[1:train_test_split,]
  output_train_data = output_data[train_test_split+1:train_test_size,]

  write.csv(output_data,       filename,       row.names = FALSE)
  write.csv(output_test_data,  filename_test,  row.names = FALSE)
  write.csv(output_train_data, filename_train, row.names = FALSE)

}



#-------------------------------------------------------------------------------
# Plots

# Scatterplot Ozone vs all
# xyplot(tempData,Ozone ~ Wind+Temp+Solar.R,pch=18,cex=1)

# Density plot original vs imputed dataset
###densityplot(tempData)

# Another take on the density: stripplot()
###stripplot(tempData, pch = 20, cex = 1.2)

#-------------------------------------------------------------------------------
# Pooling the results and fitting a linear model

# modelFit1 <- with(tempData,lm(Temp~ Ozone+Solar.R+Wind))
# pool(modelFit1)
# summary(pool(modelFit1))

# Using more imputed datasets
# tempData2 <- mice(data,m=50,seed=245435)
# modelFit2 <- with(tempData2,lm(Temp~ Ozone+Solar.R+Wind))
# summary(pool(modelFit2))