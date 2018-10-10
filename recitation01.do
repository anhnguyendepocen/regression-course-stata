use http://www.ats.ucla.edu/stat/stata/notes/hsb2, clear
*uses the High School and Beyond dataset as our example

sum
*summarizes basic statistics for all variables

tab female, sum(write)
*summarizes writing score for male and female

ttest write==50
*one-sample t-test

ttest write, by(female)
*compares writing score means between males and females
