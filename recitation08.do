* RECITATION 08

* Logistic regression II: 
* I. Model Comparison
* II. Reproducing logit output
* III. Odds ratios


************************************************************
******* Download and open the titanic dataset first*********
************************************************************
 
* Use the following code (make necessary adjustments) if data is
*** already in your laptop
* use "/Users/monicahe/Downloads/titanic12.dta"

sum // lets summarize the dataset to see what's out there.
drop if mi(age) // we see that age has missing values, so we drop those with 
// missing ages

**********************************************
**** Logistic Reg Model Comparisons **********
**********************************************

** Read more at http://www.ats.ucla.edu/stat/stata/faq/nested_tests.htm 

******************************
* METHODS 1: Hand calculation
******************************

logit survived i.pclass gender // Model 1 (class and gender)
* What is the log likelihood?
**** -336.21535 

logit survived i.pclass gender age // Model 2 (add age to class and gender)
* What is the log likelihood?
**** -323.64156 
* better fit model has log likelihood closer to 0 ("less negative")
* Test determines if the better fit model is significantly better

* Recall formula for Likelihood ratio test:
* -2log(L1/L2) ==>  2(logL2 - logL1) 

* Carry out the calculation:
di 2*(-323.64156 + 336.21535 ) // this is ALWAYS positive
**** 25.14758

* Recall the LR test statistic can be approximated by Chi-square distribution
* with df = difference in the number of parameters (independent vars)
* in this case, model 2 has ONE more predictor than model 1,
* so we want to see if the Chi-squared statistic 25.14758, df=1 is large enough

di chi2tail(1, 25.14758)
**** p-value = 5.311e-07
* so we reject the null that coef for age is 0, indicating that adding age 
* significantly improves over Model 1

******************************
* METHODS 2: LR Test Using STATA commands
******************************

logit survived i.pclass gender // Model 1 (class and gender) again
estimates store mod1 // This is a postestimation command that stores
// the previous logit model calling it "mod1". There is no output
// We see it in Stata under "variables"

logit survived i.pclass gender age // Model 2 (add age to class and gender)
estimates store mod2 // This is a postestimation command that stores
// the previous logit model calling it "mod2". There is no output. 

lrtest mod1 mod2 // likelihood ratio test 
* look at the assumption! "mod1 nested in mod2"
**** Chi2 statistic = 25.15, p-value < .0001
* Note that this matches the hand calculated results.
* Again, we reject the null that coef for age is 0, 
* indicating that adding age significantly improves over Model 1

******************************
* METHODS 3: Wald Test Using STATA
******************************

// Now we repeat the same exercise above with the Wald Test
qui logit survived i.pclass gender age // First run the full model, Model 2 
* "qui" stands for quietly, runs the command but hides the output
test age // testing if the coef of age = 0 
***** Chi2 statistic (1 df) = 23.34, p<.0001.
* Notice that the Wald statistic is the squared of the z test statistic for age 
* Also, slightly different (23 vs 25) compared to LR Test. That's expected!
* Again, we reject the null that coef for age is 0, suggesting that
* adding age significantly improves over model with class and gender

// Now suppose we want to use the Wald test to see if "parch" and "fare" added to
// Model 2 significantly improves the fit of the model
logit survived i.pclass gender age parch fare // First run the full model 
test parch fare
***** Chi2 statistic = 1.95, p=.3768
* We do not reject the null that coefs for parch and fare are simultaneously 0, 
* suggesting that we can remove parch and fare without significantly reducing the
* fit of the model 

**********************************************
**** Reproduce Logistic Reg Output ***********
**********************************************

* We can reproduce the following equation with just crosstabs!
* -->  logit(survived) = B0 + B1*Gender 
* Yes, we can do it!

******************************
* STEP 1: Get cross tabs
******************************

tab survived gender, column // get cross tabs for survived by gender

******************************
* STEP 2: Calculate the odds 
******************************

// Odds of surviving for women (gender == 1)
di 197/64
**** 3.078125
* Same as p/(1-p)

// Odds of surviving for men (gender == 0)
di 93/360
**** .25833333

******************************
* STEP 3: Calculate the log odds 
******************************

// Log odds of surviving for women (gender == 1)
di log(3.078125)
**** 1.1243206

// Log odds of surviving for men (gender == 0)
di log(.25833333)
**** -1.3535046

******************************
* STEP 4: Complete the logit regression
******************************

* We want: logit(survived) = B0 + B1*Gender
* B0 is the logit or log odds when Gender is 0, so that is the logit for MEN
* B0 = -1.3535046

* B1 is the DIFFERENCE in logit between WOMEN and MEN
* B1 = 1.1243786-(-1.3534924) = 
di 1.1243206+1.3535046
* B1 = 2.4778252

* The equation is: logit(survived) = -1.3535046 + 2.4778252*Gender

* Check with logit command
logit survived gender

* Coefficients match!

******************************
* STEP 5: Get the odds ratio for women compared to men
******************************

* literally women's odds/ men's odds = 
di 3.078125/.25833333
**** 11.915323

* another approach is to e^B1 in the previous equation 
di exp(2.4778252)
**** 11.915323, same as above 

* check with logistic command
logistic survived gender
* "logit survived gender, or" is another option
* Odds ratios match!

**********************************************
**** Interpreting Odds Ratios ****************
**********************************************

// Taking a step back... 
* In multiple linear regression, what value is included in the 95% CI if the
** beta is not significant? 
* In the logit output, what value is included in the 95% CI if the beta is 
** not significant?
* In the logistic regression with odds ratio output, what value of odds ratio is 
** included in the 95% CI if the odds ratio is not significant?

logistic survived i.pclass gender age 
**** DIRECT INTERPRETATION OF ODDS: 
* the odds of women surviving is over 12 times the odds for men surviving CONTROLLING FOR other variables

**** PERCENTAGE/"MORE LIKELY" INTERPRETATION OF ODDS: 
// WHEN ODDS RATIOS > 1
* Women's odds of survival are 1146% [(12.46-1)*100%] higher than the odds of men...
* ^ AWKWARD for odds over 2, better to use when odds are between 1 and 2 so that % are
* between 0 and 100. 

// WHEN ODDS RATIOS <1
* For each additional year in age, the odds of surviving is 3.6% lower 
* (1- odds ratio) * 100% lower
* Compared to first class passengers, second class passengers' odds of surviving 
* is 73% lower.
* Compared to first class passengers, third class passengers' odds of surviving 
* is 92% lower.
