\name{manyboxVis}
\alias{manyboxVis}
\title{Create modernized box plots linked to underlying histograms}
\usage{
  manyboxVis(mat, qu = c(0.01, 0.1, 0.25),
    orderByMedian = TRUE, breaks = 251,
    plot.title = "Many box plots", ylab = "Response",
    xlab = "Individuals, sorted by median", plot = TRUE,
    gaeDevel = TRUE, url = NULL, ...)
}
\arguments{
  \item{mat}{The data matrix}

  \item{qu}{Lower quantiles to plot, a vector of values in
  (0, 0.5)}

  \item{orderByMedian}{If TRUE, reorder columns by their
  medians}

  \item{breaks}{No. breaks or actual breaks for histograms}

  \item{plot.title}{The title of the plot to appear on the
  HTML page}

  \item{ylab}{Label for y-axis}

  \item{xlab}{Label for x-axis}

  \item{plot}{If TRUE a browser launches and displays the
  interactive graphic.}

  \item{gaeDevel}{use the appengine local dev server (for
  testing only, users should ignore)}
}
\value{
  healthvisObj An object of class "healthvis" containing
  the HTML, Javascript, and CSS code needed to generate the
  interactive graphic
}
\description{
  \code{manyboxVis} takes a matrix input, calculates a set
  of quantiles for each column, potentially sorts the
  columns by the median, and makes a plot with the
  quantiles connected by lines, linked to histograms of the
  underlying data.
}
\examples{
testData <- t(matrix(rnorm(10000*100), nrow=100) + runif(100, 0, 2))
manyboxVis(testData)
}

