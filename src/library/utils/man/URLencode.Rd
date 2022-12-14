% File src/library/utils/man/URLencode.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2015 R Core Team
% Distributed under GPL 2 or later

\name{URLencode}
\alias{URLencode}
\alias{URLdecode}
\title{Encode or Decode (partial) URLs}
\description{
  Functions to percent-encode or decode characters in URLs.
}
\usage{
URLencode(URL, reserved = FALSE, repeated = FALSE)
URLdecode(URL)
}
\arguments{
  \item{URL}{a character vector.}
  \item{reserved}{logical: should \sQuote{reserved} characters be
    encoded? See \sQuote{Details}.}
  \item{repeated}{logical: should apparently already-encoded URLs be
    encoded again?}
}
\details{
  Characters in a URL other than the English alphanumeric characters and
  \samp{- _ . ~} should be encoded as \code{\%}
  plus a two-digit hexadecimal representation, and any single-byte
  character can be so encoded. (Multi-byte characters are encoded
  byte-by-byte.)  The standard refers to this as \sQuote{percent-encoding}.

  In addition, \samp{! $ & ' ( ) * + , ; = : / ? @ # [ ]} are reserved
  characters, and should be encoded unless used in their reserved sense,
  which is scheme specific.  The default in \code{URLencode} is to leave
  them alone, which is appropriate for \samp{file://} URLs, but probably
  not for \samp{http://} ones.

  An \sQuote{apparently already-encoded URL} is one containing
  \code{\%xx} for two hexadecimal digits.
}
\value{
  A character vector.
}
\references{
  Internet STD 66 (formerly RFC 3986),
  \url{https://www.rfc-editor.org/info/std66}
}
\examples{
(y <- URLencode("a url with spaces and / and @"))
URLdecode(y)
(y <- URLencode("a url with spaces and / and @", reserved = TRUE))
URLdecode(y)

URLdecode(z <- "ab\%20cd")
c(URLencode(z), URLencode(z, repeated = TRUE)) # first is usually wanted

## both functions support character vectors of length > 1
y <- URLdecode(URLencode(c("url with space", "another one")))
}
\keyword{utilities}
