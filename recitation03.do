
**************** RECITATION 3 *********************
***************** Feb 3 2016 **********************



**** LABELS


webuse hbp4 // this command loads a dataset with some blood pressure information

describe // this command describes the data. Note the columns for labels
label data "fictional blood pressure data" // Here we give the dataset a description
describe // note how the output of the command changed

label variable hbp "high blood pressure" // This command labels the variable
describe // note how the output changed again

label define yesno 0 "no" 1 "yes" // We create a label for variables that have
								  // a binary yes/no variable. This label can be 
								  // reused multiple times.

								  
tab hbp			// 	We look at the variable for High Blood Pressude			  
label values hbp yesno // We apply a label to the values of the variable
tab hbp            // Note how the output changed
tab hbp, nolab     // If you don't want to see the labels


tab female       // The same label can be applied for another variable.
label values female yesno
tab female

label values female sexlbl // We return to the previous label
tab female
recode female (1 = 2) (0 = 1) // We recode the variable for gender
tab female // Note how the labels are off now.
label define sexlbl 2 "Female", add // adds a new # to label correspondence
label define sexlbl 1 "Male", modify // modifies an existing # to label correspondence
label define sexlbl 0 "", modify // removes an existing # to label correspondence
tab female

label list // this command lists the codebook for labels


***** Scatterplots example from stata help
sysuse auto, clear
 
scatter mpg weight // plots a simple scatter plot of mpg (y variable) 
				   // by weight (x variable)

twoway (scatter mpg weight) (lfit mpg weight) // plots a scatterplot and fits 
											  // a linear regression

twoway (scatter mpg weight) (lfit mpg weight) (lowess mpg weight)
    // plots a scatterplot, fits a linear regression and a lowess line plot
	// Notice how lowess suggests a nonlinearity

clear // clears the memory for regression analysis
	
****** Regression analysis example

* Stata allows data imputation with the input command
input beers bac
5 .10
2 .03
9 .19
8 .12
3 .04
7 .095
3 .07
5 .06
3 .02 
5 .05
4 .07
6 .10
5 .085
7 .09
1 .01
4 .05
end


scatter bac beers
corr bac beers

graph twoway (lfit bac beers) (scatter bac beers) //

corr beers bac, c // Covariance matrix is one way to estimate b1 coefficiet
di .08675/4.82917

* We can manually calculate a and b in the simple regression
sum // x-bar is 4.8125, y-bar is .07375

gen x_xbar = beers-4.8125 // new variable "x minus x-bar"
sum x_xbar // checking the new variable

gen y_ybar = bac-0.07375 // new variable "y minus y-bar"
sum y_ybar // checking the new variable

gen xy = x_xbar*y_ybar // new variable "(x minus x-bar)*(y minus y-bar)"

gen x_xbar2 = x_xbar^2 // new variable "(x minus x-bar)^2"

br


tabstat xy x_xbar2, stat(sum) // sums are 1.30125 and 72.4375

di  1.30125/72.4375 // b equals .01796376

* Compare this calculation with "di .08675/4.82917". Why does it give the same
* result? HINT: 1.30125 is 15 times larger than .08675 and
* 72.4375 is 15 times larger than 4.82917. Check the lecture slides if you
* are not sure why it is the case.

di .07375-.01796376*4.8125 // a equals -.01270059

br // browse the dataset

* Finally, we can use regress command that gives us many options

reg bac beers // regression to fit "bac = a + b*beers"

graph twoway (lfit bac beers) (scatter bac beers), yline(.07375, lstyle(foreground))

gen beers10 = beers/10 // let's change the unit of beers
sum beers10  

reg bac beers10 // note that the new coefficient is 10 time larger than previous.

* Play around with the data. Try the answering the following questions:
*    - What is the effect on b0 and b1 of multiplying the  variable beers by 5? Why?
*    - What is the effect on b0 and b1 of adding 5 to the variable beers? Why?
*    - What happens if you multiply the variable beers by 5 and add 5 to it?
*    - What happens if you first add 5 to the variable beers and then multiply it by 5?





