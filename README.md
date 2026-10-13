# EPL Progressive Carries and Shots Analysis

Author: Eddie Nguyen

Submission date: October 12, 2026

This project examines the relationship between progressive carries per 90 minutes and shots per 90 minutes among qualified outfield players in the 2024–25 English Premier League season. The primary analysis uses simple linear regression and an exploratory comparison by player position.

## Repository structure

```text
.
├── analysis/
│   └── 00_clean-data.R       # Data import, filtering, transformations, and models
├── data/
│   └── epl_player_stats_24_25.csv
├── paper/
│   ├── paper.qmd             # Quarto source for the report
│   └── references.bib
├── LICENSE                   # License for this repository's code and writing
├── MATH261A-project-1.Rproj
└── README.md
```

Run the analysis from the project root with `source("analysis/00_clean-data.R")`. Render the paper from the `paper/` directory with Quarto.

## Data and data license

The data were obtained from the [SCORE Sports Data Repository](https://data.scorenetwork.org/soccer/epl-player-stats-2425.html), which identifies the source as a Kaggle dataset. The Kaggle dataset is released under the MIT License (see the linked [Kaggle source](https://www.kaggle.com/datasets/aesika/english-premier-league-player-stats-2425/data)), and the SCORE page does not state a separate license. The CC0 file in this repository applies to the repository materials created for this project, not to the underlying dataset, which remains under its MIT License.

## External resources and LLM use

The SCORE Sports Data Repository was used for the player-statistics dataset. R and package documentation, including the documentation for `dplyr`, `ggplot2`, `knitr`, and Quarto, was used for implementation. ChatGPT was used for language editing, rephrasing, and assistance with R/Quarto syntax. Claude (Anthropic) was used to review the draft against the rubric and to suggest captions, an abstract, a paragraph on alternative data sources, and the analysis script. All data-processing decisions, statistical analyses, interpretations, and conclusions were reviewed and verified by the author. Online programming resources, including Stack Overflow, were used for troubleshooting when needed.

## Acknowledgments

This project repository is based on the template provided by [Rohan Alexander](https://github.com/RohanAlexander/starter_folder/tree/main).
