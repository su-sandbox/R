% File src/library/stats/man/read.ftable.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2021 R Core Team
% Copyright 2002-2013 The R Foundation
% Distributed under GPL 2 or later

\name{read.ftable}
\title{Manipulate Flat Contingency Tables}
\alias{read.ftable}
\alias{write.ftable}
\alias{format.ftable}
\alias{print.ftable}
\description{
  Read, write and coerce \sQuote{flat} (contingency) tables, aka
  \code{ftable}s.
}
\usage{
read.ftable(file, sep = "", quote = "\"",
            row.var.names, col.vars, skip = 0)

write.ftable(x, file = "", quote = TRUE, append = FALSE,
             digits = getOption("digits"), sep = " ", \dots)

\method{format}{ftable}(x, quote = TRUE, digits = getOption("digits"),
       method = c("non.compact", "row.compact", "col.compact", "compact"),
       lsep = " | ",
       justify = c("left", "right"),
       \dots)

\method{print}{ftable}(x, digits = getOption("digits"), \dots)
}
\arguments{
  \item{file}{either a character string naming a file or a \code{\link{connection}}
    which the data are to be read from or written to.  \code{""}
    indicates input from the console for reading and output to the
    console for writing.}
  \item{sep}{the field separator string.  Values on each line of the file
    are separated by this string.}
  \item{quote}{a character string giving the set of quoting characters
    for \code{read.ftable}; to disable quoting altogether, use
    \code{quote=""}.  For \code{write.table}, a logical indicating
    whether strings in the data will be surrounded by double quotes.}
  \item{row.var.names}{a character vector with the names of the row
    variables, in case these cannot be determined automatically.}
  \item{col.vars}{a list giving the names and levels of the column
    variables, in case these cannot be determined automatically.}
  \item{skip}{the number of lines of the data file to skip before
    beginning to read data.}
  \item{x}{an object of class \code{"ftable"}.}
  \item{append}{logical.  If \code{TRUE} and \code{file} is the name of
    a file (and not a connection or \code{"|cmd"}), the output from
    \code{write.ftable} is appended to the file.  If \code{FALSE},
    the contents of \code{file} will be overwritten.}
  \item{digits}{an integer giving the number of significant digits to
    use for (the cell entries of) \code{x}.}
  \item{method}{string specifying how the \code{"ftable"} object is formatted
    (and printed if used as in \code{write.ftable()} or the \code{print}
    method).  Can be abbreviated.  Available methods are (see the examples):
    \describe{
      \item{"non.compact"}{the default representation of an
        \code{"ftable"} object.}
      \item{"row.compact"}{a row-compact version without empty cells
        below the column labels.}
      \item{"col.compact"}{a column-compact version without empty cells
        to the right of the row labels.}
      \item{"compact"}{a row- and column-compact version.  This may imply
        a row and a column label sharing the same cell.  They are then
        separated by the string \code{lsep}.}
    }
  }
  \item{lsep}{only for \code{method = "compact"}, the separation string
    for row and column labels.}
  \item{justify}{\code{\link{character}} vector of length (one or) two,
    specifying how string justification should happen in \code{format(..)},
    first for the labels, then the table entries.}
  \item{\dots}{further arguments to be passed to or
    from methods; for \code{write()} and \code{print()}, notably
    arguments such as \code{method}, passed to \code{format()}.}
}
\details{
  \code{read.ftable} reads in a flat-like contingency table from a
  file.  If the file contains the written representation of a flat
  table (more precisely, a header with all information on names and
  levels of column variables, followed by a line with the names of the
  row variables), no further arguments are needed.  Similarly, flat
  tables with only one column variable the name of which is the only
  entry in the first line are handled automatically.  Other variants can
  be dealt with by skipping all header information using \code{skip},
  and providing the names of the row variables and the names and levels
  of the column variable using \code{row.var.names} and \code{col.vars},
  respectively.  See the examples below.

  Note that flat tables are characterized by their \sQuote{ragged}
  display of row (and maybe also column) labels.  If the full grid of
  levels of the row variables is given, one should instead use
  \code{\link{read.table}} to read in the data, and create the
  contingency table from this using \code{\link{xtabs}}.

  \code{write.ftable} writes a flat table to a file, which is useful for
  generating \sQuote{pretty} ASCII representations of contingency
  tables.  Different versions are available via the \code{method}
  argument, which may be useful, for example, for constructing LaTeX tables.
}
\seealso{
  \code{\link{ftable}} for more information on flat contingency tables.
}
\references{
  Agresti, A. (1990)
  \emph{Categorical data analysis}.
  New York: Wiley.
}
\examples{
## Agresti (1990), page 157, Table 5.8.
## Not in ftable standard format, but o.k.
file <- tempfile()
cat("             Intercourse\n",
    "Race  Gender     Yes  No\n",
    "White Male        43 134\n",
    "      Female      26 149\n",
    "Black Male        29  23\n",
    "      Female      22  36\n",
    file = file)
\donttest{file.show(file)}
ft1 <- read.ftable(file)
ft1
unlink(file)

## Agresti (1990), page 297, Table 8.16.
## Almost o.k., but misses the name of the row variable.
file <- tempfile()
cat("                      \"Tonsil Size\"\n",
    "            \"Not Enl.\" \"Enl.\" \"Greatly Enl.\"\n",
    "Noncarriers       497     560           269\n",
    "Carriers           19      29            24\n",
    file = file)
\donttest{file.show(file)}
ft <- read.ftable(file, skip = 2,
                  row.var.names = "Status",
                  col.vars = list("Tonsil Size" =
                      c("Not Enl.", "Enl.", "Greatly Enl.")))
ft
unlink(file)

ft22 <- ftable(Titanic, row.vars = 2:1, col.vars = 4:3)
write.ftable(ft22, quote = FALSE) # is the same as
print(ft22)#method="non.compact" is default
print(ft22, method="row.compact")
print(ft22, method="col.compact")
print(ft22, method="compact")

## using 'justify' and 'quote' :
format(ftable(wool + tension ~ breaks, warpbreaks),
       justify = "none", quote = FALSE)
\dontshow{
 op <- options(warn = 2) # no warnings allowed
 stopifnot(dim(format(ft)) == 4:5,
	   dim(format(ftable(UCBAdmissions))) == c(6,9))
 meths <- c("non.compact", "row.compact", "col.compact", "compact")
 dimform <-
    function(ft) sapply(meths, function(M) dim(format(ft, method = M)))
 m.eq    <- function(M,m) all.equal(unname(M), m, tolerance = 0)
 ## All format(..) w/o warnings:
 stopifnot(m.eq(print(dimform(ft22)),
		rbind(11:10, rep(7:6, each = 2))),
	   m.eq(print(dimform(ftable(Titanic, row.vars = integer()))),
		rbind(rep(6:5,2), 33)))
 options(op)
}
}
\keyword{category}
