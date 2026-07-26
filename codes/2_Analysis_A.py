## IMPORTING DATA
import pandas as pd
df = pd.read_csv('data/Part_1/CLEAN_DATA_SET_REFERENCE_EVAL.csv')
data = df.copy() # Copy the data to a new variable for analysis
print(data.head())

## ANALYSIS
### Load libraries
from scipy.stats import shapiro, pearsonr, spearmanr

# Are HDL and LDL correlated
### 1. Analyze normality of the data
HDL = data['HDL'].dropna()
LDL = data['LDL'].dropna()

shapiro_HDL = shapiro(HDL)
shapiro_LDL = shapiro(LDL)
test_conclusion = []
shapiro_pvalue = []

if shapiro_HDL.pvalue < 0.05:
    print(f"p-value of Shapiro Test for HDL = {shapiro_HDL.pvalue:.2f}. Reject Ho")
    test_conclusion.append("Reject Ho")
    shapiro_pvalue.append(shapiro_HDL.pvalue)
else:
    print(f"p-value of Shapiro Test for HDL = {shapiro_HDL.pvalue:.2f}. Fail to reject Ho")
    test_conclusion.append("Fail to reject Ho")
    shapiro_pvalue.append(shapiro_HDL.pvalue)

if shapiro_LDL.pvalue < 0.05:
    print(f"p-value of Shapiro Test for LDL = {shapiro_LDL.pvalue:.2f}. Reject Ho")
    test_conclusion.append("Reject Ho")
    shapiro_pvalue.append(shapiro_LDL.pvalue)
else:
    print(f"p-value of Shapiro Test for LDL = {shapiro_LDL.pvalue:.2f}. Fail to reject Ho")
    test_conclusion.append("Fail to reject Ho")
    shapiro_pvalue.append(shapiro_LDL.pvalue)

conclusion_table = pd.DataFrame({'Variable': ['HDL', 'LDL'], 'Shapiro p-value': shapiro_pvalue, 'Conclusion': test_conclusion})
print("\nShapiro-Wilk Test Results:")
print(conclusion_table)

if shapiro_HDL.pvalue > 0.05 and shapiro_LDL.pvalue > 0.05:
    # Both distributions are normal, use Pearson correlation
    corr, p_value = pearsonr(HDL, LDL)
    print(f"Pearson correlation coefficient = {corr:.2f}, p-value = {p_value}")
else:
    # At least one distribution is not normal, use Spearman correlation
    corr, p_value = spearmanr(HDL, LDL)
    print(f"Spearman correlation coefficient = {corr:.2f}, p-value = {p_value}")

# CONLUSIONS
# 1. According to the shapiro-wilk test, we cannot reject normality distribution (p-value > 0.05).
# 2. Pearson correlation is -0.75, with a low p-value of 1.24e-71, therefore the correlation is statistically significant.