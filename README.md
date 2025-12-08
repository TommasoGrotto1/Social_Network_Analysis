# Social Network Analysis — Assignments 1 & 2

This repository contains two assignments completed for the **Advanced Social Network Analysis** course.  
Each assignment includes R code and a corresponding written report in PDF format.

The analyses use real-world network datasets (Borgatti Scientists dataset and EIES dataset) and apply key network-science methods such as centrality, structural holes, visualization, dichotomization, and Exponential Random Graph Models (ERGM).

---

## Repository Structure

```
Social_Network_Analysis/
│
├── Assignment 1 Code.R       # R script for Assignment 1
├── Assignment 2 Code.R       # R script for Assignment 2
├── Assignment 1 Report.pdf          # Report for Assignment 1
└── Assignment 2 Report.pdf          # Report for Assignment 2
```

---

# Assignment 1 — Collaboration Network of Scientists (Borgatti_Scientists504)

## Dataset
The assignment uses the **Borgatti_Scientists504** dataset containing:

- `Collaboration`: weighted adjacency matrix (time spent collaborating)
- `Attributes`:  
  - NodeName  
  - Years (seniority)  
  - Sex (1 = Female, 2 = Male)  
  - DeptID (department/discipline)

---

## Objectives

1. **Visualize** the network after applying a **cutoff > 2** on collaboration weight.  
2. **Color the nodes** based on seniority (years worked).  
3. Compute **two centrality measures**:  
   - Betweenness centrality  
   - Eigenvector centrality  
   and justify their theoretical relevance.  
4. Identify nodes with the **highest centrality values**.  
5. Compute **correlations**:  
   - Between the two centrality measures  
   - Between centrality and seniority

---

## Methods Used

- `igraph` for visualization, centrality, and thresholding  
- Cutoff filtering using edge weights  
- Color gradients to represent seniority  
- Pearson correlations between measures  
- Scatterplots for visual associations  

---

## Output

The PDF report includes:

- Interpretation of centrality measures  
- Correlations and visualizations  
- Discussion of how seniority relates to network position  
- How thresholding affects network structure  

---

# Assignment 2 — ERGM on the EIES Network

## Dataset

- **EIES_T2.csv**: directed and valued acquaintance network among 32 scientists  
- Edge values:  
  - 0 = unknown  
  - 1 = heard of  
  - 2 = met  
  - 3 = friend  
  - 4 = close friend  

- **Data_Gender_1.xlsx**: gender attribute (1 = Female, 0 = Male)

The network is **dichotomized** with cutoff **3**:  
- 3 or 4 → **1** (friendship)  
- 0, 1, 2 → **0** (not friends)

---

## Objectives

### Part 1 — Fit Three ERGM Models
- **Model 1:** Structural terms only  
  (`edges`, `mutual`, GWID, GWOD, transitivity terms)  
- **Model 2:** Node attributes only  
  (`nodeicov`, `nodeocov`, `nodematch`)  
- **Model 3:** Full ERGM  
  Structural + attribute effects

### Part 2 — Interpretation
- Compare models  
- Substantively interpret parameters  
- Discuss implications for friendship formation

### Part 3 — Goodness of Fit
- Histograms  
- Trace plots  
- Boxplots  
- Triad census  
- GOF diagnostics and interpretation  

---

## Methods Used

- `ergm` from the `statnet` suite  
- MCMC estimation and diagnostics  
- GOF analysis with `gof()`  
- Network conversions using `intergraph`  
- Visual assessment of fit  

---

# How to Run the Code

## Requirements

```r
install.packages(c("sna", "igraph", "ergm", "statnet", "intergraph", "readxl"))
