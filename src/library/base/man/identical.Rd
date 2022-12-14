% File src/library/base/man/identical.Rd
% Part of the R package, https://www.R-project.org
% Copyright 2001-2021 R Core Team
% Distributed under GPL 2 or later

\name{identical}
\alias{identical}
\title{Test Objects for Exact Equality}
\description{
  The safe and reliable way to test two objects for being
  \emph{exactly} equal.  It returns \code{TRUE} in this case,
  \code{FALSE} in every other case.
}
\usage{
identical(x, y, num.eq = TRUE, single.NA = TRUE, attrib.as.set = TRUE,
          ignore.bytecode = TRUE, ignore.environment = FALSE,
          ignore.srcref = TRUE, extptr.as.ref = FALSE)
}
\arguments{
  \item{x, y}{any \R objects.}
  \item{num.eq}{logical indicating if (\code{\link{double}} and
    \code{\link{complex}} non-\code{\link{NA}}) numbers should be
    compared using \code{\link{==}} (\sQuote{equal}), or by bitwise
    comparison.  The latter (non-default) differentiates between
    \code{-0} and \code{+0}.}
  \item{single.NA}{logical indicating if there is conceptually just one numeric
    \code{\link{NA}} and one \code{\link{NaN}};  \code{single.NA = FALSE}
    differentiates bit patterns.}
  \item{attrib.as.set}{logical indicating if \code{\link{attributes}} of
    \code{x} and \code{y} should be treated as \emph{unordered} tagged
    pairlists (\dQuote{sets}); this currently also applies to
    \code{\link{slot}}s of S4 objects.  It may well be too strict to set
    \code{attrib.as.set = FALSE}.}
  \item{ignore.bytecode}{logical indicating if byte code should be
    ignored when comparing \link{closure}s.}
  \item{ignore.environment}{logical indicating if their environments
    should be ignored when comparing \link{closure}s.}
  \item{ignore.srcref}{logical indicating if their \code{"srcref"}
    attributes should be ignored when comparing \link{closure}s.}
  \item{extptr.as.ref}{logical indicating whether external pointer
    objects should be compared as reference objects and considered
    identical only if they are the same object in memory. By default,
    external pointers are considered identical if the addresses they
    contain are identical.}
}
\details{
  A call to \code{identical} is the way to test exact equality in
  \code{if} and \code{while} statements, as well as in logical
  expressions that use \code{&&} or \code{||}.  In all these
  applications you need to be assured of getting a single logical
  value.

  Users often use the comparison operators, such as \code{==} or
  \code{!=}, in these situations.  It looks natural, but it is not what
  these operators are designed to do in \R.  They return an object like
  the arguments.  If you expected \code{x} and \code{y} to be of length
  1, but it happened that one of them was not, you will \emph{not} get a
  single \code{FALSE}.  Similarly, if one of the arguments is \code{NA},
  the result is also \code{NA}.  In either case, the expression
  \code{if(x == y)....} won't work as expected.

  The function \code{all.equal} is also sometimes used to test equality
  this way, but was intended for something different:  it allows for
  small differences in numeric results.

  The computations in \code{identical} are also reliable and usually
  fast.  There should never be an error.  The only known way to kill
  \code{identical} is by having an invalid pointer at the C level,
  generating a memory fault.  It will usually find inequality quickly.
  Checking equality for two large, complicated objects can take longer
  if the objects are identical or nearly so, but represent completely
  independent copies.  For most applications, however, the computational cost
  should be negligible.

  If \code{single.NA} is true, as by default, \code{identical} sees
  \code{\link{NaN}} as different from \code{\link{NA_real_}}, but all
  \code{NaN}s are equal (and all \code{NA} of the same type are equal).

  Character strings (except those in marked encoding \code{"bytes"}) are
  regarded as identical even if they are in different marked encodings but
  would agree when translated to UTF-8. A character string in marked encoding
  \code{"bytes"} is only regarded as identical to a character string in the
  same encoding and with the same content.

  If \code{attrib.as.set} is true, as by default, comparison of
  attributes view them as a set (and not a vector, so order is not
  tested).

  If \code{ignore.bytecode} is true (the default), the compiled
  bytecode of a function (see \code{\link{cmpfun}}) will be ignored in
  the comparison.  If it is false, functions will compare equal only if
  they are copies of the same compiled object (or both are
  uncompiled).  To check whether two different compiles are equal, you
  should compare the results of \code{\link{disassemble}()}.

  You almost never want to use \code{identical} on datetimes of class
  \code{"POSIXlt"}: not only can different times in the different
  time zones represent the same time and time zones have multiple names,
  but several of the components are optional.

  Note that the strictest test for equality is
  \preformatted{
    identical(x, y,
              num.eq = FALSE, single.NA = FALSE, attrib.as.set = FALSE,
              ignore.bytecode = FALSE, ignore.environment = FALSE,
              ignore.srcref = FALSE, extptr.as.ref = TRUE)
}
	     
}
\value{
  A single logical value, \code{TRUE} or \code{FALSE}, never \code{NA}
  and never anything other than a single value.
}
\author{John Chambers and R Core}

\references{
  Chambers, J. M. (1998)
  \emph{Programming with Data.  A Guide to the S Language}.
  Springer.
}
\seealso{
  \code{\link{all.equal}} for descriptions of how two objects differ;
  \code{\link{Comparison}} and \code{\link{Logic}} for elementwise comparisons.
}
\examples{
identical(1, NULL) ## FALSE -- don't try this with ==
identical(1, 1.)   ## TRUE in R (both are stored as doubles)
identical(1, as.integer(1)) ## FALSE, stored as different types

x <- 1.0; y <- 0.99999999999
## how to test for object equality allowing for numeric fuzz :
(E <- all.equal(x, y))
identical(TRUE, E)
isTRUE(E) # alternative test
## If all.equal thinks the objects are different, it returns a
## character string, and the above expression evaluates to FALSE

## even for unusual R objects :
identical(.GlobalEnv, environment())

### ------- Pickyness Flags : -----------------------------

## the infamous example:
identical(0., -0.) # TRUE, i.e. not differentiated
identical(0., -0., num.eq = FALSE)
## similar:
identical(NaN, -NaN) # TRUE
identical(NaN, -NaN, single.NA = FALSE) # differ on bit-level

### For functions ("closure"s): ----------------------------------------------
###     ~~~~~~~~~
f <- function(x) x
f
g <- compiler::cmpfun(f)
g
identical(f, g)                        # TRUE, as bytecode is ignored by default
identical(f, g, ignore.bytecode=FALSE) # FALSE: bytecode differs

## GLM families contain several functions, some of which share an environment:
p1 <- poisson() ; p2 <- poisson()
identical(p1, p2)                          # FALSE
identical(p1, p2, ignore.environment=TRUE) # TRUE

## in interactive use, the 'keep.source' option is typically true:
op <- options(keep.source = TRUE) # and so, these have differing "srcref" :
f1 <- function() {}
f2 <- function() {}
identical(f1,f2)# ignore.srcref= TRUE : TRUE
identical(f1,f2,  ignore.srcref=FALSE)# FALSE
options(op) # revert to previous state

\dontshow{
m0 <- m <- structure(cbind(I = 1, a = 1:3), foo = "bar", class = "matrix")
attributes(m0) <- rev(attributes(m))
names(attributes(m0)) # 'dim' remains first, interestingly...

stopifnot(identical(0, -0),     !identical(0, -0, num.eq = FALSE),
          identical(NaN, -NaN), !identical(NaN, -NaN, single.NA = FALSE),
          identical(m, m0),     !identical(m, m0, attrib.as.set = FALSE) )
}
}
\keyword{ programming }
\keyword{ logic }
\keyword{ iteration }
