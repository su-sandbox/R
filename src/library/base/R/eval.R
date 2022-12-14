#  File src/library/base/R/eval.R
#  Part of the R package, https://www.R-project.org
#
#  Copyright (C) 1995-2017 The R Core Team
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

.GlobalEnv <- environment()
parent.frame <- function(n = 1) .Internal(parent.frame(n))

eval <-
    function(expr, envir = parent.frame(),
	     enclos = if(is.list(envir) || is.pairlist(envir))
                       parent.frame() else baseenv())
    .Internal(eval(expr, envir, enclos))

eval.parent <- function(expr, n = 1) {
    p <- parent.frame(n + 1)
    eval(expr, p)
}

evalq <-
    function (expr, envir = parent.frame(), enclos = if (is.list(envir) ||
    is.pairlist(envir)) parent.frame() else baseenv())
      .Internal(eval(substitute(expr), envir, enclos))

new.env <- function (hash = TRUE, parent = parent.frame(), size = 29L)
    .Internal(new.env(hash, parent, size))

parent.env <- function(env)
    .Internal(parent.env(env))

`parent.env<-` <- function(env, value)
    .Internal("parent.env<-"(env, value))

local <-
    function (expr, envir = new.env())
    eval.parent(substitute(eval(quote(expr), envir)))

Recall <- function(...) .Internal(Recall(...))

with <- function(data, expr, ...) UseMethod("with")
within <- function(data, expr, ...) UseMethod("within")

with.default <- function(data, expr, ...)
    eval(substitute(expr), data, enclos=parent.frame())

within.data.frame <- function(data, expr, ...)
{
    parent <- parent.frame()
    e <- evalq(environment(), data, parent)
    eval(substitute(expr), e)
    l <- as.list(e, all.names=TRUE)
    l <- l[!vapply(l, is.null, NA, USE.NAMES=FALSE)]
    nl <- names(l)
    ## del: variables to *del*ete from data[]; keep non-NULL ones
    del <- setdiff(names(data), nl)
    data[ nl] <- l
    data[del] <- NULL
    data
}

within.list <- function(data, expr, keepAttrs = TRUE, ...)
{
    parent <- parent.frame()
    e <- evalq(environment(), data, parent)
    eval(substitute(expr), e)
    if(keepAttrs) { # names() kept in original order; also other attributes
	l <- as.list(e, all.names=TRUE)
        nl <- names(l)
	del <- setdiff(names(data), nl) # variables to delete
	data[ nl] <- l
	data[del] <- NULL
	data
    } else { # (order should not matter in *named* list)
	as.list(e, all.names=TRUE)
    }
}




force <- function(x) x
