* RECITATION 10

* Multinomial logistic regression:
* I. Bivariate example with mlogit
* II. Multivariate example with mlogit

* What are some examples of multinomial logit outcomes?

************************************************
******* New Dataset (sort of)! *****************
************************************************

* example from: http://www.ats.ucla.edu/stat/stata/output/stata_mlogit.htm

use http://www.ats.ucla.edu/stat/stata/output/mlogit, clear
* This is the High School and Beyond study but the variables are relabeled
sum
// The data were collected on 200 high school students and are 
// scores on various tests, including a video game and a puzzle.  
// The outcome measure in this analysis is the preferred flavor 
// of ice cream - vanilla, chocolate or strawberry- from which 
// we are going to see what relationships exists with video game 
// scores (video), puzzle scores (puzzle) and gender (female).

tab ice_cream // Let's look at student's preferred ice cream. Almost 50% go with vanilla.

************************************************
*** I. Bivariate example with mlogit ***********
************************************************

tab female ice_cream // Let's start with the preferences for ice cream flavor by gender
* Looks like vanilla and strawberry is pretty split on gender, but twice as many 
** women prefer chocolate than men. 

mlogit ice_cream female // stata chooses the largest group as a reference
// Interpretation of the coefficients for chocolate vs vanilla: 
// cons: the multinomial logit estimate for chocolate relative to vanilla
//       when the predictor variables in the model are evaluated at zero
//       Men's logit for preferring chocolate to vanilla is -1.142
// How can we get that from the crosstab?
di log(15/47) 
// female: the multinomial log-odds for preferring chocolate to vanilla are 
//       expected to be 0.7366 higher for women than for men (significant result)
// How can we get that from the crosstab? Difference in the logit for f-m
di log(32/48) - log(15/47) 
// Brief interpretation of the coefficients for strawberry vs vanilla: 
// female: the multinomial log-odds for preferring strawberry to vanilla are 
//       expected to be .021 lower for women than for men (NOT significant diff)

// What is we want the base outcome to be Strawberry?
mlogit ice_cream female, b(3) // b stands for "base outcome", 3 is the value for strawberry
// Brief interpretation of female: 
// Women are also more likely than men to prefer chocolate to strawberry,
// but not more likely than men to prefer vanilla to strawberry.

// If we only had the outcome for the first output with vanilla as the base outcome,
// we can still derive the logit output for strawberry as the base outcome.
// Formula and example were given in lecture slides

// For example:
// logit(chocolate to strawberry) = logit(chocolate to vanilla) - logit(strawberry to vanilla)
// logit(chocolate to strawberry) = (-1.142+.7366*female)-(-.4829-.0211*female)
// logit(chocolate to strawberry) = -.6592 + .7577*female (matches output from line 51)

// Let's calculate predicted probability of preferring each flavor by men and women using:
mlogit ice_cream female 
// Probability that a woman will choose chocolate:
// Probability that a woman will choose vanilla:
// Probability that a woman will choose strawberry:
// Probability that a man will choose chocolate:
// Probability that a man will choose vanilla:
// Probability that a man will choose strawberry:

// same as 
tab female ice_cream, row
************************************************
*** II. Multivar. example with mlogit **********
************************************************

mlogit ice_cream video puzzle female // stata chooses the largest group as a reference

// Interpretation of the coefficients for chocolate vs vanilla:
// video: a 1 unit difference in video score is associated with on average
//       0.024 smaller multinomial log-odds for preferring chocolate to vanilla
//       while holding all other variables in the model constant.
// puzzle: a 1 unit difference in puzzle score is associated with on average
//       0.039 smaller multinomial log-odds for preferring chocolate to vanilla
//       while holding all other variables in the model constant.
// female: the multinomial log-odds for preferring chocolate to vanilla are 
//       expected to be 0.817 higher for women than for men  
//       while holding all other variables in the model constant.
// cons: the multinomial logit estimate for chocolate relative to vanilla
//       when the predictor variables in the model are evaluated at zero
//       Men with zero video and puzzle scores have the logit for 
//       preferring chocolate to vanilla is 1.912. 

// OVERALL CONCLUSION:
// The better one is at video games or puzzles, the less likely that person is 
//       to prefer chocolate to vanilla. 
// Women are more likely to prefer chocolate to vanilla.

// NOW DO THE SAME THING FOR STRAWBERRY.
// Brief interpretation: Only significant variable is puzzle. 
// Ppl who are better at puzzles and more likely to prefer strawberry to vanilla
// (controlling for video game score and gender). 



mlogit ice_cream video puzzle female, b(1) // we can change the base outcome (b)

mlogit ice_cream video puzzle female, rrr // we can also request relative risk ratios instead of coefficients

// Interpretation of the RRRs (THESE ARE SIMILAR TO ODDS BUT FOR MULTINOMIAL LOGIT)
// video: a 1 unit difference in video score is associate with a smaller relative risk
//        for preferring chocolate to vanilla (by a factor of .977)
//        holding other variables in the model constant.
// puzzle: a 1 unit difference in puzzle score is associate with a smaller relative risk
//        for preferring chocolate to vanilla (by a factor of .962)
//        holding other variables in the model constant.
// female: Compared to men, women's relative risk for preferring chocolate 
//        relative to vanilla is expected to be 2.263 times higher.
//        holding other variables in the model constant.

mlogit ice_cream video puzzle i.female // Must specify i. in front of female for margins to work
margins female, atmeans predict(outcome(1)) // Calculates predicted prob of female for chocolate
marginsplot, name(Chocolate) 
margins female, atmeans predict(outcome(2)) // Calculates predicted prob of female for vanilla
marginsplot, name(Vanilla) 
margins female, atmeans predict(outcome(3)) // Calculates predicted prob of female for strawberry
marginsplot, name(Strawberry) 
graph combine Chocolate Vanilla Strawberry, ycommon // combines the previous 3 graphs

mlogit ice_cream video i.female
margins female, at(video = (30 (1) 70)) predict(outcome(1)) vsquish 
marginsplot, name(Chocolate1) noci
margins female, at(video = (30 (1) 70)) predict(outcome(2)) vsquish
marginsplot, name(Vanilla1) noci
margins female, at(video = (30 (1) 70)) predict(outcome(3)) vsquish
marginsplot, name(Strawberry1) noci
graph combine Chocolate1 Vanilla1 Strawberry1, ycommon

// If you have an old version of stata
predict p1 p2 p3
sort video
twoway (line p1 video if female ==0) (line p1 video if female == 1), ///
	legend(order(1 "Men" 2 "Women"))
twoway (line p2 video if female ==0) (line p2 video if female == 1), ///
	legend(order(1 "Men" 2 "Women"))
twoway (line p3 video if female ==0) (line p3 video if female == 1), ///
	legend(order(1 "Men" 2 "Women"))



