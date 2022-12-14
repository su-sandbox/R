% File src/library/base/man/dput.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2022 R Core Team
% Distributed under GPL 2 or later

\name{dput}
\alias{dput}
\alias{dget}
\title{Write an Object to a File or Recreate it}
\description{
  Writes an ASCII text representation of an \R object to a file, the \R
  console, or a connection, or uses one to recreate the object.
}
\usage{
dput(x, file = "",
     control = c("keepNA", "keepInteger", "niceNames", "showAttributes"))

dget(file, keep.source = FALSE)
}
\arguments{
  \item{x}{an object.}
  \item{file}{either a character string naming a file or a
    \link{connection}. \code{""} indicates output to the console.}
  \item{control}{character vector (or \code{NULL}) of deparsing options.
    \code{control = "all"} is thorough, see \code{\link{.deparseOpts}}.}
  \item{keep.source}{logical: should the source formatting be retained when
    parsing functions, if possible?}
}
\details{
  \code{dput} opens \code{file} and deparses the object \code{x} into
  that file.  The object name is not written (unlike \code{dump}).
  If \code{x} is a function the associated environment is stripped.
  Hence scoping information can be lost.

  Deparsing an object is difficult, and not always possible.  With the
  default \code{control}, \code{dput()} attempts to deparse in a way
  that is readable, but for more complex or unusual objects (see
  \code{\link{dump}}), not likely
  to be parsed as identical to the original.  Use \code{control = "all"}
  for the most complete deparsing; use \code{control = NULL} for the
  simplest deparsing, not even including attributes.

  \code{dput} will warn if fewer characters were written to a file than
  expected, which may indicate a full or corrupt file system.

  To display saved source rather than deparsing the internal
  representation include \code{"useSource"} in \code{control}.  \R
  currently saves source only for function definitions.  If you do not
  care about source representation (e.g., for a data object), for speed
  set \code{options(keep.source = FALSE}) when calling \code{source}.
}
\value{
  For \code{dput}, the first argument invisibly.

  For \code{dget}, the object created.
}
\note{
  This is \bold{not} a good way to transfer objects between \R sessions.
  \code{\link{dump}} is better, but the functions \code{\link{save}} and
  \code{\link{saveRDS}} are designed to be used for transporting \R data,
  and will work with \R objects that \code{dput} does not handle correctly
  as well as being much faster.

  To avoid the risk of a source attribute out of sync with the actual
  function definition, the source attribute of a function will never
  be written as an attribute.
}
\references{
  Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988)
  \emph{The New S Language}.
  Wadsworth & Brooks/Cole.
}
\seealso{
  \code{\link{deparse}}, \code{\link{.deparseOpts}},
  \code{\link{dump}}, \code{\link{write}}.
}
\examples{
fil <- tempfile()
## Write an ASCII version of the 'base' function mean() to our temp file, ..
dput(base::mean, fil)
## ... read it back into 'bar' and confirm it is the same
bar <- dget(fil)
stopifnot(all.equal(bar, base::mean, check.environment = FALSE))

## Create a function with comments
baz <- function(x) {
  # Subtract from one
  1-x
}
## and display it
dput(baz)
## and now display the saved source
dput(baz, control = "useSource")

## Numeric values:
xx <- pi^(1:3)
dput(xx)
dput(xx, control = "digits17")
dput(xx, control = "hexNumeric")
dput(xx, fil); dget(fil) - xx # slight rounding on all platforms
dput(xx, fil, control = "digits17")
dget(fil) - xx # slight rounding on some platforms
dput(xx, fil, control = "hexNumeric"); dget(fil) - xx
unlink(fil)

xn <- setNames(xx, paste0("pi^",1:3))
dput(xn) # nicer, now "niceNames" being part of default 'control'
dput(xn, control = "S_compat") # no names
## explicitly asking for output as in R < 3.5.0:
dput(xn, control = c("keepNA", "keepInteger", "showAttributes"))
}
\keyword{file}
\keyword{programming}
\keyword{connection}
