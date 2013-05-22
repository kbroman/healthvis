#' Create heat map of correlation matrix linked to scatterplots
#'
#' \code{corrScatterVis} takes a matrix input and optionally a correlation
#' matrix (otherwise, it's calculated), potentially sorts the columns
#' using hierarchical clustering, and makes a heat map of the correlation
#' matrix with each pixel linked to the corresponding scatterplot.
#' 
#' @param mat The data matrix
#' @param group Optional vector of groups for coloring points, length = nrow(mat)
#' @param corrmatrix Optional correlation matrix, dim = ncol(mat) x ncol(mat)
#' @param reorder If TRUE, reorder columns using hierarchical clustering
#' @param plot.title The title of the plot to appear on the HTML page
#' @param circleRadius Radius (in pixels) of points in scatterplot
#' @param plot If TRUE a browser launches and displays the interactive graphic.
#' @param gaeDevel use the appengine local dev server (for testing only, users should ignore)
#' @return healthvisObj An object of class "healthvis" containing the HTML, Javascript,
#' and CSS code needed to generate the interactive graphic
#' @export
#' @examples
#' testData <- t(t(matrix(rnorm(100*50), ncol=50) + rnorm(100))*sample(c(-1,1), 50, replace=TRUE))
#' corrScatterVis(testData)

corrScatterVis <- function(mat, group, corrmatrix, reorder=TRUE,
                           plot.title="Many box plots", circleRadius = 3,
                           plot=TRUE, gaeDevel=TRUE, url=NULL, ...){
  
  if(is.null(rownames(mat)))
    rownames(mat) <- paste0("ind", 1:nrow(mat))
  if(is.null(colnames(mat)))
    colnames(mat) <- paste0("var", 1:ncol(mat))

  indnames <- rownames(mat)
  varnames <- colnames(mat)

  if(missing(group))
    group <- rep(1, nrow(mat))

  if(nrow(mat) != length(group))
    stop("nrow(mat) != length(group)")
  if(!is.null(names(group)) && !all(names(group) == indnames))
    stop("names(group) != rownames(mat)")

  # correlation matrix
  if(missing(corrmatrix))
    corrmatrix <- cor(mat, use="pairwise.complete.obs")
  else if(ncol(corrmatrix) != ncol(mat) || nrow(corrmatrix) != ncol(mat))
      stop("corrmatrix is not the correct size")

  # order variables by clustering
  if(reorder) {
    ord <- hclust(dist(t(mat)), method="ward")$order
    variables <- variables[ord]
    mat <- mat[,ord]
    corrmatrix <- corrmatrix[ord,ord]
  }

  # get rid of names
  dimnames(corrmatrix) <- dimnames(mat) <- NULL
  names(group) <- NULL

  require(df2json)
  d3Params <- list(ind = indnames,
                   var = varnames,
                   corr = df2json::matrix2json(corrmatrix),
                   mat = df2json::matrix2json(mat),
                   group=group,
                   circleRadius = circleRadius)
  
  # Initialize healthvis object
  healthvisObj <- new("healthvis",
                      plotType="corrScatter",
                      plotTitle=plot.title,
                      varType="",
                      varList=list(" "=" "),
                      d3Params=d3Params,
                      gaeDevel=gaeDevel,
                      url=url)
  
  if(plot){
    plot(healthvisObj)
  }
  
  return(healthvisObj)
}
