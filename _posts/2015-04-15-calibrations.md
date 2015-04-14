---
layout: post
title: Simple Method for Estimating Informative Node Age Priors for the Fossil Calibration of Molecular Divergence Time Analyses
tags: paper echinoids molphylo macroevoluiton
---

Nowak, M. D., Smith, A. B., Simpson, C., and Zwickl, D. J. 2013. A Simple Method for Estimating Informative Node Age Priors for the Fossil Calibration of Molecular Divergence Time Analyses. _PLoS ONE_ 8(6): e66245. doi:10.1371/journal.pone.0066245. [pdf]({{ site.url }}/papers/PloS one 2013 Nowak.pdf)




Molecular divergence time analyses often rely on the age of fossil lineages to calibrate node age estimates. Most divergence time analyses are now performed in a Bayesian framework, where fossil calibrations are incorporated as parametric prior probabilities on node ages. It is widely accepted that an ideal parameterization of such node age prior probabilities should be based on a comprehensive analysis of the fossil record of the clade of interest, but there is currently no generally applicable approach for calculating such informative priors. We provide here a simple and easily implemented method that employs fossil data to estimate the likely amount of missing history prior to the oldest fossil occurrence of a clade, which can be used to fit an informative parametric prior probability distribution on a node age. Specifically, our method uses the extant diversity and the stratigraphic distribution of fossil lineages confidently assigned to a clade to fit a branching model of lineage diversification. Conditioning this on a simple model of fossil preservation, we estimate the likely amount of missing history prior to the oldest fossil occurrence of a clade. The likelihood surface of missing history can then be translated into a parametric prior probability distribution on the age of the clade of interest. We show that the method performs well with simulated fossil distribution data, but that the likelihood surface of missing history can at times be too complex for the distribution-fitting algorithm employed by our software tool. An empirical example of the application of our method is performed to estimate echinoid node ages. A simulation-based sensitivity analysis using the echinoid data set shows that node age prior distributions estimated under poor preservation rates are significantly less informative than those estimated under high preservation rates.

 <img src="/assets/img/snape.png"  width = "500px"/>


Our method provides an estimate for the length of time after age of the MRCA of a clade but prior to the age of the oldest fossil (i.e. the missing history). This hypothetical clade has N = 11 lineages at time T, representing the current standing diversity of the group. Thick bars on the internal branches of the tree represent the preserved fossil history of the clade, such that n = 1 lineage preserved at time t. The expressions for deriving the probability of the three key temporal durations in the history of a clade are shown.


