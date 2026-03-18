# \-self-employment-analysis

### \# Self-Employment Analysis (NSSO 66th Round)



#### \## Overview



This project analyzes self-employment patterns among the working-age population (15–60 years) in India using NSSO 66th Round data.



The objective is to estimate sex-wise self-employment rates within the employed population.



\---



#### \## Data



The analysis uses unit-level data from NSSO 66th Round (Schedule 10: Employment \& Unemployment).



\* Block 3: Household Characteristics

\* Block 4: Demographic particulars of household members

\* Block 5.1: Usual principal activity particulars



Datasets are merged using:



\* HHID (Household ID)

\* Person Serial Number



\---



#### \## Methodology



\* Merge demographic and employment datasets using HHID and Person Serial Number

\* Integrate household characteristics using HHID

\* Restrict sample to individuals aged 15–60 years

\* Identify employed individuals using NSSO activity status codes

\* Define self-employed as codes: 11, 12, 21



Self-employment rate is computed as:



Self-Employment Rate = (Self-Employed / Total Employed) × 100



\---



#### \## Results



\* Self-employment constitutes a significant share of total employment

\* Male self-employment rate is higher than female

\* Results are consistent with official NSSO reports



\---

### 

#### \## Project Structure

#### 

```

project/

│

├── data/        

├── code/        

├── output/      

├── report/      

└── README.md

```



\---



#### \## How to Run



1\. Place datasets in the `data/` folder

2\. Open R script from `code/`

3\. Set working directory

4\. Run the script step-by-step



\---



#### \## Report



Detailed methodology and discussion are available in:



report/self\_employment\_report.pdf

