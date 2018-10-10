******* RECITATION 2 *******
**** Wednesday, Jan 27 2016

* prtesti observation1 proportion1 observation2 proportion2
* Tests the equality of proportions in two samples with only aggragate level
* data as inputs.

prtesti 96 .74 86 .63



* pretest depvar, by(indepvar)
* Tests the equality of proportions in a sample by another
* independent binary variable

webuse cure2 // sample dataset from Stata. It has two variables, sex and cure.
prtest cure, by(sex)



* An example of cross-tab analysis

tabi 60 157 88 25 \ 170 366 107 11 // initial table. Note that row and column 
                     //totals are calculated automatically. Do not input them

tabi 60 157 88 25 \ 170 366 107 11, cell // divides each cell by the total # of cases

tabi 60 157 88 25 \ 170 366 107 11, column // calculates column percentages

tabi 60 157 88 25 \ 170 366 107 11, row // calculates row percentages

tabi 60 157 88 25 \ 170 366 107 11, expected // Expected cell frequences if 
										// the variables are not associated
										
tabi 60 157 88 25 \ 170 366 107 11, chi2 // chi-squared test of independence
                                  // Noe that the degress of freedom equal 3.
								  // (#rows - 1) * (#columns - 1)
								  
* Example of using tab with real datasets								  
webuse dose // loads a sample dataset
tab dose function, chi2 // does a chi-squared test of the association of dose and function
tab dose function, all exact // does a bunch of other tests in addition to chi2								  
