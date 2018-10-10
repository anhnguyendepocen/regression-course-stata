************** RECITATION 06 **************
************* February 27, 2016 ***********



** source: http://www.ats.ucla.edu/stat/stata/webbooks/reg/chapter1/statareg1.htm

use http://www.ats.ucla.edu/stat/stata/webbooks/reg/elemapi2, clear

codebook api00 enroll mealcat

// Recap of the previous class
regress api00 enroll i.mealcat

* write the equation down

margins mealcat, at(enroll = (130 1570))
marginsplot
* The lines are parallel! This is because there is no interaction
*WHAT THE GRAPH SHOWS:
//   - The distance between lines is the difference between meal catergories
//   - The slope of the lines is the effect of enrollment
// The distance between lines is not the same.
// This means that the difference between category 1 and 2
// is greater than the difference between categories 2 and 3.
// Categorical variables allow to model situations when
// a 1-unit difference in variable leads to different
// results depending on what the baseline is.


// Interaction
regress api00 c.enroll##i.mealcat // c. in stata means continuous
// We have to specify c. because otherwise stata will believe enroll is categorical too.
// you can try this command:
regress api00 enroll##i.mealcat 
// This is not correct

// Interactions in stata:
// # means interact variables
// ## means interact variables but also keep the main effects
// you can try this command: 
regress api00 c.enroll#i.mealcat
// This is not what we want, because it assumes that main effects are zero.


regress api00 c.enroll##i.mealcat
margins mealcat, at(enroll = (130 1570))
marginsplot

// So what does interacting mean?
// The effect of one variable now depends on the value of another variable.
// 1. The slopes are now different. The effect of education depends on mealcat.
//      In "rich" schools, higher enrollment is associated with better scores.
//      In "middle class" schools, the association is negative, but hardly significant.
//      In "poor schools" higher enrollment is associated with worse scores.
//
//
// 2. The distance between lines is not the same. The lines are not parralel.
// The effect of mealcat now depends on enrollment.
//      In schools with low enrollment, the difference in scores is relatively small.
//      Mealcat has a significant effect, but the effect is smaller.

//      In schools with high enrollment, mealcat is more importabt.
//      The difference in scores between schools in mealcat1 and mealcat3 is now much larger.

// Interactions allow us to make models more flexible.
// Why don't we interact everything with everything else?
// Every new interaction creates additional "variables"
// This lowers our degrees of freesom and makes estimation more difficult.
// It only makes sense to interact things that are interdependent theoretically.





