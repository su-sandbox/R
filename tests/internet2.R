## These are tests that require socket and internet functionality, and
## a working Internet connection.
## We attempt to test for those.

onWindows <- .Platform$OS.type == "windows"

if(.Platform$OS.type == "unix" &&
   is.null(nsl("cran.r-project.org"))) q()


## check graceful failure:
try(url("http://foo.bar", "r"))

if(onWindows)
    try(url("http://foo.bar", "r", method = "wininet"))

## download.file(.. , headers = character()) - PR#17710
tf <- tempfile()
download.file("https://cloud.r-project.org/src/base/THANKS", destfile = tf,
              method = if(onWindows) "wininet" else "libcurl",
              headers = character()) -> err.code
stopifnot(err.code == 0, file.size(tf) > 999)
## had failed for the Windows case


## everything from here on is directly over sockets
if(!capabilities("sockets")) stop("no socket capabilities")

# do the same thing via sockets (cut-down httpclient)
httpget <- function (url, port = 80)
{
    urlel <- strsplit(url, "/")[[1]]
    if (urlel[1] != "http:") stop("Not an http:// URL")
    host <- urlel[3]
    rurl <- paste(c("", urlel[-(1:3)]), collapse = "/")
    a <- make.socket(host, port = port)
    on.exit(close.socket(a))
    headreq <- paste("HEAD", rurl, "HTTP/1.0\r\nConnection: Keep-Alive\r\nAccept: text/plain\r\n\r\n")
    write.socket(a, headreq)
    head <- read.socket(a, maxlen = 8000)
    b <- strsplit(head, "\n")[[1]]
    if (length(grep("200 OK", b[1])) == 0) stop(b[1])
    len <- as.numeric(strsplit(grep("Content-Length", b, value = TRUE),
                               ":")[[1]][2])
    getreq <- paste("GET", rurl, "HTTP/1.0\r\nConnection: Keep-Alive\r\nAccept: text/plain\r\n\r\n")
    write.socket(a, getreq)
    junk <- read.socket(a, maxlen = nchar(head))
    data <- ""
    b <- strsplit(c(head, junk), "\n")
    nn <- length(b[[1]])
    if (length(b[[2]]) > nn)
        data <- paste(b[[2]][-(1:nn)], collapse = "\n")
    while (nchar(data) < len) {
        new_data <- read.socket(a, maxlen = len - nchar(data))
        if (new_data == "") break
        data <- paste(data, new_data, sep = "")
    }
    strsplit(data, "\n")[[1]]
}

if(nzchar(Sys.getenv("http_proxy")) || nzchar(Sys.getenv("HTTP_PROXY"))) {
    cat("http proxy is set, so skip test of http over sockets\n")
} else {
## 2022-04-07: now redirects to https://
##    f <- httpget("http://www.stats.ox.ac.uk/pub/datasets/csb/ch11b.dat")
    f <- httpget("http://httpbin.org/get")
    str(f)
    if (!length(grep('"headers":', f))) stop("Data not fetched via socket")
}
