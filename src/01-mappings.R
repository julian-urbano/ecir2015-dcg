# Copyright (C) 2015  Julián Urbano <urbano.julian@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/.

source("src/common.R")

# Prepare output
dir.create("output/fig1", recursive = T, showWarnings = F)
dir.create("output/fig2", recursive = T, showWarnings = F)

# Read data
df <- read.csv("data/crowd.csv", stringsAsFactors = F)

# Data frame to store bias scores (computed while plotting, analyzed after)
biases <- NULL

# P(Sat | phi) =========================================================================================================
# Iterate discount functions
for (discount in split(discounts, 1:nrow(discounts))) {
  # Initialize plot
  my.dev.new(paste0("output/fig1/sat-vs-", discount$id, ".pdf"))
  plot(NA, main = paste(discount$name, "discount"),
       xlim = 0:1, xaxs = "i", xlab = expression(phi),
       ylim = 0:1, yaxs = "i", ylab = expression(hat(P)*"(Sat | "*phi*")"))
  abline(0:1, col = "grey")
  abline(h = seq(.1, .9, .1), v = seq(.1, .9, .1), col = "grey", lty = 2)
  box()

  # Iterate gain functions
  for(gain in split(gains, 1:nrow(gains))) {
    A.name <- paste0("DCG", gain$id, discount$id, "A")
    B.name <- paste0("DCG", gain$id, discount$id, "B")

    # Filter scores and code preferences -------------------------------------------------------------------------------
    ms <- data.frame(A = df[, A.name], B = df[, B.name], answer = df$answer, sat = NA)
    ms$sat[ms$answer == "good"] <- 1
    ms$sat[ms$answer == "bad"] <- 0
    # Duplicate preferences (once for A and once for B) and compute bin
    ms <- ms[complete.cases(ms),]
    ms <- data.frame(phi = c(ms$A, ms$B), sat = ms$sat)
    ms$bin <- getbin(ms$phi)

    # Plot aggregates per bin ------------------------------------------------------------------------------------------
    total <- aggregate(sat ~ bin, data = ms, length)
    good <- aggregate(sat ~ bin, data = ms, function(x) length(which(x == 1)))
    points(total$bin, good$sat / total$sat, lwd = 1, col = gain$points, pch = gain$points)

    # Fit model an plot estimates --------------------------------------------------------------------------------------
    m <- glm(sat ~ poly(phi, 2), data = ms, family = "binomial")
    x <- seq(0, 1, .02)
    p <- predict(m, newdata = list(phi = x), type = "response")
    lines(x, p, col = gain$points, lwd = 1)

    # Compute bias scores ----------------------------------------------------------------------------------------------
    # Estimate integrals with the mean over x in [0, .001, ..., 1]
    x <- seq(0, 1, .001)
    p <- predict(m, newdata = list(phi = x), type = "response")

    # b_1 : area between the diagonal y = x and the estimate P(Sat = 1 | phi)
    biases <- rbind(biases, data.frame(stringsAsFactors = F,
                                       type = "b1", value = mean(abs(x - p)),
                                       discount = discount$id, gain = gain$id))

    # b_2 : average distance at the endpoints phi = 0 and phi = 1
    biases <- rbind(biases, data.frame(stringsAsFactors = F,
                                       type = "b2", value = (p[1] + 1-p[length(p)]) / 2,
                                       discount = discount$id, gain = gain$id))
  }
  # Plot legend and close plot file ------------------------------------------------------------------------------------
  if(discount$id == "z")
    legend("bottomright", title = "Gains", rev(gains$name),
           col = rev(gains$points), pch = rev(gains$points), bg = "white", lwd = 1, cex = .85)
  dev.off()
}

# P(Pref | Delta.phi) ==================================================================================================

# Iterate discount functions
for (discount in split(discounts, 1:nrow(discounts))) {
  # Initialize plot
  my.dev.new(paste0("output/fig2/pref-vs-", discount$id, ".pdf"))
  plot(NA, main = paste(discount$name, "discount"),
       xlim = 0:1, xaxs = "i", xlab = expression(Delta*phi),
       ylim = 0:1, yaxs = "i", ylab = expression(hat(P)*"(Pref | "*Delta*phi*")"))
  abline(0:1, col = "grey")
  abline(h = seq(.1, .9, .1), v = seq(.1, .9, .1), col = "grey", lty = 2)
  box()

  # Iterate gain functions
  for(gain in split(gains, 1:nrow(gains))) {
    A.name <- paste0("DCG", gain$id, discount$id, "A")
    B.name <- paste0("DCG", gain$id, discount$id, "B")

    # Filter scores and code preferences -------------------------------------------------------------------------------
    ms <- data.frame(A = df[, A.name], B = df[, B.name], answer = df$answer, pref = 0)
    ms$D <- ms$A - ms$B
    ms$pref[(ms$answer == "a" & ms$D > 0) | (ms$answer == "b" & ms$D < 0)] <- 1
    # Compute absolute deltas and their bins, because that's what we'll plot
    ms$Dabs <- abs(ms$D)
    ms$bin <- getbin(ms$Dabs)

    # Plot aggregates per bin ------------------------------------------------------------------------------------------
    total <- aggregate(pref ~ bin, data = ms, length)
    pos <- aggregate(pref ~ bin, data = ms, function(x) length(which(x == 1)))
    points(total$bin, pos$pref / total$pref, lwd = 1, col = gain$points, pch = gain$points)

    # Fit model an plot estimates --------------------------------------------------------------------------------------
    m <- glm(pref ~ poly(Dabs, 2), data = ms, family = "binomial")
    x <- seq(0, 1, .02)
    p <- predict(m, newdata = list(Dabs = x), type = "response")
    lines(x, p, col = gain$points, lwd = 1)

    # Compute bias scores ----------------------------------------------------------------------------------------------
    # Estimate integrals with the mean over x in [0, .001, ..., 1]
    x <- seq(0, 1, .001)
    p <- predict(m, newdata = list(Dabs = x), type = "response")

    # b_3 : area between the top y = 1 and the estimate P(Pref = 1 | Delta.phi)
    biases <- rbind(biases, data.frame(stringsAsFactors = F,
                                       type = "b3", value = mean(1 - p),
                                       discount = discount$id, gain = gain$id))
  }
  # Plot legend and close plot file ------------------------------------------------------------------------------------
  if(discount$id == "z")
    legend("bottomright", title = "Gains", rev(gains$name),
           col = rev(gains$points), pch = rev(gains$points), bg = "white", lwd = 1, cex = .85)
  dev.off()
}

# Save bias scores
write.csv(file = "output/biases.csv", row.names = F, biases)
