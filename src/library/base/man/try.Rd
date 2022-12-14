% File src/library/base/man/try.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2021 R Core Team
% Distributed under GPL 2 or later

\name{try}
\alias{try}
\title{Try an Expression Allowing Error Recovery}
\description{
  \code{try} is a wrapper to run an expression that might fail and allow
  the user's code to handle error-recovery.
}
\usage{
try(expr, silent = FALSE,
    outFile = getOption("try.outFile", default = stderr()))
}
\arguments{
  \item{expr}{an \R expression to try.}
  \item{silent}{logical: should the report of error messages be
     suppressed?}
  \item{outFile}{a \link{connection}, or a character string naming the
    file to print to (via \code{\link{cat}(*, file = outFile)});
    used only if \code{silent} is false, as by default.}
}
\details{
  \code{try} evaluates an expression and traps any errors that occur
  during the evaluation.  If an error occurs then the error
  message is printed to the \code{\link{stderr}} connection unless
  \code{options("show.error.messages")} is false or
  the call includes \code{silent = TRUE}.  The error message is also
  stored in a buffer where it can be retrieved by
  \code{geterrmessage}. (This should not be needed as the value returned
  in case of an error contains the error message.)

  \code{try} is implemented using \code{\link{tryCatch}}; for
  programming, instead of \code{try(expr, silent = TRUE)}, something like
  \code{tryCatch(expr, error = function(e) e)} (or other simple
  error handler functions) may be more efficient and flexible.

  It may be useful to set the default for \code{outFile} to
  \code{\link{stdout}()}, i.e., \preformatted{  options(try.outFile = stdout()) }
  instead of the default \code{\link{stderr}()},
  notably when \code{try()} is used inside a \code{\link{Sweave}} code
  chunk and the error message should appear in the resulting document.
}
\value{
  The value of the expression if \code{expr} is evaluated without error:
  otherwise an invisible object inheriting from class \code{"try-error"}
  containing the error message with the error condition as the
  \code{"condition"} attribute.
}
\section{Warning}{
  Do not test\preformatted{
    if (class(res) == "try-error"))
}
  as if there is no error, the result might (now or in future) have a
  class of length > 1. Use \code{if(\link{inherits}(res, "try-error"))}
  instead.
}
\seealso{
  \code{\link{options}} for setting error handlers and suppressing the
  printing of error messages;
  \code{\link{geterrmessage}} for retrieving the last error message.
  The underlying \code{\link{tryCatch}} provides more flexible means of
  catching and handling errors.

  \code{\link{assertCondition}} in package \pkg{tools} is related and
  useful for testing.
}
\examples{
## this example will not work correctly in example(try), but
## it does work correctly if pasted in
options(show.error.messages = FALSE)
try(log("a"))
print(.Last.value)
options(show.error.messages = TRUE)

## alternatively,
print(try(log("a"), TRUE))

## run a simulation, keep only the results that worked.
set.seed(123)
x <- stats::rnorm(50)
doit <- function(x)
{
    x <- sample(x, replace = TRUE)
    if(length(unique(x)) > 30) mean(x)
    else stop("too few unique points")
}
## alternative 1
res <- lapply(1:100, function(i) try(doit(x), TRUE))
## alternative 2
\dontrun{res <- vector("list", 100)
for(i in 1:100) res[[i]] <- try(doit(x), TRUE)}
unlist(res[sapply(res, function(x) !inherits(x, "try-error"))])
}
\keyword{programming}
