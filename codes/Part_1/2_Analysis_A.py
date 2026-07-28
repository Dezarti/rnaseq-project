# ============================================================
# One Analysis of Two Continuous Variables
# ============================================================
# HDL and LDL are evaluated for normality (Shapiro-Wilk) and, since both
# turn out to be normal, correlated using Pearson's test (falls back to
# Spearman otherwise).

## IMPORTING DATA
import pandas as pd
from scipy.stats import shapiro, pearsonr, spearmanr
from pyprojroot import here

df = pd.read_csv(here("data/Part_1/CLEAN_DATA_SET_REFERENCE_EVAL.csv"))
data = df.copy()

## ANALYSIS
HDL = data['HDL'].dropna()
LDL = data['LDL'].dropna()

shapiro_HDL = shapiro(HDL)
shapiro_LDL = shapiro(LDL)

normality_table = pd.DataFrame({
    'Variable': ['HDL', 'LDL'],
    'Statistic': [shapiro_HDL.statistic, shapiro_LDL.statistic],
    'p-value': [shapiro_HDL.pvalue, shapiro_LDL.pvalue],
    'Conclusion': [
        'Reject H0 (non-normal)' if shapiro_HDL.pvalue < 0.05 else 'Fail to reject H0 (normal)',
        'Reject H0 (non-normal)' if shapiro_LDL.pvalue < 0.05 else 'Fail to reject H0 (normal)'
    ]
})

print("Shapiro-Wilk normality test for HDL and LDL:")
print(normality_table.to_string(index=False, formatters={
    'Statistic': '{:.3f}'.format,
    'p-value': '{:.2e}'.format
}))

## CORRELATION
if shapiro_HDL.pvalue > 0.05 and shapiro_LDL.pvalue > 0.05:
    method = 'Pearson'
    corr, p_value = pearsonr(HDL, LDL)
else:
    method = 'Spearman'
    corr, p_value = spearmanr(HDL, LDL)

correlation_table = pd.DataFrame({
    'Method': [method],
    'Correlation coefficient': [corr],
    'p-value': [p_value]
})

print("\nCorrelation between HDL and LDL:")
print(correlation_table.to_string(index=False, formatters={
    'Correlation coefficient': '{:.3f}'.format,
    'p-value': '{:.2e}'.format
}))
