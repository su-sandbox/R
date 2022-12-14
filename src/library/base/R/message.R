#  File src/library/base/R/message.R
#  Part of the R package, https://www.R-project.org
#
#  Copyright (C) 1995-2021 The R Core Team
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

simpleMessage <-
function(message, call = NULL)
    structure(list(message = message, call = call),
              class = c("simpleMessage", "message", "condition"))

suppressMessages <-
function(expr, classes = "message")
    withCallingHandlers(expr,
                        message = function(c)
                            if (inherits(c, classes))
                                tryInvokeRestart("muffleMessage"))

message <-
function(..., domain = NULL, appendLF = TRUE)
{
    cond <- if(...length() == 1L && inherits(..1, "condition")) {
        if(nargs() > 1L)
            warning("additional arguments ignored in message()")
        ..1
    } else {
        msg <- .makeMessage(..., domain=domain, appendLF = appendLF)
        call <- sys.call()
        simpleMessage(msg, call)
    }
    defaultHandler <- function(c) {
        ## Maybe use special connection here?
        cat(conditionMessage(c), file=stderr(), sep = "")
    }
    withRestarts({
        signalCondition(cond)
        ## We don't get to the default handler if the signal
        ## is handled with a non-local exit, e.g. by
        ## invoking the muffleMessage restart.
        defaultHandler(cond)
    }, muffleMessage = function() NULL)
    invisible()
}

## also used by warning() and stop()
.makeMessage <- function(..., domain = NULL, appendLF = FALSE)
 {
    msg <- if(...length()) {
        args <- lapply(list(...), as.character)
        if(is.null(domain) || !is.na(domain))
            args <- .Internal(gettext(domain, unlist(args), TRUE))
        paste(args, collapse = "")
    } else ""
    if(appendLF) paste0(msg, "\n") else msg
}

.packageStartupMessage <- function (message, call = NULL)
    structure(list(message = message, call = call),
              class = c("packageStartupMessage",
                        "simpleMessage", "message", "condition"))

suppressPackageStartupMessages <- function (expr)
    withCallingHandlers(expr, packageStartupMessage=function(c)
                        tryInvokeRestart("muffleMessage"))

packageStartupMessage <- function(..., domain = NULL, appendLF = TRUE)
{
    call <- sys.call()
    msg <- .makeMessage(..., domain=domain, appendLF = appendLF)
    message(.packageStartupMessage(msg, call))
}
