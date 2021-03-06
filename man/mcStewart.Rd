% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mcStewart.R
\name{mcStewart}
\alias{mcStewart}
\title{Stewart Potentials Parallel}
\usage{
mcStewart(knownpts, unknownpts = NULL, varname, typefct = "exponential",
  span, beta, resolution = NULL, mask = NULL, cl = NULL, size = 1000,
  longlat = TRUE)
}
\arguments{
\item{knownpts}{sp object (SpatialPointsDataFrame or SpatialPolygonsDataFrame);
this is the set of known observations to estimate the potentials from.}

\item{unknownpts}{sp object (SpatialPointsDataFrame or SpatialPolygonsDataFrame); 
this is the set of unknown units for which the function computes the estimates. 
Not used when \code{resolution} is set up. (optional)}

\item{varname}{character; name of the variable in the \code{knownpts} dataframe 
from which potentials are computed. Quantitative variable with no negative values.}

\item{typefct}{character; spatial interaction function. Options are "pareto" 
(means power law) or "exponential".
If "pareto" the interaction is defined as: (1 + alpha * mDistance) ^ (-beta).
If "exponential" the interaction is defined as: 
exp(- alpha * mDistance ^ beta).
The alpha parameter is computed from parameters given by the user 
(\code{beta} and \code{span}).}

\item{span}{numeric; distance where the density of probability of the spatial 
interaction function equals 0.5.}

\item{beta}{numeric; impedance factor for the spatial interaction function.}

\item{resolution}{numeric; resolution of the output SpatialPointsDataFrame
(in map units). If resolution is not set, the grid will contain around 7250 
points. (optional)}

\item{mask}{sp object; the spatial extent of this object is used to 
create the regularly spaced SpatialPointsDataFrame output. (optional)}

\item{cl}{numeric; number of clusters. By default cl is determined using 
\code{parallel::detectCores()}.}

\item{size}{numeric; mcStewart splits unknownpts in chunks, size indicates 
the size of each chunks.}

\item{longlat}{logical; if FALSE, Euclidean distance, if TRUE Great Circle 
(WGS84 ellipsoid) distance.}
}
\value{
A Spatial*DataFrame with the computed potentials in a new field 
named \code{OUTPUT} is returned.
}
\description{
This function computes Stewart potentials using parallel 
computation.
}
\details{
The parallel implementation splits potentials computations along 
chunks of unknownpts (or chunks of the grid defined using resolution). It only 
uses Great Cercle distances (with \code{\link{CreateDistMatrix}}).
}
\examples{
\dontrun{
if(require(cartography)){
  nuts3.spdf@data <- nuts3.df
  t1 <- system.time(
    s1 <- stewart(knownpts = nuts3.spdf,resolution = 40000, 
                  varname = "pop2008",
                  typefct = "exponential", span = 100000,
                  beta = 3, mask = nuts3.spdf)
  )
  
  t2 <- system.time(
    s2 <- mcStewart(knownpts = nuts3.spdf, resolution = 40000, 
                     varname = "pop2008",
                     typefct = "exponential", span = 100000,
                     beta = 3, mask = nuts3.spdf, cl = 3, size = 500)
  )
  identical(s1, s2)
  cat("Elapsed time\\n", "stewart:", t1[3], "\\n parStewart:",t2[3])
  
  r2 <- rasterStewart(s2)
  c2 <- rasterToContourPoly(r = r2, breaks = c(0,1000000,2000000, 5000000,
                                               10000000, 20000000, 200004342), 
                            mask = nuts3.spdf)
  # cartography
  opar <- par(mar = c(0,0,1.2,0))
  bks <- sort(unique(c(c2$min, c2$max)))
  choroLayer(spdf = c2, var = "center", breaks = bks, border = NA, 
             legend.title.txt = "pop")
  layoutLayer("potential population", "","", scale = NULL)
  par(opar)
}
}
}
\seealso{
\link{stewart}.
}
