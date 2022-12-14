
#  File src/library/grDevices/R/gradients.R
#  Part of the R package, https://www.R-project.org
#
#  Copyright (C) 2019      The R Foundation
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  A copy of the GNU General Public License is available at
#  https://www.R-project.org/Licenses/

## Create R objects defining paths

fillRules <- c("winding", "evenodd")

.ruleIndex <- function(x) {
    rule <- match(x, fillRules)
    if (is.na(rule))
        stop("Invalid fill rule")
    as.integer(rule)
}


