## IMPORTING DATA
import pandas as pd
from scipy.stats import ttest_ind, shapiro, kruskal, pearsonr, spearmanr
df = pd.read_csv('data/Part_1/CLEAN_DATA_SET_REFERENCE_EVAL.csv')
data = df.copy() # Copy the data to a new variable for analysis
print(data.head())


# Is there a difference in the HDL levels between Tall and small individuals?
### 1. Analyze normality of the data
tall_HDL = data[data['Size'] == 'Tall']['HDL'].dropna()
small_HDL = data[data['Size'] == 'Small']['HDL'].dropna()
tall_LDL = data[data['Size'] == 'Tall']['LDL'].dropna()
small_LDL = data[data['Size'] == 'Small']['LDL'].dropna()
earth_HDL = data[data['Planet'] == 'Earth']['HDL'].dropna()
venus_HDL = data[data['Planet'] == 'Venus']['HDL'].dropna()
earth_LDL = data[data['Planet'] == 'Earth']['LDL'].dropna()
venus_LDL = data[data['Planet'] == 'Venus']['LDL'].dropna()


def analyze_normality(variable, variable_name):
    shapiro_test = shapiro(variable)
    if shapiro_test.pvalue < 0.05:
        print(f"p-value of Shapiro Test for {variable_name} = {shapiro_test.pvalue:.2f}. Reject Ho")
        return shapiro_test.pvalue
    else:
        print(f"p-value of Shapiro Test for {variable_name} = {shapiro_test.pvalue:.2f}. Fail to reject Ho")
        return shapiro_test.pvalue

def test_analysis(var1, var2, p_var1, p_var2, var1_name, var2_name):
    if p_var1 > 0.05 and p_var2 > 0.05:
        # Both distributions are normal, use t-test
        t_stat, p_value = ttest_ind(var1, var2, equal_var=False)  # Welch's t-test
        print(f"T-test between {var1_name} and {var2_name}: t-statistic = {t_stat:.2f}, p-value = {p_value}")
        return t_stat, p_value
    else:
        # At least one distribution is not normal, use Kruskal-Wallis test
        p_value = kruskal(var1, var2)
        print(f"Kruskal-Wallis test between {var1_name} and {var2_name}: H-statistic = {t_stat:.2f}, p-value = {p_value}")
        return t_stat, p_value

## Checking normality of the data
s1 = analyze_normality(tall_HDL, 'Tall-HDL') # Normal data
s2 = analyze_normality(small_HDL, 'Small-HDL') # Normal data
s3 = analyze_normality(tall_LDL, 'Tall-LDL') # Normal data
s4 = analyze_normality(small_LDL, 'Small-LDL') # Normal data
s5 = analyze_normality(earth_HDL, 'Earth-HDL') # Normal data    
s6 = analyze_normality(venus_HDL, 'Venus-HDL') # Normal data
s7 = analyze_normality(earth_LDL, 'Earth-LDL') # Normal data
s8 = analyze_normality(venus_LDL, 'Venus-LDL') # Normal data

## Comparing the data
t1 = test_analysis(tall_HDL, small_HDL, s1, s2, 'Tall-HDL', 'Small-HDL')
t2 = test_analysis(tall_LDL, small_LDL, s3, s4, 'Tall-LDL', 'Small-LDL')
t3 = test_analysis(earth_HDL, venus_HDL, s5, s6, 'Earth-HDL', 'Venus-HDL')
t4 = test_analysis(earth_LDL, venus_LDL, s7, s8, 'Earth-LDL', 'Venus-LDL')
