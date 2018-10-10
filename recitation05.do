************************************
******** Multiple Regression *******
******** Recitation 5 **************
******** Feb 17 3016 ***************
************************************

**************************************
* PART 1: MULTIPLE REGRESSION ********
**************************************

** source: http://www.ats.ucla.edu/stat/stata/webbooks/reg/chapter1/statareg1.htm

use http://www.ats.ucla.edu/stat/stata/webbooks/reg/elemapi2, clear

sum 
// descriptive stats for all variables. 
// There are only 25, so it is not to arduous.
sum api00 enroll meals yr_rnd mealcat // sums only the ones we need


describe 
// We can see what each variable means (variable label)

rename api00 score00 // for simplicity, let's rename api00 "score00"

* first simple bivariate regression
regress score00 enroll 
// What is the association between # of students enrolled 
// and the testing score?

* let's add another variable, meals
codebook meals // reminds us what "meals" is -- % students receiving free meals

regress score00 enroll meals  
// What is the meaning of the enroll coefficient?
//
// What is the meaning of the meals coefficient?
//
// Will the results change if we run "regress score00 meals enroll"?
// Answer: 

regress enroll meals

twoway (scatter enroll meals) (lfit enroll meals) // plots the graph

predict res_enroll, residual // computes residuals (deviations of observations
							 // from the regression line


regress res_enroll meals  // Note that meals cannot predict res_enroll.
						  // It is what you expect. We purged the effect of meals

regress score00 enroll meals 
regress score00 res_enroll
// The coefficient for enroll and res_enroll in these two regressions is the same

* let's add yet another variable, yr_rnd (dummy variable for year round school)
regress score00 enroll meals yr_rnd 
// What is the meaning of the enroll coefficient?
//
// What is the meaning of the meals coefficient?
//
// What is the meaning of the yr_rnd coefficient?
// 




****************************************
* PART 2: CATEGORICAL PREDICTOR ********
****************************************

* What if we want to use mealcat, the categorical variable for meals?
codebook mealcat // this is what mealcat looks like, coded in terciles

* why can't you just do this? 
regress score00 enroll mealcat yr_rnd 
// Mealcat is, however, not a continuous variable, it is categorical.
// The "effect" may not be equal for each additional category. 

** THERE ARE TWO WAYS TO ADD CATEGORICAL PREDICTORS
** METHOD 1: LONG WAY. Generate dummies and add them into the model
tabulate mealcat, gen(mealcat) 
// This generates a dummy variable for each category of mealcat
list mealcat mealcat1 mealcat2 mealcat3 in 1/10, nolabel clean
// See the first 10 observations and we see the dummy variables

* Added 2 dummy variables into the regression. 

* what happens when we put all the dummies in?
regress score00 enroll yr_rnd mealcat1 mealcat2 mealcat3 

* NOTICE WE ALWAYS OMIT ONE CATEGORY -- THE REFERENCE CATEGORY THAT YOU CHOOSE
regress score00 enroll yr_rnd mealcat2 mealcat3 
// What's the interpretation for mealcat2? 
//
// What's the interpretation for mealcat3?
//

* We can choose to omit mealcat3
regress score00 enroll yr_rnd mealcat1 mealcat2  
// What's the interpretation for mealcat1? 
//
// What's the interpretation for mealcat2?
//

** METHOD 2: SHORT WAY. Use i. prefix
regress score00 enroll yr_rnd i.mealcat
// Creates dummy variables for mealcat and automatically makes the lowest numerical 
// value the reference category.
// It is the same thing as:
// regress score00 enroll yr_rnd mealcat2 mealcat3

* What if you want 81-100% (last category) to be the reference category?
regress score00 enroll yr_rnd ib3.mealcat
// "ib#." prefix changes the reference category to be any value
// replace # with the value for the reference cat. In this case,
// we replaced it with 3 since that is the value of the highest group
// of mealcat. 


margins mealcat, at(enroll = (130 1570) yr_rnd = 0)
// After the regression we can estimate predicted values for score00 at different
// levels of mealcat as enrollment varies from 130 to 1570 for yr_rnd = 0.

marginsplot, noci
// This plots a nice graph with margins. Noci means no confidence interval


* This is what you can do if your stata is not up to date and doesn't know margins
regress score00 enroll yr_rnd ib3.mealcat
predict ybar
twoway (scatter score00 enroll) (lfit ybar enroll if mealcat == 1 & ///
		yr_rnd == 0, sort range(130 1570)) (lfit ybar enroll if  ///
		mealcat == 2 & yr_rnd == 0, sort range(130 1570))  /// 
		(lfit ybar enroll if mealcat == 3 & yr_rnd == 0, sort range(130 1570))


