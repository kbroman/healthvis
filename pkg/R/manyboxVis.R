#' Create 'many box plots' visualization: interactive, modernized box plots
#'
#' \code{manyboxVis} takes a matrix input, calculates a set of quantiles for
#' each column, potentially sorts the columns by the median, and makes a plot
#' with the quantiles connected by lines, linked to histograms of the underlying
#' data.
#'
#' @param mat The data matrix
#' @param qu  Lower quantiles to plot, a vector of values in (0, 0.5)
#' @param orderByMedian If TRUE, reorder columns by their medians
#' @param breaks No. breaks or actual breaks for histograms
#' @param plot.title The title of the plot to appear on the HTML page
#' @param ylab Label for y-axis
#' @param xlab Label for x-axis
#' @param plot If TRUE a browser launches and displays the interactive graphic.
#' @param gaeDevel use the appengine local dev server (for testing only, users should ignore)
#' @return healthvisObj An object of class "healthvis" containing the HTML, Javascript,
#' and CSS code needed to generate the interactive graphic
#' @export
#' @examples
#' testData <- t(matrix(rnorm(10000*100), nrow=100) + runif(100, 0, 2))
#' manyboxVis(testData)

manyboxVis <- function(mat, qu=c(0.01, 0.1, 0.25), orderByMedian=TRUE,
                       breaks=251, plot.title="Many box plots",
                       ylab="Response", xlab="Individuals, sorted by median",
                       plot=TRUE, gaeDevel=TRUE,url=NULL,...){
  
  if(class(mat) != "matrix"){
	stop("mat must be a matrix object")
  }
   
  if(is.null(colnames(mat)))
    colnames(mat) <- paste0(1:ncol(mat))

  if(orderByMedian)
    mat <- mat[,order(apply(mat, 2, median, na.rm=TRUE)), drop=FALSE]
    
  # check quantiles
  if(any(qu <= 0)) {
    warning("qu should all be > 0")
    qu <- qu[qu > 0]
  }

  if(any(qu >= 0.5)) {
    warning("qu should all by < 0.5")
    qu <- qu[qu < 0.5]
  }

  qu <- c(qu, 0.5, rev(1-qu))
  quant <- apply(mat, 2, quantile, qu, na.rm=TRUE)

  # counts for histograms
  if(length(breaks) == 1)
    breaks <- seq(min(mat, na.rm=TRUE), max(mat, na.rm=TRUE), length=breaks)

  counts <- apply(mat, 2, function(a) hist(a, breaks=breaks, plot=FALSE)$counts)

  ind <- colnames(mat)

  dimnames(quant) <- dimnames(counts) <- NULL

  require(df2json)
  d3Params <- list(ind = ind,
                   qu = qu,
                   breaks = breaks,
                   quant = df2json::matrix2json(quant),
                   counts = df2json::matrix2json(t(counts)),
                   ylab = ylab,
                   xlab = xlab)
  
  # Initialize healthvis object
  healthvisObj <- new("healthvis",
                      plotType="manybox",
                      plotTitle=plot.title,
                      varType="factor",
                      varList=list("Not important"="-"),
                      d3Params=d3Params,
                      gaeDevel=gaeDevel,
                      url=url)
  
  if(plot){
    plot(healthvisObj)
  }
  
  return(healthvisObj)
}
