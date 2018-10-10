* RECITATION 07
* Logistic regression


// This dataset is a sample from the list of the passengers of Titanic.
// The data come from an R package "titanic" that I modified to work in Stata.
// I am not sure if it is random at all, so I cannot be certain the estimates 
// are always accurate. We will use it for educational purposes.
// Is you ever want to explore it more, check the wikipedia link
// https://en.wikipedia.org/wiki/Passengers_of_the_RMS_Titanic


use titanic12.dta, clear // we load the dataset

sum // lets summarize the dataset to see what's out there.

// The dependent variable of interest is  survived
// The main explanotary variable is pclass

// There were 3 classes aboard Titanic.

reg survived pclass // Linear Probability Model for continuous class


reg survived i.pclass // LPM for categorical class

reg survived ib2.pclass // Setting 2nd class as a reference

reg survived i.pclass gender

// Now the fun part. Logistic regression

logistic survived i.pclass gender // Note that the gender OR here is really large

logit survived i.pclass gender // Logistic regression if you want the coefficients

logit survived i.pclass gender, or // Same as logistic

// So let's calculate the probability of survival for women in first class:

di exp(2.641875 -.3447522) // calculating odds from coefficients
di 9.945526/(1+9.945526) // transforming to probabiltiy
// .90863847 It actually matches with the output from LPM pretty closely

logit survived i.pclass gender age, or

logit survived i.pclass gender age, or // including age
 
// Let's predict the outcome for Braund, Mr. Owen Harris.
// He's a 22 y.o. male travelling 3rd class.
// Should be pretty low


logit survived i.pclass gender age
di exp(-2.580625 -.0369853*22 + 1.254232) // Odds
di .11764665/(1+.11764665) // probability
// .10526283    That's pretty low but expected.

// Let's do the same for Florence Briggs Thayer.
// She's a 38 y.o. female travelling 1st class.
di exp( 2.522781 -.0369853*38 + 1.254232)

di 10.714218/(1 + 10.714218)
// .91463365  She's much luckier


// Stata can do it automatically. Run logit and then predict

predict probability

list name probability in 1/2 // Note a bit of rounding errors.






