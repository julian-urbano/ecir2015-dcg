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
dir.create("output/fig3", recursive = T, showWarnings = F)
unlink("output/anova.txt")

# Read bias scores
biases <- read.csv(file = "output/biases.csv", stringsAsFactors = F)
# Set order in factors so boxes are correctly sorted
biases$discount <- factor(biases$discount, levels = c("z", "l", "l2", "l3", "l5", "n"))
biases$gain <- factor(biases$gain, levels = c("b2", "b1", "e5", "e3", "e2", "l"))

# Config for boxplots
boxplot.cfg <- list(
  list(type = "b1", title = expression(b[1]), ylim = c(.055, .14)),
  list(type = "b2", title = expression(b[2]), ylim = c(.14, .225)),
  list(type = "b3", title = expression(b[3]), ylim = c(.45, .54))
)

# Iterate boxplot configs
for(cfg in boxplot.cfg) {
  # Run ANOVA ----------------------------------------------------------------------------------------------------------
  m <- lm(value ~ gain + discount, data = biases, subset = type == cfg$type)
  cat("***", cfg$type, "\n", file = "output/anova.txt", append = T)
  capture.output(anova(m), file = "output/anova.txt", append = T)

  # Make boxplot -------------------------------------------------------------------------------------------------------
  my.dev.new(paste0("output/fig3/bias-", cfg$type, ".pdf"), mar = c(4.8, 3.6, 2.8, 0.8))
  # Empty boxplot for axes, title, etc.
  boxplot(NA, xlim = c(0.5, 1.5 + nrow(gains) + nrow(discounts)), ylim = cfg$ylim, ylab = "Bias", main = cfg$title)

  boxplot(add = T, value ~ gain, data = biases, subset = type == cfg$type,
          at = 1:nrow(gains), names = gains$name, las = 3)
  boxplot(add = T, value~discount, data = biases, subset = type == cfg$type,
          at = 1+nrow(gains) + 1:nrow(discounts), names = discounts$name, las = 3)
  abline(v = 7)

  mtext("Gain", side = 1, line = 3.9, at = 3.5)
  mtext("Discount", side = 1, line = 3.9, at = 10.5)

  dev.off()
}
