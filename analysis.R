# Load necessary libraries
library(dplyr)


# Setting the Working Directory
setwd("C:/users/amitm/OneDrive/Desktop/econometrics/nsso_66_round")

# Importing data sets

# Household characteristics
df_hh <- read.csv("Block_3_Household characteristics.csv")

# Demographic data
df_demo <- read.csv("Block_4_Demographic particulars of household members.csv")

# Employment data
df_emp <- read.csv("Block_5_1_Usual principal activity particulars of household members.csv")

                           # UNDERSTANDING THE DATASETS 

# Checking the dimension of dataset

dim(df_hh) # Number of household data matches with number of household given in report.
dim(df_demo)
dim(df_emp)


# Checking  the Structure of Each Dataset
str(df_hh)
str(df_demo)
str(df_emp)

# Now we want to know what are the columns of my  imported data set
names(df_hh)
names(df_demo)
names(df_emp)

# Checking the first few rows of data sets

head(df_hh)
head(df_demo)
head(df_emp)

# Check missing values in key identifiers
sum(is.na(df_demo$HHID))
sum(is.na(df_demo$Person_Serial_No))

sum(is.na(df_emp$HHID))
sum(is.na(df_emp$Person_Serial_No))

# Check duplicates in demographic data
sum(duplicated(df_demo[, c("HHID", "Person_Serial_No")]))

# Check duplicates in employment data
sum(duplicated(df_emp[, c("HHID", "Person_Serial_No")]))

# Age summary
summary(df_demo$Age)

# Sex values
table(df_demo$Sex) # 1-male , 0-female

# Activity status
table(df_emp$Usual_Principal_Activity_Status)

    # We want to dropout unwanted column so we do data cleaning
hh_keep <- c(
  "HHID", "HH_Size", "HH_Type", "Religion", "Social_Group",
  "Land_Owned", "Land_Possessed", "Land_Cultivated",
  "NREG_Job_Card", "Got_NREG_Work", "NREG_No_Days_Worked",
  "Saving_Bank_Held_by_any_member",
  "Saving_Bank_No_of_Ac_in_the_Hhld",
  "Recurring_Deposit_Ac_Held_by_any",
  "WEIGHT"
)

df_hh_clean <- df_hh[, intersect(names(df_hh), hh_keep)]

demo_keep <- c(
  "HHID", "Person_Serial_No", "Relation_to_Head", "Sex", "Age",
  "Marital_Status", "General_Education", "Technical_Education",
  "Status_of_Current_Attendance",
  "Type_of_Educationa_Institution",
  "Registered_with_Emp_Exchange",
  "Vocational_Training", "Field_of_Training",
  "Beneficiary_of_the_Scheme", "WEIGHT"
)

df_demo_clean <- df_demo[, intersect(names(df_demo), demo_keep)]

emp_keep <- c(
  "HHID", "Person_Serial_No", "Usual_Principal_Activity_Status"
)

df_emp_clean <- df_emp[, intersect(names(df_emp), emp_keep)]

str(df_hh_clean)
str(df_demo_clean)
str(df_emp_clean)


# Ensure IDs are character (safe for merging)
df_hh_clean$HHID   <- as.character(df_hh_clean$HHID)
df_demo_clean$HHID <- as.character(df_demo_clean$HHID)
df_emp_clean$HHID  <- as.character(df_emp_clean$HHID)

df_demo_clean$Person_Serial_No <- as.numeric(df_demo_clean$Person_Serial_No)
df_emp_clean$Person_Serial_No  <- as.numeric(df_emp_clean$Person_Serial_No)

# Ensure numeric variables
df_demo_clean$Age <- as.numeric(df_demo_clean$Age)
df_demo_clean$Sex <- as.numeric(df_demo_clean$Sex)

df_emp_clean$Usual_Principal_Activity_Status <- 
  as.numeric(df_emp_clean$Usual_Principal_Activity_Status)

# Remove rows with missing key variables
df_demo_clean <- df_demo_clean %>%
  filter(!is.na(HHID), !is.na(Person_Serial_No), !is.na(Age), !is.na(Sex))

df_emp_clean <- df_emp_clean %>%
  filter(!is.na(HHID), !is.na(Person_Serial_No),
         !is.na(Usual_Principal_Activity_Status))

# Age range
summary(df_demo_clean$Age)

# Sex distribution
table(df_demo_clean$Sex)

# Activity codes
table(df_emp_clean$Usual_Principal_Activity_Status)

# NOW WE WILL DO MERGING BY HHID
# merging block 4 and 5
df_individual <- merge(
  df_demo_clean,
  df_emp_clean,
  by = c("HHID", "Person_Serial_No")
)
dim(df_individual)
str(df_individual)

   # Removing Duplicate Columns
library(dplyr)

df_individual <- df_individual %>%
  select(-ends_with(".y")) %>%
  rename_with(~ gsub("\\.x$", "", .x))

# checking duplication
sum(duplicated(df_individual[, c("HHID", "Person_Serial_No")])) # it should be 0.

# Checking missing value
sum(is.na(df_individual$Usual_Principal_Activity_Status))

             #Merging with Household Data (Block 3)

df_final <- merge(
  df_individual,
  df_hh_clean,
  by = "HHID"
)
dim(df_final)
str(df_final) # Rows must be same previsouly

# Check duplicates again
sum(duplicated(df_final[, c("HHID", "Person_Serial_No")]))

# Check key variables
summary(df_final$Age)
table(df_final$Sex)
table(df_final$Usual_Principal_Activity_Status)

    # Filtering Working-Age Population
df_working_age <- df_final %>%
  filter(Age >= 15 & Age <= 60)

nrow(df_working_age)
summary(df_working_age$Age)

  #Defining Employment Codes (NSSO)
employed_codes <- c(11, 12, 21, 31, 41, 42, 51, 61, 62, 71, 72)

#    Filtering Employed Individuals
df_employed <- df_working_age %>%
  filter(Usual_Principal_Activity_Status %in% employed_codes)
nrow(df_employed)

#   Defining Self-Employment Codes
self_employed_codes <- c(11, 12, 21)

# Filtering Self-Employed Individuals
df_self_employed <- df_employed %>%
  filter(Usual_Principal_Activity_Status %in% self_employed_codes)
nrow(df_self_employed)

count_employed <- df_employed %>%
  filter(Sex %in% c(1, 2)) %>%
  count(Sex, name = "Total_Employed")
count_self <- df_self_employed %>%
  filter(Sex %in% c(1, 2)) %>%
  count(Sex, name = "Self_Employed")

df_result <- count_self %>%
  left_join(count_employed, by = "Sex")

df_result <- df_result %>%
  mutate(Self_Employment_Rate = 
           (Self_Employed / Total_Employed) * 100)

df_result <- df_result %>%
  mutate(Sex = case_when(
    Sex == 1 ~ "Male",
    Sex == 2 ~ "Female"
  ))

print(df_result)


                   