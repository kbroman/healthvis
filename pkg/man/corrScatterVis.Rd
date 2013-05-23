\name{corrScatterVis}
\alias{corrScatterVis}
\title{Create heat map of correlation matrix linked to scatterplots}
\usage{
  corrScatterVis(mat, group, corrmatrix, reorder = TRUE,
    plot.title = "Many box plots", circleRadius = 3,
    plot = TRUE, gaeDevel = TRUE, url = NULL, ...)
}
\arguments{
  \item{mat}{The data matrix}

  \item{group}{Optional vector of groups for coloring
  points, length = nrow(mat)}

  \item{corrmatrix}{Optional correlation matrix, dim =
  ncol(mat) x ncol(mat)}

  \item{reorder}{If TRUE, reorder columns using
  hierarchical clustering}

  \item{plot.title}{The title of the plot to appear on the
  HTML page}

  \item{circleRadius}{Radius (in pixels) of points in
  scatterplot}

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
  \code{corrScatterVis} takes a matrix input and optionally
  a correlation matrix (otherwise, it's calculated),
  potentially sorts the columns using hierarchical
  clustering, and makes a heat map of the correlation
  matrix with each pixel linked to the corresponding
  scatterplot.
}
\examples{
testData <- t(t(matrix(rnorm(100*50), ncol=50) + rnorm(100))*sample(c(-1,1), 50, replace=TRUE))
corrScatterVis(testData)
}

