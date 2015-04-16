# Two timescale plotting functions
# carl simpson, 4-16-2015

# download these files so that the functions know interval boundaries
periods <- read.csv("periods.csv", header = T)
epochs <- as.vector(read.csv("epochs.csv", header = T))

# Funciton for period scale on ribbon and backdrop
tscales.period <- function(top, bot, s.bot, ...){
  bases <- periods
  cc <- rep(c("grey95","grey97 "),length(bases))

  rect(xleft = bases[-12, 2], ybottom = rep(bot,11), xright = bases[-1, 2],
       ytop = rep(top, 11), col = cc, border=NA)

  rect(xleft = bases[-12, 2], ybottom = rep(bot,11), xright = bases[-1, 2],
       ytop = rep(s.bot, 11), border = 'grey90')

  bt <- (bot+s.bot)/2
  tpl <- bases[,2]+c(diff(bases[,2])/2,0)

  text(x=tpl[-12], y=bt[-12], labels = bases[1:11, 1])
}

# Funciton for period scale on ribbon and epoch scale on backdrop
tscales.epoch <- function(top, bot, s.bot){
  labels <- periods
  bases <- epochs
  end <- dim(bases)[1]
  cc <- rep(c("grey95","grey97 "),length(bases))

  rect(xleft = bases[-end,], ybottom = rep(bot, end), xright = bases[-1,],
       ytop = rep(top, end), col = cc, border=NA)

  rect(xleft = labels[-12, 2], ybottom = rep(bot,11), xright = labels[-1, 2],
       ytop = rep(s.bot, 11), border = 'grey90')

  bt <- (bot+s.bot)/2
  tpl <- labels[,2]+c(diff(labels[,2])/2,0)

  text(x=tpl[-12], y=bt[-12], labels = labels[1:11, 1])
}