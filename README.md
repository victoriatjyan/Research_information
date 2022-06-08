# Research_information
I use publication databases to obtain reserach/publication information to track Open Access and Open Science, using Python and R.  

1. First project here is the OA monitoring through Unpaywall: 

OA_data_unpaywall.R can be used with a list of DOIs to track Open Access route, best OA locations for publications using the Unpaywall API. 
I find some occasional mistakes in the data, which can be double checked with the paper's PDF. 
The data source here is the results saved from a PubMed alert as a .csv. 

Please feel free to adapt and reuse to monitor Open Access information for your projects. 

2. Second project here is to track international collaborations for a research organization. This data source however is based from WebOfScience, which unfortunately has a high subscription fee. If you happen to have this licence, you can save the results with the "Address" data for the publications of interest, and identify unique collaborating countries. This Address data is in a very difficult format, which is parsed here to extract unique collaborating countries We had a challenge of filtering out the additional affiliations of our authors, to not count them as a collaboration. This is taken care of.

A draw back here is that the collaborators' present address cannot be distinguished from their time of doing project. So you will get false positives there. There are also small issues such as countries that end with "Republic", I will modify a future version that saves 2 words for the countries. As well as regions in England, such as Wales, Northern Ireland that need to be addressed in the future. 

Contact me at victoria.yan@embl.de for any questions!
