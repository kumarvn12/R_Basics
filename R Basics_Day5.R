##############################################################################
# R Session						                                                       #
#                   								                                         #
	
##############################################################################

##############################################################################
# This Session will cover:
#        R Packages 
#        Functions 
#        User Defined Functions
#       
##############################################################################


##Packages are the collection of functions
##They are stored in the "library" in the R env.

## Check available path
.libPaths()

##Get the list of all packages installed
library()

##Get the packages currently loaded in te R environment
search()

##Install a package

##Load Package to Library
  ##Before the package can be used in the code, it must be loaded in the
  ##current R environment.

## Important Packages to be considered.
#1. ggplot
#2. plyr/dplyr
#3. sqldf
#4. reshape/reshape2

##########################################dplyr Starts##################################################

#dplyr is a new package which provides a set of tools for efficiently 
#manipulating datasets in R. dplyr is the next iteration of plyr, 
#focussing on only data frames. 
#dplyr is faster, has a more consistent API and should be easier to use.

##Handy dplyr Verb:
#Filter --> filter()
#Select --> select()
#Arrange --> arrange()
#Mutate --> mutate
#Summarise --> summarise()
#Group By --> group_by()

########################################################################################################

install.packages("dplyr")
library(dplyr)
data(mtcars)
head(mtcars)
str(mtcars)
View(mtcars)

#local_df <- tbl_df(mtcars)
#View(local_df)

#1. Filter or subset
#Base R approach to filter dataset
mtcars[mtcars$cyl==8 & mtcars$gear==5,c("cyl","gear")]
#Use subset function
subset(mtcars,cyl==8 & gear==5,select = c(cyl))

#dplyr approach
#You can use "," or "&" to use and condition
filter(mtcars,cyl==8,gear==5)
filter(mtcars,cyl==8&gear==5)

x = filter(mtcars,cyl==8|cyl==6)

unique(c(1,2,2,2,3,4,4,5,7))
unique(mtcars$cyl)

#Number of uniques values for each variable
y = c(NULL)
for(i in 1:ncol(mtcars)){
  #y[i] = length(unique(mtcars[,i]))
   y = c(y,length(unique(mtcars[,i])))
}
y

# number of records for each gear
output = c(NULL)
for(i in unique(mtcars$gear)){
  output = c(output, nrow(subset(mtcars,gear==i)))
}

output



##Converting row names into column
temp <- mtcars
dim(temp)
temp$myNames <- rownames(temp)


mtcars$myNames = rownames(mtcars)
head(mtcars)

#2. Select: Pick columns by name
#Base R approach
mtcars[,c("mpg","cyl","gear")]

#dplyr Approach
select(mtcars,mpg,cyl,gear)

# Use ":" to select multiple contiguous columns, 
#and use "contains" to match columns by name
select(mtcars,mpg:disp,contains("t"))
select(mtcars,mpg:disp,"gear","carb")

#Exclude a particular column 
select(mtcars,-contains("g"))

mtcars[c(1,4,5,6,7,8,9,21),c('carb','disp')]


filter(select(mtcars,gear,carb,cyl),cyl==8|cyl==6)


#To select all columns that start with the character string "c", 
#use the function starts_with()
head(select(mtcars, starts_with("c")))

##Some additional options to select columns based on specific criteria:
#ends_with() : Select columns that end with a character string
#contains() : Select columns that contain a character string
#matches() : Select columns that match a regular expression
#one_of() : Select columns names that are from a group of names


#3. Arrange : Reorder rows
#base Approach
mtcars[order(mtcars$cyl, decreasing = T),c("cyl","gear")]
mtcars[order(mtcars$cyl),c("cyl","gear")]
#mtcars[order(mtcars$cyl,mtcars$gear),c("cyl","gear")]


#dplyr Approach
#Syntax:
#arrange(dataframe,orderby)
View(arrange(mtcars,cyl))
View(arrange(select(mtcars,cyl,gear),desc(cyl), gear))

arrange(select(mtcars,"cyl","gear"),cyl)
arrange(select(mtcars,"cyl","gear"),cyl,gear)
arrange(select(mtcars,"cyl","gear"),desc(cyl))
arrange(select(mtcars,"cyl","gear"),desc(cyl),gear)

mtcars$myNames = NULL

x = c(1,2,3)
y= c(4,5)
x+y

#mutate: Add new variable
#Base R Approach
temp <- mtcars
temp$new_variable <- temp$hp + temp$wt
str(temp)

##dplyr Approach
temp <- mutate(temp,mutate_new = hp + wt)
str(temp)

# Fetch the unique values in dataframe

#Base Package approach - unique function
#unique()

unique(mtcars$cyl)
unique(mtcars["cyl"])
unique(mtcars[c("cyl","gear")])

#dplyr approach

#distinct() 
distinct(mtcars["cyl"])
distinct(mtcars[c("cyl","gear")])

oddDf = mtcars[seq(1,nrow(mtcars),2),]
evenDf = mtcars[seq(2,nrow(mtcars),2),]
str(oddDf)
head(oddDf)
head(evenDf)

aggregate(oddDf$hp,by=list(oddDf$gear),FUN=mean,na.rm=T)
aggregate(evenDf$hp,by=list(evenDf$gear),FUN=mean,na.rm=T)

distinct_(oddDf["gear"])

mtcars$rownum = rep(c('odd','even'),nrow(mtcars)/2)
#add a new column rownum with values odd and even

aggregate(mtcars$hp,by=list(mtcars$gear,mtcars$rownum),FUN=mean,na.rm=T)




#aggregate()
##base R approach (package:stats)
aggregate(mtcars$hp, by=list(mtcars$cyl), FUN=mean, na.rm=TRUE)

aggdf = aggregate(mtcars[,c("mpg","disp","hp")], 
          by=list(mtcars$cyl,mtcars$gear), FUN=mean, na.rm=TRUE)
names(aggdf)[c(1,2)] = c('cyl','gear')


#dplyr approach
#Summarise : Reduce variable to values
summarise(mtcars,avg_mpg = mean(mpg))
summarise(mtcars,avg_mpg = mean(mpg),avg_disp = mean(disp))

aggregate(mtcars$mpg,by=list(mtcars$cyl),FUN=  mean)
summarise(group_by(mtcars,cyl),avg_mpg = mean(mpg))

summarise(group_by(mtcars,cyl,gear),avg_mpg = mean(mpg))

#Table is very handy to find the frequencies (mode)
#Base Package Approach 
table(mtcars$cyl)

tabledf = as.data.frame(table(mtcars$cyl))
tabledf = tabledf[order(tabledf$Freq,decreasing = T),]
tabledf$Var1[1]

a <- factor(rep(c("A","B","C"), 10))
a
table(a)
table(a, exclude = "B")

#dplyr approach
summarise(group_by(mtcars,cyl),freq=n())


##Merge two data frames

#Create first data frame:
name = c("Anne", "Pete", "Cath", "Cath1", "Cath2")
age = c(28,30,25,29,35)
child <- c(FALSE,TRUE,FALSE,TRUE,TRUE)
df <- data.frame(name,age,child)

#Create Second Dataframe:
name = c("Anne1", "Pete", "Cath", "Cath1", "Cath2")
occupation = c("Engg","Doc","CA","Forces","Engg")
df1 = data.frame(name,age,occupation)
df1

#Base Package Approach
merge(df,df1)
merge(df,df1)

merge(df,df1,by.x = "name",by.y = "name")# inner join
merge(df,df1,by.x = "name",by.y = "name", all.x=TRUE)#Left join
merge(df,df1,by.x = "name",by.y = "name", all.y=TRUE)#Right join
merge(df,df1,by.x = "name",by.y = "name",all.x=TRUE, all.y=TRUE)#outer join

#Creating another dataframe with different column name
name1 = c("Anne1", "Pete", "Cath", "Cath1", "Cath2")
df1 = data.frame(name1,occupation)
#merge(df,df1,by.x = "name",by.y = "name1")
#merge(df,df1,by.x = "name",by.y = "name1",all.x = T)


##dplyr approach
inner_join(df,df1)
inner_join(df,df1,by = "name")
inner_join(df,df1,by = c("name" = "name1"))
left_join(df,df1,by = c("name" = "name1"))
left_join(df,df1,by = c("age" = "age" , "name" = "name1"))
full_join(df,df1,by = c( "name" = "name1"))

#Try
#left_join()
#full_join()


##########################################dplyr Ends##################################################


##########################################sqldf Starts##################################################
install.packages("sqldf")
library(sqldf)

# Single Table Operations

tmp = sqldf("SELECT * FROM mtcars WHERE gear ==4")

# Get the count of obs
sqldf("SELECT gear, COUNT(gear) as occurances 
      FROM mtcars GROUP BY gear")

##Use a CASE statemetn to define a new data column in dataframe
temp2 <- mtcars
temp <- sqldf("SELECT *,
               CASE
                   WHEN gear > 4 THEN 'T'
                   WHEN cyl > 4 THEN 'T'
                   ELSE 'F'
               END as Advanced
               FROM temp2
              ")

temp3 <- sqldf("SELECT *,
               CASE
              WHEN gear > 4 THEN 'T'
              WHEN cyl > 4 THEN 'T'
              ELSE 'F'
              END as Advanced
              FROM temp2
              ORDER BY Advanced , cyl DESC LIMIT 10
              ")


##Multi Table Operations:

df1 <- data.frame(ID = c(1:10),
                  Name = LETTERS[1:10],Bol = rep(c(T,F),5))

df2 <- data.frame(ID = c(5:15),ParentName = LETTERS[5:15])

#Left join: Keeps all record from LEFT table 
#and matching records from right table

left_join <- sqldf(" SELECT *
                     FROM df1 a 
                     LEFT JOIN df2 b ON a.ID = b.ID
                   "
                   )

##Right joins are not supported by sqldf package. 

inner_join <- sqldf(" SELECT *
                     FROM df1 a 
                   INNER JOIN df2 b ON a.ID = b.ID
                   "
)
##########################################sqldf Ends##################################################

#########################################reshape Starts################################################
#Cast and Melt Functions

reshape_demo <- data.frame(Country=c("India","US","India","US","UK"),
Dept = c("IT","IT","Fin","Fin","IT"),
Expense = c(1234,2345,3456,4567,5678),
No_Months = c(22,24,25,34,56)
#state = c('ap','miami','mp','az','london')
)


reshape_demo

install.packages("reshape")
library(reshape)

#Transpose Function - interchanges rows and columns
reshape_demo
y = t(reshape_demo)
y

# Melt the dataframe
#melt takes wide-format data and melts it into long-format data.
?melt
melt(reshape_demo)
temp_wide <- melt(reshape_demo,c("Country",'Dept'))
temp_wide
temp_wide1 <- melt(reshape_demo,c("Country",'Dept','Expense'))
temp_wide1

#Cast the melted data
#cast(data,formula,function)
#cast takes long-format data and casts it into wide-format data.
cast(temp_wide,Country~variable,mean)

aggregate(temp_wide$value,by=list(temp_wide$Country,temp_wide$variable),FUN=mean)

cast(temp_wide,Dept~variable,mean)

#########################################reshape Ends################################################




##################################################################################################

##User Defined Function
##################################################################################################

aaa <- function(){
  print("Hi this is user defined function")
}

#Calling a function
aaa()

fnSum <- function(x,y){
  z = x+y
  return(z)
}

#Calling a function
fnSum(x = 2,y =  4)
output = fnSum(2,4)


fnMode = function(df,col){
  tbl = as.data.frame(table(df[,col]))
  tbl = tbl[order(tbl$Freq,decreasing = T),]
  return(tbl$Var1[1])
}

fnMode(df = mtcars,col = 'cyl')
df = iris
col = 'Sepal.Width'
fnMySummary = function(df,col){
  if(is.numeric(df[,col])){
    vec1 = c(mean(df[,col]),median(df[,col]))
    #print(vec1)
    return(vec1)
  }else if(is.factor(df[,col])){
    #print(fnMode(df,col))
    return(fnMode(df,col))
  }
}

fnMySummary(iris,'Sepal.Width')


data("mtcars")
mtcars
#Create a function to print square of a number
aaa <- function(a){
  #b = list()
  for(i in 1:a){
    b[i] <- i^2
    #print(b)
  }
  return(b)
}


mtcars

write.csv(mtcars,"C:/Users/varun/Desktop/Me/test/mtcars.csv",row.names = FALSE)
write.table(mtcars,
            "C:/Users/varun/Desktop/Me/test/mtcars.txt",
            sep = '|',row.names = FALSE)
newData = read.table('C:/Users/varun/Desktop/Me/test/mtcars.txt',
                     header=TRUE,sep = '|')
newData = read.csv('C:/Users/varun/Desktop/Me/test/mtcars.csv')

#tmpData = read.delim('clipboard')

#install.packages('xlsx')
#library(xlsx)
#xl_data = read.xlsx('C:/Users/phsivale/Desktop/mtcars_excel.xlsx',sheetIndex = 1,
                  #startRow = 1,endRow = 10,header = T)


###

write.csv(mtcars,'C:/Users/varun/Desktop/Me/test/mtcars.csv',row.names = F)

