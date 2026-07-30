# RNA-seq Project — BESE-300 Final Evaluation

Final evaluation project for BESE-300 (KAUST), covering two independent analyses:

- **Part 1** — exploratory and statistical analysis of a small fictional dataset (HDL/LDL levels across two populations).
- **Part 2** — differential expression analysis of an RNA-seq dataset (STATegra, GSE75417) profiling Ikaros-driven B-cell differentiation.

Author: Alejandro Martinez Hernandez (KAUST ID: 219559)

## Repository structure

```
.
├── codes/
│   ├── Part_1/            # Standalone scripts mirroring Report 1
│   ├── Part_2/            # Standalone scripts mirroring Report 2
│   └── hands-on/          # In-class exercises (not part of the final reports)
├── data/
│   ├── Part_1/            # Fictional HDL/LDL dataset (raw + cleaned)
│   └── Part_2/            # GSE75417 expression matrix (raw); processed/ is regenerated locally
├── reports/
│   ├── Report_1_Alejandro_Martinez.qmd / .pdf
│   ├── Report_2_Alejandro_Martinez.qmd / .pdf
│   └── references.bib
├── environment.yml
└── README.md
```

## Part 1 — Small dataset analysis

Data: `data/Part_1/DATA_SET_REFERENCE_EVAL.csv`, a fictional dataset of HDL/LDL measurements for 400 patients across two planets (Earth, Venus) and two size groups (Tall, Small).

Covers data curation (negative/NA values, outliers), exploratory visualization, normality testing (Shapiro-Wilk), and group comparisons (Pearson/Spearman correlation, Welch's t-test / Kruskal-Wallis).

- Report: `reports/Report_1_Alejandro_Martinez.qmd`
- Standalone scripts: `codes/Part_1/1_Quality_Control.R` (curation + exploration), `2_Analysis_A.py` (HDL vs LDL correlation), `3_Analysis_B.py` (group comparisons)

## Part 2 — RNA-seq differential expression

Data: `data/Part_2/GSE75417_STATegra.RNAseq.CQN.Combat.Annotated.positive_2014_09.csv`, part of the STATegra dataset (Gomez-Cabrero et al. 2019, *Scientific Data*; see `reports/references.bib`) — RNA-seq expression (CQN-normalized, ComBat batch-corrected) of mouse B3 cells across a Control/Ikaros-induction time course (0, 2, 6, 12, 18, 24h).

Covers data exploration, experimental design recovery from sample names, PCA, a `limma` differential expression model (Maturation contrast: 24H vs 0H), and validation against canonical B-cell differentiation markers (Rag1, Igll1).

- Report: `reports/Report_2_Alejandro_Martinez.qmd`
- Standalone scripts (run in order, each saves its output to `data/Part_2/processed/` for the next step):
  1. `1_Quality_Control.R` — data loading, experimental design parsing, PCA
  2. `2_Differential_Expression.R` — `limma` model, top markers table, volcano plot
  3. `3_Visualization.R` — marker heatmap, positive-control expression dynamics

## Reproducing this project

### 1. Set up the environment

```bash
conda env create -f environment.yml
conda activate rnaseq-project
```

This installs the R and Python packages used by both parts (`limma`, `pheatmap`, `ggplot2`, `pandas`, `scipy`, etc.). [Quarto](https://quarto.org/docs/get-started/) and a [Typst](https://typst.app/) installation are required separately to render the reports and are not managed by conda.

### 2. Render a report

```bash
quarto render reports/Report_2_Alejandro_Martinez.qmd
```

### 3. Run the standalone scripts

```bash
Rscript codes/Part_2/1_Quality_Control.R
Rscript codes/Part_2/2_Differential_Expression.R
Rscript codes/Part_2/3_Visualization.R
```

Part 1's scripts are independent of each other and can be run in any order once `1_Quality_Control.R` has produced the cleaned dataset.

## Notes

- `data/Part_2/processed/` holds regenerable intermediates (`.rds`/`.csv`) produced by the Part 2 scripts; it is not tracked in git.
- The `.qmd` reports are self-contained (they recompute everything inline) and are the source of truth graded for this assignment; the scripts in `codes/` mirror the same analysis as standalone, runnable steps.
