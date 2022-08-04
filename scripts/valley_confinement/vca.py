"""
Copyright 2020 Blue Geosimulation

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"""

import rasterio
import numpy
from skimage.graph import MCP_Geometric
from scipy.ndimage import distance_transform_edt

def distance(sources):
    """
    Calculate distance to sources everywhere in the dataset
    :param sources: Raster with sources as legitimate data
    :return: distance array
    """
    r = Raster(sources)
    out = r.astype('float32')
    out[:] = distance_transform_edt(r.array == r.nodata, [r.csx, r.csy])
    return out



def bankfull(dem, average_annual_precip=250, contributing_area=None, flood_factor=1, max_width=5000,
             streams=None, min_stream_area=None):
    """
    Calculate a bankfull depth using the given precipitation and flood factor
    :param dem: Input elevation Raster
    :param average_annual_precip: Average annaul precipitation (cm) as a scalar, Vector, or Raster
    :param contributing_area: A contributing area (km**2) Raster. It will be calculated using the DEM if not provided.
    :param flood_factor: Coefficient to amplify the bankfull depth
    :param streams: Input stream Vector or Raster.  They will be calculated using the min_stream_area if not provided
    :param min_stream_area: If no streams are provided, this is used to derived streams.  Units are m**2
    :return: Raster instance of the bankful depth
    """
    dem = Raster(dem)

    # Grab the streams
    if streams is not None:
        streams = assert_type(streams)(streams)
        if isinstance(streams, Vector):
            streams = streams.rasterize(dem)
        elif isinstance(streams, Raster):
            streams = streams.match_raster(dem)
    else:
        if min_stream_area is None:
            raise WaterError(
                'Either one of streams or minimum stream contributing area must be specified')
        streams = bluegrass.stream_extract(dem, min_stream_area)

    streams = streams.array != streams.nodata

    # Check if contributing area needs to be calculated
    if contributing_area is None:
        contrib = bluegrass.watershed(
            dem)[1] * (dem.csx * dem.csy / 1E6)  # in km**2
    else:
        contrib = Raster(contributing_area)

    # Parse the precip input and create the precip variable
    if any([isinstance(average_annual_precip, t) for t in [int, float, numpy.ndarray]]):
        # Scalar or array
        precip = dem.full(average_annual_precip) ** 0.355
    else:
        precip = assert_type(average_annual_precip)(
            average_annual_precip) ** 0.355

    # Calculate bankfull depth
    bankfull = (contrib ** 0.280) * 0.196
    bankfull = bankfull * precip
    # bankfull = bankfull ** 0.607 * 0.145
    # bankfull *= flood_factor

    # Add the dem to the bankfull depth where streams exists, and extrapolate outwards
    bnkfl = bankfull.array
    bnkfl[~streams] = bankfull.nodata
    bankfull[:] = bnkfl

    return bankfull

    bankfull += dem
    bnkfl = bankfull.array

    # Buffer by the max width
    mask = distance_transform_edt(
        bnkfl == bankfull.nodata, (bankfull.csy, bankfull.csx)) < max_width

    # Extrapolate the bankfull values to the buffer
    xi = (bnkfl == bankfull.nodata) & mask
    points = bnkfl != bankfull.nodata
    values = bnkfl[points]
    points = numpy.where(points)
    points = numpy.vstack(
        [points[0] * bankfull.csy, points[1] * bankfull.csx]).T
    xi = numpy.where(xi)
    bnkfl[xi] = griddata(
        points, values, (xi[0] * bankfull.csy, xi[1] * bankfull.csx), 'linear')
    bnkfl[numpy.isnan(bnkfl) | numpy.isinf(bnkfl)] = bankfull.nodata
    bankfull[:] = bnkfl

    # Create a flood depth by subtracting the dem
    bankfull -= dem
    bnkfl = bankfull.array
    bnkfl[bnkfl < 0] = bankfull.nodata
    bnkfl[streams] = 0
    bankfull[:] = bnkfl

    return bankfull

def most_common(input_raster, size=(3, 3)):
    """
    -- ?? https://scikit-image.org/docs/stable/api/skimage.filters.rank.html?highlight=majority#skimage.filters.rank.modal
    Perform a mode filter
    :param size: Window size
    :return: Raster with most frequent local value
    """
    # Allocate output
    input_raster = Raster(input_raster)
    mode_raster = input_raster.empty()
    if input_raster.useChunks:
        # Iterate chunks and calculate mode (memory-intensive, so don't fill cache)
        for a, s in input_raster.iterchunks(expand=size, fill_cache=False):
            s_ = util.truncate_slice(s, size)
            try:
                mode_raster[s_] = util.mode(util.window_on_last_axis(a, size), 2)[0]
            except:
                mode_raster[s_] = mode_raster.nodata
                continue
    else:
        # Calculate over all data
        mode_raster[1:-1, 1:-1] = util.mode(util.window_on_last_axis(input_raster.array, size), 2)[0]

    return mode_raster

def valley_confinement(
    dem,
    #min_stream_area,
    cost_threshold=2500,
    streams=None,
    waterbodies=None,
    average_annual_precip=250,
    slope_threshold=9,
    use_flood_option=True,
    flood_factor=3,
    max_width=False,
    minimum_drainage_area=0,
    min_stream_length=100,
    min_valley_bottom_area=10000,
    save_bankfull=None,
):
    """
     Valley Confinement algorithm based on https://www.fs.fed.us/rm/pubs/rmrs_gtr321.pdf
    :param dem: (Raster) Elevation Raster
    :param min_stream_area: (float) Minimum contributing area to delineate streams if they are not provided.
    :param cost_threshold: (float) The threshold used to constrain the cumulative cost of slope from streams
    :param streams: (Vector or Raster) A stream Vector or Raster.
    :param waterbodies: (Vector or Raster) A Vector or Raster of waterbodies. If this is not provided, they will be segmented from the DEM.
    :param average_annual_precip: (float, ndarray, Raster) Average annual precipitation (in cm)
    :param slope_threshold: (float) A threshold (in percent) to clip the topographic slope to.  If False, it will not be used.
    :param use_flood_option: (boolean) Determines whether a bankfull flood Extent will be used or not.
    :param flood_factor: (float) A coefficient determining the amplification of the bankfull
    :param max_width: (float) The maximum valley width of the bottoms.
    :param minimum_drainage_area: (float) The minimum drainage area used to filter streams (km**2).
    :param min_stream_length: (float) The minimum stream length (m) used to filter valley bottom polygons.
    :param min_valley_bottom_area: (float) The minimum area for valey bottom polygons.
    :return: Raster instance (of the valley bottom)
    """

    # Create a Raster instance from the DEM
    # -- just open with rasterio
    dem = Raster(dem)

    # The moving mask is a mask of input datasets as they are calculated
    moving_mask = numpy.zeros(shape=dem.shape, dtype="bool")

    # Calculate slope
    print("Calculating topographic slope")
    # -- calc with gdal? see becmodel
    slope = topo(dem).slope("percent_rise")

    # Add slope to the mask
    if slope_threshold is not False:
        moving_mask[(slope <= slope_threshold).array] = 1

    # Calculate cumulative drainage (flow accumulation)
    # -- can we do this with pysheds rather than grass?
    fa = bluegrass.watershed(dem)[1]
    fa.mode = "r+"
    fa *= fa.csx * fa.csy / 1e6

    # -- rasterize streams. consider filtering based on min drainage area
    # -- *before* rasterizing, the fwa area should work well enough
    streams = assert_type(streams)(streams)
    if isinstance(streams, Vector):
        streams = streams.rasterize(dem)
    elif isinstance(streams, Raster):
        streams = streams.match_raster(dem)

    # Remove streams below the minimum_drainage_area
    if minimum_drainage_area > 0:
        a = streams.array
        a[fa < minimum_drainage_area] = streams.nodata
        streams[:] = a

    # Calculate a cost surface using slope and streams, and create a mask using specified percentile
    print("Calculating cost")
    cost = cost_surface(streams, slope)
    moving_mask = moving_mask & (cost < cost_threshold).array

    # Incorporate max valley width arg
    if (
        max_width is not False
    ):  # Use the distance from the streams to constrain the width
        # Calculate width if necessary
        moving_mask = moving_mask & (distance(streams) < (max_width / 2)).array

    # Flood calculation
    if use_flood_option:
        print("Calculating bankfull")
        flood = bankfull(
            dem,
            streams=streams,
            average_annual_precip=average_annual_precip,
            contributing_area=fa,
            flood_factor=flood_factor,
        ).mask
        if save_bankfull is not None:
            flood.save(save_bankfull)
        moving_mask = moving_mask & flood.array

    # Remove waterbodies
    # Segment water bodies from the DEM if they are not specified in the input
    print("Removing waterbodies")
    #if waterbodies is not None:
    waterbodies = assert_type(waterbodies)(waterbodies)
    if isinstance(waterbodies, Vector):
        waterbodies = waterbodies.rasterize(dem)
    elif isinstance(waterbodies, Raster):
        waterbodies = waterbodies.match_raster(dem)
    #else:
    #    waterbodies = segment_water(dem, slope=slope)
    moving_mask[waterbodies.array] = 0

    # Create a Raster from the moving mask and run a mode filter
    print("Applying a mode filter")
    valleys = dem.astype("bool")
    valleys[:] = moving_mask
    valleys.nodataValues = [0]
    valleys = most_common(valleys)

    # Label the valleys and remove those below the specified area or where stream lenght is too small
    print("Filtering by area and stream length")
    stream_segment = numpy.mean(
        [dem.csx, dem.csy, numpy.sqrt(dem.csx**2 + dem.csy**2)]
    )
    valley_map = label(valleys, True)[1]
    a = numpy.zeros(shape=valleys.shape, dtype="bool")
    sa = streams.array
    for _, inds in valley_map.items():
        length = (sa[inds] != streams.nodata).sum() * stream_segment
        if (
            inds[0].size * dem.csx * dem.csy >= min_valley_bottom_area
            and length >= min_stream_length
        ):
            a[inds] = 1

    # Write to output and return a Raster instance
    valleys[:] = a
    print("Completed successfully")
    return valleys
