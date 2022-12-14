#  File src/library/base/R/print.R
#  Part of the R package, https://www.R-project.org
#
#  Copyright (C) 1995-2022 The R Core Team
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

print <- function(x, ...) UseMethod("print")

##- Need '...' such that it can be called as  NextMethod("print", ...):
print.default <- function(x, digits = NULL, quote = TRUE, na.print = NULL,
                          print.gap = NULL, right = FALSE, max = NULL,
			  width = NULL,
                          useSource = TRUE, ...)
{
    # Arguments are wrapped in another pairlist because we need to
    # forward them to recursive print() calls.
    args <- pairlist(
	digits = digits,
	quote = quote,
	na.print = na.print,
	print.gap = print.gap,
	right = right,
	max = max,
	width = width,
	useSource = useSource,
        ...
    )

    # Missing elements are not forwarded so we pass their
    # `missingness`. Also this helps decide whether to call show()
    # with S4 objects (if any argument print() is used instead).
    missings <- c(missing(digits), missing(quote), missing(na.print),
		  missing(print.gap), missing(right), missing(max),
		  missing(width),
		  missing(useSource))

    .Internal(print.default(x, args, missings))
}

prmatrix <-
    function (x, rowlab = dn[[1]], collab = dn[[2]],
              quote = TRUE, right = FALSE,
              na.print = NULL, ...)
{
    x <- as.matrix(x)
    dn <- dimnames(x)
    .Internal(prmatrix(x, rowlab, collab, quote, right, na.print))
}

noquote <- function(obj, right = FALSE) {
    ## constructor for a useful "minor" class
    if(!inherits(obj,"noquote"))
        class(obj) <- c(attr(obj, "class"),
                        if(right) c(right = "noquote") else "noquote")
    obj
}

as.matrix.noquote <- function(x, ...) noquote(NextMethod("as.matrix", x))

as.data.frame.noquote <- as.data.frame.vector

c.noquote <- function(..., recursive = FALSE)
    structure(NextMethod("c"), class = "noquote")

`[.noquote` <- function (x, ...) {
    attr <- attributes(x)
    r <- unclass(x)[...] ## shouldn't this be NextMethod?
    attributes(r) <- c(attributes(r),
		       attr[is.na(match(names(attr),
                                        c("dim","dimnames","names")))])
    r
}

print.noquote <- function(x, quote = FALSE, right = FALSE, ...) {
    if(copy <- !is.null(cl <- attr(x, "class"))) {
	isNQ <- cl == "noquote"
	if(missing(right))
	    right <- any("right" == names(cl[isNQ]))
	if(copy <- any(isNQ)) {
	    ox <- x
	    cl <- cl[!isNQ]
	    attr(x, "class") <- if(length(cl)) cl # else NULL
	}
    }
    print(x, quote = quote, right = right, ...)
    invisible(if(copy) ox else x)
}

## for alias.lm, aov
print.listof <- function(x, nl = TRUE, ...)
{
    nn <- names(x)
    ll <- length(x)
    if(length(nn) != ll) nn <- paste("Component", seq.int(ll))
    for(i in seq_len(ll)) {
	cat(nn[i], if(nl) ":\n" else ": "); print(x[[i]], ...); if(nl) cat("\n")
    }
    invisible(x)
}

## formerly same as [.AsIs
`[.listof` <- function(x, i, ...) structure(NextMethod("["), class = class(x))
`[.Dlist` <- `[.simple.list` <- `[.listof`

## used for version:
print.simple.list <- function(x, ...)
    print(noquote(cbind("_"=unlist(x))), ...)

print.function <- function(x, useSource = TRUE, ...)
    print.default(x, useSource=useSource, ...)

## used for getenv()
print.Dlist <- function(x, ...)
{
    if(!is.list(x) && !is.matrix(x) && is.null(names(x))) ## messed up Dlist
	return(NextMethod())
    cat(formatDL(x, ...), sep="\n")
    invisible(x)
}
