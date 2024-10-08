import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

# 1
df = pd.read_csv("/workspace/boilerplate-medical-data-visualizer/medical_examination.csv")

# 2
df["overweight"] = (np.round(df["weight"]/(df["height"]/100) ** 2, 2) > 25).astype(int)

# 3
df["cholesterol"] = (df["cholesterol"] > 1).astype(int)
df["gluc"] = (df["gluc"] > 1).astype(int)

# 4
def draw_cat_plot():
    # 5
    df_cat = pd.melt(df, id_vars=["cardio"], value_vars=["active", "alco", "cholesterol", "gluc", "overweight", "smoke"], 
            var_name="variable", value_name="value")

    # 8
    fig = sns.catplot(data=df_cat, x="variable", col="cardio", col_wrap=2, hue="value",  kind="count")
    fig.set_ylabels("total")


    # 9
    fig.savefig('catplot.png')
    return fig


# 10
def draw_heat_map():
    # Filters
    filt_ap = df["ap_lo"] <= df["ap_hi"]
    filt_w = (df["weight"]>= df["weight"].quantile(.025)) & (df["weight"] <= df["weight"].quantile(.975))
    filt_h = (df["height"]>= df["height"].quantile(.025)) & (df["height"] <= df["height"].quantile(.975))

    # 11
    df_heat = df.loc[filt_ap & filt_w & filt_h]

    # 12
    corr = df_heat.corr()

    # 13
    mask = np.triu(corr)

    # 14
    fig, ax = plt.subplots(figsize=(10, 7))

    # 15
    sns.heatmap(corr, mask=mask, annot=True, fmt=".1f", ax=ax)

    # 16
    fig.savefig('heatmap.png')
    return fig



















