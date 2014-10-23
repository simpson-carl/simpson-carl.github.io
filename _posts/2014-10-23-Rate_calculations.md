Calculating a time series of diversification rates in a time-calibrated molecular phylogeny
========================================================
Carl Simpson

This document describes the calculation of timeseries of diversification rates as used in Simpson et al. (2011) and Simpson (2013). 

The basic method is simple and there is a function for calculating the rate estimate and likelihood in a specified window of time in the laser package by Rabosky: `yule.Window()`. But there are a couple of tricks to using it effectively, especially if you want to use an arbitary timescale. 


```r
# This is yuleWindow from laser. But importantly, I've commented out the
# text outputs. This speeds things up and makes this document shorter.

yuleWindow <- function(x, st1 = x[1], st2 = 0) {
    checkbasal(x)
    if (!is.numeric(x)) 
        stop("object x not of class 'numeric'")
    if (st1 <= st2) {
        cat("Error: invalid input\n\n")
        cat("shift points must be in temporal order (first, second)\n")
        cat("and in units of time/substitutions before present\n\n")
        return()
    }
    x <- rev(sort(x))
    res <- as.list(yuleint2(x, st1, st2))
    if (is.na(res$LH)) {
        print("Error.  Must be >= 1 speciation event within temporal window\n")
        stop()
    }
    # cat('---------------------------------\n') cat('Results of fitting Yule
    # model to temporal window of \n') cat('(', st1, ',', st2, ') time units
    # before present:\n\n') cat('ML speciation rate: ', res$smax,
    # '\n\nLikelihood: ', res$LH, '\n\n')
    return(res)
}
```



Tanja Stadler published a similar method (Stadler 2011 and the package `TreePar`) that allows rates to change from interval to interval only if the likelihood in that interval exceeds a certain threshold defined by a constant rate. We know from the fossil record that rates are never constant, so having a null that is constant just does not make sense to me. However, you can easily test for that with the code here by saving the likelihoods.


For a single simulated tree: 

```r
library(ape)

b <- 0.2
d <- 0.1
C <- 10
R <- 1
tree <- rbdtree(b, d, Tmax = 50)
plot(tree, show.tip.label = F)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 



You don't even need a real time scale. In the example below, the scale is simply a window 1.5 million years wide sliding every 1 million years. Now with this kind of timescale there are two options that become important. 1) the width of the window (`w`), and 2)the minimum number of nodes in the window you want to calculate rates on (`n`). These two paramters interact with each other, the wider the window the easier it is to get lots of nodes. All of this is not important if you use a geological time scale and multiple trees pulled from the posterior of a Bayesian analysis.


The basic code is with an arbitrary timescale is:

```r
suppressMessages(library(laser))

max.t <- max(branching.times(tree))


t <- max.t:1
div <- as.numeric()
lik <- as.numeric()

w = 1.5  # w is the width of the window. This can be adjusted. 
# Wider windows will natrually include more nodes and give a better estimate
# of the diversification rates.
n = 1  # n is the minimum number of nodes needed in a window. This needs to be larger than 0, but as small as possible



bt.tree <- branching.times(tree)

for (i in t) {
    a <- length(which(bt.tree > t[i] & bt.tree < t[i] + w))
    if (a > n) {
        yw <- try(yuleWindow(bt.tree, st1 = t[i] + w, st2 = t[i]))
        div[i] <- yw$smax
        lik[i] <- yw$LH
        
    } else {
        div[i] <- NA
        lik[i] <- NA
    }
}
```


The diversification rates are saved in `div` and the likelihoods are in `lik`.

```r
plot(t, div, type = "l", xlim = c(50, 0), xlab = "Time (Ma)", ylab = "Diversification Rate")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 



```r
plot(t, lik, type = "l", xlim = c(50, 0), xlab = "Time (Ma)", ylab = "Likelihood")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 



Here is how changing the window size effects the outcome:

```r
suppressMessages(library(laser))
max.t <- max(branching.times(tree))


t <- max.t:1

w = seq(1, 10, 0.5)
n = 1

div.all <- matrix(NA, nrow = length(w), ncol = length(t))


bt.tree <- branching.times(tree)
for (j in 1:length(w)) {
    for (i in t) {
        a <- length(which(bt.tree > t[i] & bt.tree < t[i] + w[j]))
        if (a > n) {
            yw <- try(yuleWindow(bt.tree, st1 = t[i] + w[j], st2 = t[i]))
            div.all[j, i] <- yw$smax
            
        } else {
            div.all[j, i] <- NA
        }
    }
}
```

```
## Warning: no non-missing arguments to max; returning -Inf
```

```
## Error: $ operator is invalid for atomic vectors
```

```r

colors <- heat.colors(n = 25)[-c(20:25)]
plot(t, div.all[1, ], type = "n", xlim = c(50, -10), ylim = c(0, 0.25), xlab = "Time (Ma)", 
    ylab = "Diversification Rate")
for (j in 1:length(w)) {
    lines(t, div.all[j, ], col = colors[j])
}
legend(x = 0, y = 0.25, legend = w, col = colors, lty = 1)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 


You can see that the patterns remain similar, but some of the details get smoothed over as the window width increases.

Adding a geological timescale
---

This is how I prefer to do things.

First I define the time scale. Usually I keep a csv file with the timescale and source it.

```r
# Cenozoic timescale
tscale.bot <- c(66, 61.6, 59.2, 56, 47.8, 41.2, 37.8, 33.9, 28.1, 23, 20.4, 
    16, 13.8, 11.6, 7.2, 5.3, 3.6, 2.6, 1.8, 0.01)
tscale.top <- c(61.6, 59.2, 56, 47.8, 41.2, 37.8, 33.9, 28.1, 23, 20.4, 16, 
    13.8, 11.6, 7.2, 5.3, 3.6, 2.6, 1.8, 0.01, 0)

tscale <- cbind(tscale.bot, tscale.top, tscale.top + (tscale.bot - tscale.top)/2)
tscale
```

```
##       tscale.bot tscale.top       
##  [1,]      66.00      61.60 63.800
##  [2,]      61.60      59.20 60.400
##  [3,]      59.20      56.00 57.600
##  [4,]      56.00      47.80 51.900
##  [5,]      47.80      41.20 44.500
##  [6,]      41.20      37.80 39.500
##  [7,]      37.80      33.90 35.850
##  [8,]      33.90      28.10 31.000
##  [9,]      28.10      23.00 25.550
## [10,]      23.00      20.40 21.700
## [11,]      20.40      16.00 18.200
## [12,]      16.00      13.80 14.900
## [13,]      13.80      11.60 12.700
## [14,]      11.60       7.20  9.400
## [15,]       7.20       5.30  6.250
## [16,]       5.30       3.60  4.450
## [17,]       3.60       2.60  3.100
## [18,]       2.60       1.80  2.200
## [19,]       1.80       0.01  0.905
## [20,]       0.01       0.00  0.005
```


Then I run the rate calculation.

```r
suppressMessages(library(laser))
div <- as.numeric()

# n=0 # n is the minimum number of nodes needed in a window. This needs to
# be larger than 0, but as small as possible

bt.tree <- branching.times(tree)

for (i in 1:length(tscale[, 1])) {
    a <- length(which(bt.tree > tscale[i, 2] & bt.tree < tscale[i, 1]))
    if (a > n) {
        div[i] <- try(yuleWindow(bt.tree, st1 = tscale[i, 1], st2 = tscale[i, 
            2])$smax)
    } else {
        div[i] <- NA
    }
}
```


After running the calculation, I plot it...

```r
plot(tscale[, 3], div, type = "n", xlim = c(66, 0), ylim = c(0, 0.3), xlab = "", 
    ylab = "", axes = F)
# draw timescale in background
bases <- c(66, 56, 33.9, 23, 5.3, 2.6, 0.01, 0.01)
cc <- c("grey85", "grey90", "grey85", "grey90", "grey85", "grey90", "grey85", 
    "grey90", "grey85", "grey90", "grey85", "grey90", "grey85", "grey90", "grey85", 
    "grey90", "grey85")
bt <- 0.05
to <- 0.3
for (b in 1:16) rect(xleft = bases[b], ybottom = bt, xright = bases[b + 1], 
    ytop = to, col = cc[b], border = NA)

# add ribbon of time scale
bt <- 0.03
to <- 0.05
# Add boxes for legend of time
for (b in 1:6) rect(xleft = bases[b], ybottom = bt, xright = bases[b + 1], ytop = to, 
    col = NA, border = "grey50")
# Add Text for legend of time
bt <- (bt + to)/2  # Level of text
tpl <- c(61.6, 45, 28.1, 14, 4, 1.1)
tx <- c("Paleocene", "Eocene", "Oligocene", "Miocene", "Pli", "Ple")
for (t in 1:6) text(x = tpl[t], y = bt, labels = tx[t])
axis(1, col = "grey75", line = -3)
mtext("Time (Ma)", side = 1, line = -1)
axis(2, col = "grey75", line = 0, at = c(0.05, 0.1, 0.15, 0.2, 0.25, 0.3))
mtext("Diversification Rate", side = 2, line = 2.5)

# plot lines
lines(tscale[, 3], div)
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 


In the background of this plot I show epoch-level geological time. Also, I usually use a function for plotting these timescales in the background.




References
---
Rabosky, Daniel L. "LASER: a maximum likelihood toolkit for detecting temporal shifts in diversification rates from molecular phylogenies." Evolutionary bioinformatics online 2 (2006): 247.

Simpson, Carl, et al. "Evolutionary diversification of reef corals: a comparison of the molecular and fossil records." Evolution 65.11 (2011): 3274-3284.

Simpson, Carl. "Species selection and the macroevolution of coral coloniality and photosymbiosis." Evolution 67.6 (2013): 1607-1621.

Stadler, Tanja. "Mammalian phylogeny reveals recent diversification rate shifts." Proceedings of the National Academy of Sciences 108.15 (2011): 6187-6192.
