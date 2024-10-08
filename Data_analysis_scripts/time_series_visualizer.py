import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

# Import data (Make sure to parse dates. Consider setting index column to 'date'.)
df = pd.read_csv("fcc-forum-pageviews.csv", parse_dates=["date"], index_col="date")

# Clean data
filt_trun_mean = (df["value"] >= df["value"].quantile(.025)) & (df["value"] <= df["value"].quantile(.975))
trimmed_df = df.loc[filt_trun_mean]



def draw_line_plot():
    # Draw line plot
    plt.figure(figsize=(17, 5))
    fig = plt.plot(trimmed_df.index, trimmed_df["value"], color="red")
    plt.title("Daily freeCodeCamp Forum Page Views 5/2016-12/2019")
    plt.xlabel("Date")
    plt.ylabel("Page Views")


    # Save image and return fig (don't change this part)
    plt.savefig('line_plot.png')
    return fig


def draw_bar_plot():
    # Copy and modify data for monthly bar plot
    trimmed_df["year"] = trimmed_df.index.year
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    bar_df = trimmed_df.copy()
    bar_df["month"] = bar_df.index.month
    grouped_df = bar_df.groupby(["year", "month"]).mean().reset_index()
    pivot_df = grouped_df.pivot(index="year", columns="month", values="value")
        
    # Draw bar plot
    plt.figure(figsize=(6, 6))
    fig = pivot_df.plot(kind="bar")
    plt.title("Average Daily Page Views for Each Month Grouped By Year")
    plt.xlabel("Year")
    plt.ylabel("Average Page Views")
    plt.legend(labels=months)
    # Save image and return fig (don't change this part)
    plt.savefig('bar_plot.png')
    return fig


def draw_box_plot():
    # Prepare data for box plots (this part is done!)
    # df_box = df.copy()
    # df_box.reset_index(inplace=True)
    # df_box['year'] = [d.year for d in df_box.date]
    # df_box['month'] = [d.strftime('%b') for d in df_box.date]
    box_df = trimmed_df.copy()

    box_df["month"] = box_df.index.strftime("%b")
    box_df.reset_index(inplace=True)
    month_order = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    # Draw box plots (using Seaborn)
    fig, ax = plt.subplots(1, 2, figsize=(15, 5))

    sns.boxplot(x="year", y="value", data=box_df, orient="x", ax=ax[0])
    ax[0].set_title("Year-wise Box Plot (Trend)")
    ax[0].set_ylabel("Page Views")
    ax[0].set_xlabel("Year")

    sns.boxplot(x="month", y="value", hue="month", data=box_df, orient='x', order=month_order, hue_order=month_order, ax=ax[1])
    ax[1].set_title("Month-wise Box Plot (Seasonality)")
    ax[1].set_ylabel("Page Views")
    ax[1].set_xlabel("Month")


    # Save image and return fig (don't change this part)
    fig.savefig('box_plot.png')
    return fig


















