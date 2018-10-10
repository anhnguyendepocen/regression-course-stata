* RECITATION 09

* Logistic regression III: 
* I. Interaction with continuous*categotical variables
* II. Interaction with dichotomous*dichotomous variables

************************************************************
******* Download and open the titanic dataset first*********
************************************************************
 
* Use the following code (make necessary adjustments) if data is
*** already in your laptop
* use "/Users/monicahe/Downloads/titanic12.dta"

sum // lets summarize the dataset to see what's out there.
drop if mi(age) // we see that age has missing values, so we drop those with 
// missing ages

rename gender female // for ease of interpretation. Gender was coded as 1 for women

*******************************************************
**** Interaction with continuous*categotical **********
*******************************************************

logit survived age female // Model 1 (age and gender)
**** INTERPRETATIONS: 
* "age" -- controlling for gender, the logit of surviving the Titanic 
** decreases with age, but not significantly
* "female" -- controlling for age, the logit of surviving for females is
** 2.466 higher than for males, and this is sig.

* What if we hypothesize that the effect of age on survival differs by gender?

logit survived c.age##female // Model 2 (age and gender w/interaction)
* same as logit survived age female  c.age#female
* Why "c."? 

**** INTERPRETATIONS: 
* "age" -- For men, each additional year of age is associated with
** .0214 decrease in logit of surviving (Why? 0 in the other vars is male)
* "1.female" -- Not very meaningful... difference in logit between
** women and men when age is 0. Think of it as change in intercept.
* "female#c.age" -- Difference in slope of logit of age for women and men, 
** remember men's age slope is -.0214 (age coef), so women's age slope is
** -.0214+.0411 = .0197
** This means for women, age is associated with HIGHER logit of survival. 
** But for men, age is associated with LOWER logit of survival.
** This difference is significant (p=.002)

quietly:  margins female, at(age=(0(1)80))
** We predict probabilities of survival for each age from 0 to 80 by gender
** Note how we use the prefix quietly: It tells stata to do the prediction,
** but be "quiet" about it, not report it to us. We do not care about the numbers now
marginsplot // This plot the probabilities with confidence intervals
marginsplot, noci // This does the same thing but without confidence intervals
** Note how the difference in the probabilities of survival by gender is closer for 
** children. As age goes up, men are more and more likely to die
** while women are more and more likely to survive

quietly:  margins female, at(age=(0 80)) predict(xb) // This command predicts logits
// because logit function is linear we need to evaluat it at 2 points only
marginsplot, noci // and this command plots logit



********************************************************
**** Interaction with categorical*categorical **********
********************************************************

* creating a 3rd class dummy variable to illustrate this example in a simple way
gen class3 =.
replace class3 = 1 if pclass==3
replace class3 = 0 if pclass<3
tab class3 pclass

logit survived female class3 // Model 3 (gender and class)
* What are the 4 groups of people whose logits we can get from this regression?
* 1) 1st/2nd class women
* 2) 3rd class women
* 3) 1st/2nd class men
* 4) 3rd class men
** but we assume women's and men's differences in logit are the SAME across classes
** at the same time, class differenes in logit are the same across genders

**** INTERPRETATIONS: 
* "female" -- controlling for passenger class, the logit of surviving for 
** females is higher by 2.53 than for males, and this is sig.
* "class3" -- controlling for gender, 3rd class passengers' logit of surviving
** is lower by 1.52  than 1st and 2nd class passengers (reference group)

logit survived female##class3 // Model 4 (gender and class, with inter)
* What are the 4 groups of people whose logits we can get from this regression?
* 1) 1st/2nd class women
* 2) 3rd class women
* 3) 1st/2nd class men
* 4) 3rd class men
** we test if women's and men's differences in logit are DIFFERENT  across classes

**** INTERPRETATIONS: 
* "cons" -- The logit of survival for men in 1st/2nd class is -.969
** (Why? Set all to 0)
* "1.female" -- The difference in logit of survival btwn females and male for
** 1st/2nd class passengers (why? Other coefficients are 0) 
* Then, what is the logit of survival for women in 1st/2nd class? -.969+3.783 = 2.814
* "1.class3" -- The difference in logit of survival btwn 3rd class male passengers
** and 1st/2nd class male passengers is -.764 (why? Other coefficients are 0) 


**** Let's plot margins for this model to understand the interaction effect
margins female, at(class3 = (0 1)) predict(xb)
marginsplot
* "female#class3" -- the interaction effect of gender and class.
** A difference in the effect of female between 3rd class and 1st/2nd class
** (-.157- -1.733)-(2.813- -.969) = -2.207
** Alternatively, a difference in the effect of 3rd class vs 1/2 class for women compared to men
** (-.157- 2.813)-(-1.733- -.969) = -2.207
** If there is no interaction effect, we except this term to be 0

margins female, at(class3 = (0 1)) // Plotting probabilities here
marginsplot

*** Women and men have closer probabilities of survival in class3.
*** In 1st/2nd classes, there is a "female advantage" - women are much more 
*** likely to survive than men.
