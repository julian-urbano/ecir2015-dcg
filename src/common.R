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

# To create plots in PDF
my.dev.new <- function(file, width = 4.5, height = 4.5 * 0.8, mar = c(3.2, 3.6, 2.8, 0.8), mgp = c(2.1, .7, 0)) {
  devnum <- pdf(file = file, width = width, height = height)
  par(mar = mar, mgp = mgp)
  return(as.integer(dev.cur()))
}

gains <- data.frame(stringsAsFactors = F,
                    id = c("b2", "b1", "e5", "e3", "e2", "l"),
                    name = c("Bin(2)", "Bin(1)", "Exp(5)", "Exp(3)", "Exp(2)", "Linear"),
                    points = 6:1)
discounts <- data.frame(stringsAsFactors = F,
                        id = c("z", "l", "l2", "l3", "l5", "n"),
                        name = c("Zipfian", "Linear", "Log(2)", "Log(3)", "Log(5)", "Constant"))

# Function to assign an effectiveness score to a bin for plotting
getbin <- function(x, epsilon = 1e-5) { pmin(floor((x + epsilon)*10), 9) / 10 +.05 }
