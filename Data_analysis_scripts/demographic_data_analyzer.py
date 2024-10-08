import pandas as pd
import numpy as np


def calculate_demographic_data(print_data=True):
    # Read data from file
    df = pd.read_csv("adult.data.csv")

    # How many of each race are represented in this dataset? This should be a Pandas series with race names as the index labels.
    race_count = pd.Series(df["race"].value_counts(), index=df["race"].unique())

    # What is the average age of men?
    average_age_men = np.round(df.loc[df["sex"]=="Male", "age"].mean(), 1)

    # What is the percentage of people who have a Bachelor's degree?
    percentage_bachelors = np.round((df.loc[df["education"]=="Bachelors", "education"].count() / df.shape[0]) * 100, 1)

    # What percentage of people with advanced education (`Bachelors`, `Masters`, or `Doctorate`) make more than 50K?
    # What percentage of people without advanced education make more than 50K?

    # with and without `Bachelors`, `Masters`, or `Doctorate`
    higher_education = df.loc[(df["education"].isin(["Bachelors", "Masters", "Doctorate"])), "salary"].count()
    lower_education = df.loc[~(df["education"].isin(["Bachelors", "Masters", "Doctorate"])), "salary"].count()

    # percentage with salary >50K
    higher_education_rich = np.round(df.loc[(df["education"].isin(["Bachelors", "Masters", "Doctorate"])) & (df["salary"]==">50K"), "salary"].count() / higher_education * 100, 1)
    lower_education_rich = np.round(df.loc[~(df["education"].isin(["Bachelors", "Masters", "Doctorate"])) & (df["salary"]==">50K"), "salary"].count() / lower_education * 100, 1) 

    # What is the minimum number of hours a person works per week (hours-per-week feature)?
    min_work_hours = df["hours-per-week"].min()

    # What percentage of the people who work the minimum number of hours per week have a salary of >50K?
    num_min_workers = df.loc[(df["hours-per-week"]== min_work_hours), "hours-per-week"].count()

    rich_percentage = np.round(df.loc[(df["hours-per-week"]== min_work_hours) & (df["salary"]==">50K"), "hours-per-week"].count() / num_min_workers * 100, 1)

    # What country has the highest percentage of people that earn >50K?
    country = df.groupby("native-country")
    country_count = pd.DataFrame(country[["native-country", "salary"]].value_counts().sort_index())

    new_country = country_count.pivot_table(index="native-country", columns="salary")
    new_country.columns = new_country.columns.droplevel(0)
    new_country["percentage_50K"] = np.round(new_country[">50K"] /(new_country[">50K"] + new_country["<=50K"]) * 100, 1)

    highest_earning_country = new_country["percentage_50K"].sort_values(ascending=False).index[0]
    highest_earning_country_percentage = new_country["percentage_50K"].sort_values(ascending=False)[0]

    # Identify the most popular occupation for those who earn >50K in India.
    top_IN_occupation = df.loc[(df["salary"]==">50K") & (df["native-country"] == "India"), "occupation"].value_counts().index[0]

    # DO NOT MODIFY BELOW THIS LINE

    if print_data:
        print("Number of each race:\n", race_count) 
        print("Average age of men:", average_age_men)
        print(f"Percentage with Bachelors degrees: {percentage_bachelors}%")
        print(f"Percentage with higher education that earn >50K: {higher_education_rich}%")
        print(f"Percentage without higher education that earn >50K: {lower_education_rich}%")
        print(f"Min work time: {min_work_hours} hours/week")
        print(f"Percentage of rich among those who work fewest hours: {rich_percentage}%")
        print("Country with highest percentage of rich:", highest_earning_country)
        print(f"Highest percentage of rich people in country: {highest_earning_country_percentage}%")
        print("Top occupations in India:", top_IN_occupation)

    return {
        'race_count': race_count,
        'average_age_men': average_age_men,
        'percentage_bachelors': percentage_bachelors,
        'higher_education_rich': higher_education_rich,
        'lower_education_rich': lower_education_rich,
        'min_work_hours': min_work_hours,
        'rich_percentage': rich_percentage,
        'highest_earning_country': highest_earning_country,
        'highest_earning_country_percentage':
        highest_earning_country_percentage,
        'top_IN_occupation': top_IN_occupation
    }
