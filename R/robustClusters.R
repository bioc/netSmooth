#' Perform robust clustering on dataset, and calculate the proportion of
#' samples in robust clusters
#' @param x    matrix or SummarizedExperiment object
#' @param dimReduceFlavor    algorithm for dimensionality reduction step
#'                           of clustering procedure. May be 'pca', 'tsne',
#'                           'dm' or 'auto', which uses shannon entropy to
#'                           pick the algorithm.
#' @param is.counts    logical: is the data counts
#' @param ...    arguments passed on to `clusterExperimentWorkflow`
#' @return list(clusters, proportion.robust)
#' @examples
#' x <- cbind(matrix(rexp(60000, rate=.1), ncol=100) + 1000*rexp(600, rate=.9),
#'            matrix(rexp(30000, rate=.5), ncol=50) + 1*rexp(600, rate=.9))
#' robustClusters(x)
#' @export
robustClusters <- function(x, dimReduceFlavor='auto', is.counts=TRUE, ...) {
    if(class(x)=='matrix') {
        x <- x
        se <- SummarizedExperiment::SummarizedExperiment(x)
    } else if(class(x)=='SummarizedExperiment') {
        se <- x
        x <- assay(x)
    } else stop("must be matrix or SummarizedExperiment object")
    if(dimReduceFlavor=='auto') {
        dimReduceFlavor <- pickDimReduction(x,
                                            flavors=c('pca', 'tsne'), is.counts=is.counts)
        cat(paste0("Picked dimReduceFlavor: ",dimReduceFlavor,"\n"))
    }
    yhat <- clusterExperimentWorkflow(se, is.counts=is.counts,
                                      dimReduceFlavor=dimReduceFlavor, ...)
    proportion.robust <- mean(yhat!=-1)
    return(list(clusters=yhat, proportion.robust=proportion.robust))
}