% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gridandmat.R
\name{CreateGrid}
\alias{CreateGrid}
\title{Create a Regularly Spaced SpatialPointsDataFrame}
\usage{
CreateGrid(w, resolution)
}
\arguments{
\item{w}{sp object; the spatial extent of this object is used to 
create the regular SpatialPointsDataFrame.}

\item{resolution}{numeric; resolution of the grid (in map units). If 
resolution is not set, the grid will contain around 7500 points. (optional)}
}
\value{
The output of the function is a SpatialPointsDataFrame of regularly
spaced points with the same extent as \code{w}.
}
\description{
This function creates a regular grid of SpatialPointsDataFrame 
from the extent of a given sp object and a given resolution.
}
\examples{
# Create a SpatialPointsDataFrame grid of spatMask extent and 200 meters 
# resolution
data(spatData)
mygrid <- CreateGrid(w = spatMask, resolution = 200)
plot(mygrid, cex = 0.1, pch = ".")
plot(spatMask, border="red", lwd = 2, add = TRUE)
}
\seealso{
\link{CreateDistMatrix}
}
