************** RECITATION 04 **************
************* February 10, 2016 ***********

*********************************
**** Variable Transformation ****
*********************************

* Sometimes you might want to transform your variables to change units of 
* measurement or change the fitted line in a way that makes visualization
* or interpretation easier. These have predictable effects on the regression 
* output. Let's look at some of the most common LINEAR transformations.
* LINEAR means that the only two operations we are allowed to do are:
*  - multiply (or divide) all of the values of a variable by the SAME and NONZERO constant
*  - add (or subtract) the same constant to all of the values of a variable
* Note that you are allowed to combine these two operations in any way

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

reg bac beers // original regression.
twoway (scatter bac beers, legend(label(1 "Original data"))) (lfit bac beers, range(0 10) legend(label(2 "Original regression")))

*Examples 
gen sixpacks = beers/6 // Suppose you want to measure beer in six-packs and not in bottles

gen extrabeers = beers + 1 // Suppose you want to account for an extra beer 
					// every person in the study have had for lunch before the study

gen bac100 = bac*100 // Suppose you want to change the units of measurement of bac
					 // to make numbers look larger

gen extrabac = bac + .1 // Suppose you want to account for some "intrinsic" level of bac

reg bac sixpacks // regression with "multiplied" IV. 
twoway (scatter bac beers, legend(label(1 "Original data"))) ///
 (lfit bac beers, range(0 10) legend(label(2 "Original regression"))) ///
 (scatter bac sixpacks, legend(label(3 "Sixpacks data"))) ///
 (lfit bac sixpacks, range(0 10) legend(label(4 "Sixpacks regression")))
// The line rotates aroung the point where the independent variable = 0

reg bac extrabeers // regression with "added" IV
twoway (scatter bac beers, legend(label(1 "Original data"))) ///
 (lfit bac beers, range(0 10) legend(label(2 "Original Regression"))) ///
 (scatter bac extrabeers, legend(label(3 "Extrabeers data"))) ///
 (lfit bac extrabeers, range(0 10) legend(label(4 "Extrabeers regression")))
// The line shifts horizontally
 
reg extrabac beers // regression with "added" DV
twoway (scatter bac beers, legend(label(1 "Original data"))) ///
 (lfit bac beers, range(0 10) legend(label(2 "Original regression"))) ///
 (scatter extrabac beers, legend(label(3 "Extrabac data"))) ///
 (lfit extrabac beers, range(0 10) legend(label(4 "Extrabac Regression")))
// the line shifts vertically

reg bac100 beers // regression with "multiplied" DV. 
twoway (scatter bac beers, legend(label(1 "Original data"))) ///
 (lfit bac beers, range(0 10) legend(label(2 "Original regression"))) ///
 (scatter bac100 beers, legend(label(3 "Bac100 data"))) ///
 (lfit bac100 beers, range(0 10) legend(label(4 "Bac100 regression")))
// The line rotates around the point where the dependent variable = 0.
// Note that the original data look all flat. This is because they are
// 100 times smaller than the new variables. Unfair to compare.

*************************
**** Dummy Variables ****
*************************

* We will use the High School and Beyond sample from the UCLA website
use http://www.ats.ucla.edu/stat/stata/notes/hsb2, clear

* Let's review what's in the dataset
sum

* We're interested in gender and writing test scores
* Regression: write = a + b(female)
reg write female
// Identify the null hypothesis: 
//
// Interpretation of constant:
//
// Interpretation of slope:
// 


* Let's plot the regression 
* (You do not need to master graphing command in Stata for this class)
graph twoway (scatter write female) (lfit write female)
// Interpretation of graph: 
// (remember this graph is only used to illustrate the relationship.
// It is otherwise a bad way to visualize.)

* Extra suggestion:
graph box write, over(female)
// This is currently plotted as a box plot graph


* How do our regression results compare with ttest?
ttest write, by(female)
// The conclusion: 

* Generate a dummy variable for male
gen male = (female==0)
tab male female

* What happens if we replace the female dummy var with the male dummy var?
reg write male
// Interpretation of constant:
//
// Interpretation of slope: 
//

* Let's plot the regression with MALE
graph twoway (scatter write male) (lfit write male)

* What if your variable coded 1/2 instead of 0/1?
gen sex=female
recode sex (1=2) (0=1)
tab sex female

* Let's run the regression (remember 2 is female 1 is male)
reg write sex
* graphing it. NOTE THIS IS FOR ILLUSTRATION PURPOSES ONLY. 
twoway (scatter write sex) (lfit write sex, range(0 2)), xscale(range(0 2))
// Interpretation of slope:
//
// Interpretation of constant: 
//
 
* In general, for two category variables, 0/1 dummy is preferred 
* because the constant is easier to interpret 

* Another way to regress sex without recoding is...
reg write i.sex

* more on this command in the coming weeks

