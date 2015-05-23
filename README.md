# Intrduction
This is the README.md file for the summarization project "MobileActivitySummary" available at
https://github.com/kulkarnij/MobileActivitySummary

This project summarizes the raw data available at:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
Credit for the raw data:
 Human Activity Recognition Using Smartphones Dataset
> Version 1.0
> ===================================================================================================
> Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)
> 1 - Smartlab - Non-Linear Complex Systems Laboratory
> DITEN - Universit�  degli Studi di Genova, Genoa (I-16145), Italy. 
> 2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
> Universitat Polit�cnica de Catalunya (BarcelonaTech). Vilanova i la Geltr� (08800), Spain
> activityrecognition '@' smartlab.ws 

# Components
1. This file "README.md"
2. An R script "run_analysis.R" that summarizes the raw data. Input to this script is the zip file of the raw data mentioned above in the same directory as the script. If the zip file does not exist, it will be downloaded. Output of this file is a tidy data set that summarizes the data into summary.txt. This data can be read back into R using <pre><code> t<-read.table("summary.txt",header=TRUE)"</code></pre>
3. A codebook that describes the summarization process and the output in "codebook.md"
4. Summarized output in summary.txt


The script has been tested to run using RStudio Version 0.98.1102 on OsX and R version 3.1.2. It requies the "reshape2" library.

The combined non-summarized data can be inspected in the dataframe "total". The summarized data is in dataframe "sumData" which is written out to summary.txt

The script is commented and exact summarization process can be found in the codebook.
Thanks!