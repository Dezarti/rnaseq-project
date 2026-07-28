# ============================================================
# One Analysis of One Continuous Variable vs One Categorical Variable
# ============================================================
# HDL and LDL are compared across Size (Tall vs Small) and Planet
# (Earth vs Venus) groups. Each subgroup is first checked for normality
# (Shapiro-Wilk); depending on the result, groups are compared using
# either Welch's t-test (normal) or the Kruskal-Wallis test (non-normal).

## IMPORTING DATA
import pandas as pd
from scipy.stats import ttest_ind, shapiro, kruskal
from pyprojroot import here

df = pd.read_csv(here("data/Part_1/CLEAN_DATA_SET_REFERENCE_EVAL.csv"))
data = df.copy()

## Split the data into groups
tall_HDL = data[data['Size'] == 'Tall']['HDL'].dropna()
small_HDL = data[data['Size'] == 'Small']['HDL'].dropna()
tall_LDL = data[data['Size'] == 'Tall']['LDL'].dropna()
small_LDL = data[data['Size'] == 'Small']['LDL'].dropna()
earth_HDL = data[data['Planet'] == 'Earth']['HDL'].dropna()
venus_HDL = data[data['Planet'] == 'Venus']['HDL'].dropna()
earth_LDL = data[data['Planet'] == 'Earth']['LDL'].dropna()
venus_LDL = data[data['Planet'] == 'Venus']['LDL'].dropna()

## Function to check normality
def analyze_normality(variable, variable_name):
    shapiro_test = shapiro(variable)
    if shapiro_test.pvalue < 0.05:
        conclusion = "Reject Ho (not normal)"
    else:
        conclusion = "Fail to reject Ho (normal)"
    return variable_name, shapiro_test.pvalue, conclusion

## Function to compare two groups
def test_analysis(var1, var2, p_var1, p_var2, comparison_name):
    if p_var1 > 0.05 and p_var2 > 0.05:
        # Both distributions are normal, use Welch's t-test
        stat, p_value = ttest_ind(var1, var2, equal_var=False)
        test_used = "T-test (Welch)"
    else:
        # At least one distribution is not normal, use Kruskal-Wallis
        result = kruskal(var1, var2)
        stat, p_value = result.statistic, result.pvalue
        test_used = "Kruskal-Wallis"
    conclusion = "Significant" if p_value < 0.05 else "Not significant"
    return comparison_name, test_used, stat, p_value, conclusion

## Run normality checks
normality_results = [
    analyze_normality(tall_HDL, "Tall-HDL"),
    analyze_normality(small_HDL, "Small-HDL"),
    analyze_normality(tall_LDL, "Tall-LDL"),
    analyze_normality(small_LDL, "Small-LDL"),
    analyze_normality(earth_HDL, "Earth-HDL"),
    analyze_normality(venus_HDL, "Venus-HDL"),
    analyze_normality(earth_LDL, "Earth-LDL"),
    analyze_normality(venus_LDL, "Venus-LDL"),
]

normality_table = pd.DataFrame(normality_results, columns=["Variable", "Shapiro p-value", "Conclusion"])
print("Normality of groups:")
print(normality_table.to_string(index=False, formatters={'Shapiro p-value': '{:.3f}'.format}))

## Run comparisons (uses p-values already computed above)
p_tall_HDL = normality_results[0][1]
p_small_HDL = normality_results[1][1]
p_tall_LDL = normality_results[2][1]
p_small_LDL = normality_results[3][1]
p_earth_HDL = normality_results[4][1]
p_venus_HDL = normality_results[5][1]
p_earth_LDL = normality_results[6][1]
p_venus_LDL = normality_results[7][1]

comparison_results = [
    test_analysis(tall_HDL, small_HDL, p_tall_HDL, p_small_HDL, "Tall vs Small (HDL)"),
    test_analysis(tall_LDL, small_LDL, p_tall_LDL, p_small_LDL, "Tall vs Small (LDL)"),
    test_analysis(earth_HDL, venus_HDL, p_earth_HDL, p_venus_HDL, "Earth vs Venus (HDL)"),
    test_analysis(earth_LDL, venus_LDL, p_earth_LDL, p_venus_LDL, "Earth vs Venus (LDL)"),
]

comparison_table = pd.DataFrame(
    comparison_results,
    columns=["Comparison", "Test", "Statistic", "p-value", "Conclusion"]
)

print("\nComparison groups:")
print(comparison_table.to_string(index=False, formatters={
    'Statistic': '{:.3f}'.format,
    'p-value': '{:.2e}'.format
}))
