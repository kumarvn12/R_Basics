##############################################################################
# R Session						                                                       #
# Date:  28/07/2017									                                         #                        							                 #	
##############################################################################

##############################################################################
# This Session will cover:
#        Read data from different Sources 
#        Write Data to different targets
#        Apply Family
#       
##############################################################################



##Read Input file - .csv

#Format: read.csv(file, header = TRUE, sep = ",",stringsAsFactors = F)


####################################################################################
#                              Apply Family
#
####################################################################################
#######################################################################################################
#R Apply Family
######################################################################################################

##The apply() family pertains to the R base package and is populate with functions to manipulate slices
##of data from matrices, list or dataframe in a repetitive way.

##Format of apply is: apply(X,margin,FUN)
##X: is an array or a matrix if 2D
##margin: is a varaiable how the function is applied; 
#margin= 1, it applies over rows
##margin =2 applies over columns. 
#Note when you use margin=(1,2), 
#it applies to both rows and columns.
##FUN : is the function you want to apply to the data. 
#It can be a R function of user defined function.

##Construct a 5*6 matrix
X <- matrix(rnorm(30),nrow = 5,ncol = 6)

##Sum the values of each column with apply()
Y <-apply(X,1,sum)
apply(X,2,sum)
apply(X[,1:2],2,sum)


X1 = data.frame(X)
Y1 <-apply(X1,1,sum)
Y1


##lapply() can be used to other objects like dataframe, list or vector and the output returned is a list

Mylist <- list(1:5,20:25)
lapply(Mylist,median)




##The sapply function
#The sapply function work like lapply() but it tries to simplify the output of the most elementry data
#structure that is possible. And indeed sapply() is a wrapper function for lapply()

sapply(Mylist,median, simplify = T)
sapply(Mylist,median,simplify = F)


##################################################################################