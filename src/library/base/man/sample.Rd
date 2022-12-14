% File src/library/base/man/sample.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2022 R Core Team
% Distributed under GPL 2 or later

\name{sample}
\alias{sample}
\alias{sample.int}
\title{Random Samples and Permutations}
\description{
  \code{sample} takes a sample of the specified size from the elements
  of \code{x} using either with or without replacement.
}
\usage{
sample(x, size, replace = FALSE, prob = NULL)

sample.int(n, size = n, replace = FALSE, prob = NULL,
           useHash = (n > 1e+07 && !replace && is.null(prob) && size <= n/2))
}
\arguments{
  \item{x}{either a vector of one or more elements from which to choose,
    or a positive integer.  See \sQuote{Details.}}
  \item{n}{a positive number, the number of items to choose from.  See
    \sQuote{Details.}}
  \item{size}{a non-negative integer giving the number of items to choose.}
  \item{replace}{should sampling be with replacement?}
  \item{prob}{a vector of probability weights for obtaining the elements
    of the vector being sampled.}
  \item{useHash}{\code{\link{logical}} indicating if the hash-version of
    the algorithm should be used.  Can only be used for \code{replace =
      FALSE}, \code{prob = NULL}, and \code{size <= n/2}, and really
    should be used for large \code{n}, as \code{useHash=FALSE} will use
    memory proportional to \code{n}.}
}
\details{
  If \code{x} has length 1, is numeric (in the sense of
  \code{\link{is.numeric}}) and \code{x >= 1}, sampling \emph{via}
  \code{sample} takes place from \code{1:x}.  \emph{Note} that this
  convenience feature may lead to undesired behaviour when \code{x} is
  of varying length in calls such as \code{sample(x)}.  See the examples.

  Otherwise \code{x} can be any \R object for which \code{length} and
  subsetting by integers make sense: S3 or S4 methods for these
  operations will be dispatched as appropriate.

  For \code{sample} the default for \code{size} is the number of items
  inferred from the first argument, so that \code{sample(x)} generates a
  random permutation of the elements of \code{x} (or \code{1:x}).

  It is allowed to ask for \code{size = 0} samples with \code{n = 0} or
  a length-zero \code{x}, but otherwise \code{n > 0} or positive
  \code{length(x)} is required.

  Non-integer positive numerical values of \code{n} or \code{x} will be
  truncated to the next smallest integer, which has to be no larger than
  \code{\link{.Machine}$integer.max}.

  The optional \code{prob} argument can be used to give a vector of
  weights for obtaining the elements of the vector being sampled.  They
  need not sum to one, but they should be non-negative and not all zero.
  If \code{replace} is true, Walker's alias method (Ripley, 1987) is
  used when there are more than 200 reasonably probable values: this
  gives results incompatible with those from \R < 2.2.0.

  If \code{replace} is false, these probabilities are applied
  sequentially, that is the probability of choosing the next item is
  proportional to the weights amongst the remaining items.  The number
  of nonzero weights must be at least \code{size} in this case.

  \code{sample.int} is a bare interface in which both \code{n} and
  \code{size} must be supplied as integers.

  Argument \code{n} can be larger than the largest integer of
  type \code{integer}, up to the largest representable integer in type
  \code{double}.  Only uniform sampling is supported.  Two
  random numbers are used to ensure uniform sampling of large integers.
}

\value{
  For \code{sample} a vector of length \code{size} with elements
  drawn from either \code{x} or from the integers \code{1:x}.

  For \code{sample.int}, an integer vector of length \code{size} with
  elements from \code{1:n}, or a double vector if
  \eqn{n \ge 2^{31}}{n >= 2^31}.
}

\references{
  Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988)
  \emph{The New S Language}.
  Wadsworth & Brooks/Cole.

  Ripley, B. D. (1987) \emph{Stochastic Simulation}. Wiley.
}
\seealso{
  \code{\link{RNGkind}(sample.kind = ..)} about random number generation,
  notably the change of \code{sample()} results with \R version 3.6.0.

  CRAN package \CRANpkg{sampling} for other methods of weighted sampling
  without replacement.
}
\examples{
x <- 1:12
# a random permutation
sample(x)
# bootstrap resampling -- only if length(x) > 1 !
sample(x, replace = TRUE)

# 100 Bernoulli trials
sample(c(0,1), 100, replace = TRUE)

## More careful bootstrapping --  Consider this when using sample()
## programmatically (i.e., in your function or simulation)!

# sample()'s surprise -- example
x <- 1:10
    sample(x[x >  8]) # length 2
    sample(x[x >  9]) # oops -- length 10!
    sample(x[x > 10]) # length 0

## safer version:
resample <- function(x, ...) x[sample.int(length(x), ...)]
resample(x[x >  8]) # length 2
resample(x[x >  9]) # length 1
resample(x[x > 10]) # length 0

## R 3.0.0 and later
sample.int(1e10, 12, replace = TRUE)
sample.int(1e10, 12) # not that there is much chance of duplicates
}
\keyword{distribution}
