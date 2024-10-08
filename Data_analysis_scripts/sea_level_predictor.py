import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import linregress

def draw_plot():
    # Read data from file
    df = pd.read_csv(r"epa-sea-level.csv")

    # Create scatter plot
    plt.scatter(x=df["Year"], y=df["CSIRO Adjusted Sea Level"])

    # Create first line of best fit
    model1 = linregress(x=df["Year"], y=df["CSIRO Adjusted Sea Level"])
    all_years = np.arange(1880, 2051)
    future_values1 = model1.intercept + model1.slope * all_years
    best_fit_line1 = pd.DataFrame({"Year": all_years, "CSIRO Adjusted Sea Level": future_values1})

    plt.plot(best_fit_line1["Year"], best_fit_line1["CSIRO Adjusted Sea Level"], color="red", label="1st Best Fit")

    # Create second line of best fit
    year_filt = (df["Year"]>=2000) & (df["Year"]<=2013)
    model2 = linregress(x=df.loc[year_filt, "Year"], y=df.loc[year_filt, "CSIRO Adjusted Sea Level"])
    future_values2 = model2.intercept + model2.slope * all_years
    best_fit_line2 = pd.DataFrame({"Year": all_years, "CSIRO Adjusted Sea Level": future_values2})

    plot_filt = best_fit_line2["Year"] >= 2000
    plt.plot(best_fit_line2.loc[plot_filt, "Year"], best_fit_line2.loc[plot_filt, "CSIRO Adjusted Sea Level"], color="green", label="2nd Best Fit")

    # Add labels and title
    plt.xlabel("Year")
    plt.ylabel("Sea Level (inches)")
    plt.title("Rise in Sea Level")
    
    # Save plot and return data for testing (DO NOT MODIFY)
    plt.savefig('sea_level_plot.png')
    return plt.gca()














