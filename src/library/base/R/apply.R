#  File src/library/base/R/apply.R
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

apply <- function(X, MARGIN, FUN, ..., simplify = TRUE)
{
    FUN <- match.fun(FUN)

    simplify <- isTRUE(simplify)

    ## Ensure that X is an array object
    dl <- length(dim(X))
    if(!dl) stop("dim(X) must have a positive length")
    if(is.object(X))
	X <- if(dl == 2L) as.matrix(X) else as.array(X)
    ## now record dim as coercion can change it
    ## (e.g. when a data frame contains a matrix).
    d <- dim(X)
    dn <- dimnames(X)
    ds <- seq_len(dl)

    ## Extract the margins and associated dimnames

    if (is.character(MARGIN)) {
        if(is.null(dnn <- names(dn))) # names(NULL) is NULL
           stop("'X' must have named dimnames")

        MARGIN <- match(MARGIN, dnn)
        if (anyNA(MARGIN))
            stop("not all elements of 'MARGIN' are names of dimensions")
    }
    d.call <- d[-MARGIN]
    d.ans  <- d[ MARGIN]
    if (anyNA(d.call) || anyNA(d.ans))
        stop("'MARGIN' does not match dim(X)")
    s.call <- ds[-MARGIN]
    s.ans  <- ds[ MARGIN]
    dn.call <- dn[-MARGIN]
    dn.ans  <- dn[ MARGIN]
    ## dimnames(X) <- NULL

    ## do the calls

    d2 <- prod(d.ans)
    if(d2 == 0L) {
        ## arrays with some 0 extents: return ``empty result'' trying
        ## to use proper mode and dimension:
        ## The following is still a bit `hackish': use non-empty X
        newX <- array(vector(typeof(X), 1L), dim = c(prod(d.call), 1L))
        ans <- forceAndCall(1, FUN, if(length(d.call) < 2L) newX[,1] else
                   array(newX[, 1L], d.call, dn.call), ...)
        return(if(is.null(ans)) ans else if(length(d.ans) < 2L) ans[1L][-1L]
               else array(ans, d.ans, dn.ans))
    }
    ## else
    newX <- aperm(X, c(s.call, s.ans))
    dim(newX) <- c(prod(d.call), d2)
    ans <- vector("list", d2)
    if(length(d.call) < 2L) {# vector
        if (length(dn.call)) dimnames(newX) <- c(dn.call, list(NULL))
        for(i in 1L:d2) {
            tmp <- forceAndCall(1, FUN, newX[,i], ...)
            if(!is.null(tmp)) ans[[i]] <- tmp
        }
    } else
       for(i in 1L:d2) {
           tmp <- forceAndCall(1, FUN, array(newX[,i], d.call, dn.call), ...)
           if(!is.null(tmp)) ans[[i]] <- tmp
        }

    ## answer dims and dimnames

    ans.list <- !simplify || is.recursive(ans[[1L]])
    l.ans <- length(ans[[1L]])

    ans.names <- names(ans[[1L]])
    if(!ans.list)
	ans.list <- any(lengths(ans) != l.ans)
    if(!ans.list && length(ans.names)) {
        all.same <- vapply(ans, function(x) identical(names(x), ans.names), NA)
        if (!all(all.same)) ans.names <- NULL
    }
    len.a <- if(ans.list) d2 else length(ans <- unlist(ans, recursive = FALSE))
    if(length(MARGIN) == 1L && len.a == d2) {
	names(ans) <- if(length(dn.ans[[1L]])) dn.ans[[1L]] # else NULL
	ans
    }
    else if(len.a == d2)
	array(ans, d.ans, dn.ans)
    else if(len.a && len.a %% d2 == 0L) {
        if(is.null(dn.ans)) dn.ans <- vector(mode="list", length(d.ans))
	dn1 <- list(ans.names)
	if(length(dn.call) && !is.null(n1 <- names(dn <- dn.call[1])) &&
	   nzchar(n1) && length(ans.names) == length(dn[[1]]))
	    names(dn1) <- n1
	dn.ans <- c(dn1, dn.ans)
	array(ans, c(len.a %/% d2, d.ans),
	      if(!is.null(names(dn.ans)) || !all(vapply(dn.ans, is.null, NA)))
		  dn.ans)
    } else
	ans
}
