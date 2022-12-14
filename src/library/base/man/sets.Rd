% File src/library/base/man/sets.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2011 R Core Team
% Distributed under GPL 2 or later

\name{sets}
\alias{union}
\alias{intersect}
\alias{setdiff}
\alias{is.element}
\alias{setequal}
\concept{set operations}
\concept{sets} % not that useful for searches, but requested in a bug report
\alias{intersection}
\concept{difference}

\title{Set Operations}
\usage{
union(x, y)
intersect(x, y)
setdiff(x, y)
setequal(x, y)

is.element(el, set)
}
\arguments{
  \item{x, y, el, set}{vectors (of the same mode) containing a sequence
    of items (conceptually) with no duplicated values.}
}
\description{
  Performs \bold{set} union, intersection, (asymmetric!) difference,
  equality and membership on two vectors.
}
\details{
  Each of \code{union}, \code{intersect}, \code{setdiff} and
  \code{setequal} will discard any duplicated values in the arguments,
  and they apply \code{\link{as.vector}} to their arguments (and so
  in particular coerce factors to character vectors).

  \code{is.element(x, y)} is identical to \code{x \%in\% y}.
}
\value{
  For \code{union}, a vector of a common mode.

  For \code{intersect}, a vector of a common mode, or \code{NULL} if
  \code{x} or \code{y} is \code{NULL}.

  For \code{setdiff}, a vector of the same \code{\link{mode}} as \code{x}.

  A logical scalar for \code{setequal} and a logical of the same
  length as \code{x} for \code{is.element}.
}
\seealso{
  \code{\link{\%in\%}}

  \sQuote{\link{plotmath}} for the use of \code{union} and
  \code{intersect} in plot annotation.
}

\examples{
(x <- c(sort(sample(1:20, 9)), NA))
(y <- c(sort(sample(3:23, 7)), NA))
union(x, y)
intersect(x, y)
setdiff(x, y)
setdiff(y, x)
setequal(x, y)

## True for all possible x & y :
setequal( union(x, y),
          c(setdiff(x, y), intersect(x, y), setdiff(y, x)))

is.element(x, y) # length 10
is.element(y, x) # length  8
}
\keyword{misc}
