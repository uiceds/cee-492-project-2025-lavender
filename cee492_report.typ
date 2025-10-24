#import "@preview/charged-ieee:0.1.4": ieee

#show link: set text(fill: blue)
#show link: underline
#show: ieee.with(
  title: [Flood contributing factors analysis in Sacramento Valley, CA],
  /* abstract: [
    This is where you put your abstract. 
  ], */
  authors: (
    (
      name: "Yun-Rou Lin",
      department: [Department of Civil and Environmental Engineering (CEE)],
      organization: [University of Illinois Urbana-Champaign],
      location: [Urbana, IL, USA],
      email: "yunroul2@illinois.edu",
    ),
    (
      name: "Xueming Xu",
      department: [Department of Civil and Environmental Engineering (CEE)],
      organization: [University of Illinois Urbana-Champaign],
      location: [Urbana, IL, USA],
      email: "xx37@illinois.edu",
    ),
    (
      name: "Jim Liu",
      department: [Department of Civil and Environmental Engineering (CEE)],
      organization: [University of Illinois Urbana-Champaign],
      location: [Urbana, IL, USA],
      email: "jiml2@illinois.edu",
    ),
    (
      name: "KP Pane",
      department: [Department of Civil and Environmental Engineering (CEE)],
      organization: [University of Illinois Urbana-Champaign],
      location: [Urbana, IL, USA],
      email: "kpane2@illinois.edu",
    ),
  
  ),
  /* index-terms: ("Optional", "Keywords", "Here"),
  bibliography: bibliography("refs.bib"), */
)

= Proposal 

Flooding in California's Sacramento Valley poses significant risks to communities, economic activity, and transportation systems. Our project will integrate multiple datasets—including precipitation, distance to waterways, DEM, and land cover—to identify the parameters most critical in driving flood events. By examining two major flooding events in 2018 with these datasets, we will conduct sensitivity analysis to quantify the relative contribution of each factor.

The goal of this analysis is to develop a machine learning framework for flood prediction. By reducing the dimensionality of input data, we aim to improve both model interpretability and computational efficiency. Furthermore, this framework will enable scenario simulations—such as intensified rainfall or land cover changes—to assess potential shifts in flood risk under future conditions.

/*= Introduction */


== Dataset Description
#align(table(
  columns: (auto, auto, auto, auto),                     // padding inside cells
  stroke: 0.5pt,                    // border lines
  table.header([*Dataset*], [*Source*], [*Format*], [*Description*]), 
  "Flood Data", 
  "(1)",
  "TIFF",
  "Spatial distribution of flooding area for two flood events in 2018. Pixel values indicate flood and non-flood area.", 
  "Precipitation",
  "(2)",
  "CSV",
  "Fields: Date, Precipitation (mm) parbreak()
  Daily precipitation during 2018-03-21 ~ 2018-03-23 \
  2018-12-05 ~ 2018-12-09.",
  "Precipitation",
  "(3)",
  "TXT",
  "Fields: Monitoring site ID, date, time, precipitation (inches). \
    Recorded precipitation depth during the 15-min interval during two \
    flooding events in Sacramento Valley in 2018.",
  "Distance to Waterway",
  "(4)",
  "SHP",
  "Fields: Name, Type, ShapeLength, ShapeArea. \
    Using GIS to filter rivers/streams and drawing the centerlines \
    where distance grids can be computed.",
  "DEM (Digital Elevation Model)",
  "(5)",
  "TIFF",
  "Elevation around Sacramento Valley area.",
  "Land Use / Land Cover data",
  "",
  "",
  ""
))
= Exploratory Data Analysis 

/*Narrative description and characterization of dataset:*/
Our study integrates multi-source geospatial and hydro-meteorological data for the Sacramento Valley: a DEM, mapped waterways, NLCD land-use/land-cover, precipitation time series, and flood-extent raster for two 2018 events. The variables are prepared to a common grid so that each pixel has coincident topography, distance-to-channel, land cover, and precipitation attributes alongside its flood/non-flood label (from the flood maps), enabling supervised learning and correlation analyses. The Global Flood Database demonstrates the feasibility of event-based flood-extent mapping used as training targets.

== Flood Contributing Factors and Flood Data

*DEM (elevation)*: Lower elevations concentrate surface water and are repeatedly identified as high-susceptibility zones in flood mapping; terrain-based indices derived from the DEM are widely used to delineate floodplains and ponding areas.

*Slope*: Gentler slopes favor water accumulation and longer inundation residence times, while steep slopes promote rapid runoff; slope consistently ranks among the most important predictors in susceptibility models.

*Distance to waterway*: Proximity to rivers and streams strongly modulates flood likelihood; distance-to-river and stream-density metrics are standard covariates and often emerge as top features in ML models.

*Daily/event precipitation*: Flood spatial extent is tied to storm magnitude and intensity; precipitation is a core driver variable in data-driven and physics-guided flood mapping.

*Flood data*: Satellite-derived flood-extent products provide pixel-wise labels of flooded vs. non-flooded areas for specific events, suitable for training and validation.

*Land use/Land Cover*: Impervious surfaces (urban) increase runoff and reduce infiltration, whereas vegetation/soils buffer peaks; land use is repeatedly shown to improve susceptibility mapping beyond rainfall alone.

*Past flooding context: 2018 events*

A strong March 2018 storm produced road flooding and rescues across Northern California, including the greater Sacramento region—consistent with our March 21th to 23rd analysis window.
For early December 2018, our second window (Dec 5th to 9th) targets a winter storm period captured in our precipitation records and flood maps; we analyze these days as the event forcing for the observed inundation in our dataset (event-based labels from the Global Flood Database).

We will quantify spatial relationships between flood labels and each factor via maps, distribution plots, and correlation/feature-importance analyses. Specifically, we'll test whether lower elevation, gentle slopes, shorter channel distances, higher event-window precipitation, and urban land cover co-locate with observed inundation, and rank their contributions with model-agnostic importance in the predictive plan.


= Exploratory Data Analysis
Flood Data:
The total area of flooding was 261.5 square km#super("2") within the total sampled area of interest of #highlight[11834.692 square km#super("2")]. Based on the image below, it can also be observed that most of the flooding occurred in low elevation areas (at the base of the valley), which is consistent with our expectations.
 #figure(image("figures\Flood and DEM.png"),caption: [Flood Map Overlaid on DEM Raster Data])
It should be noted that because the flood data is concentrated in a narrow range of elevation values, it is possible that this study may not be able to fully capture the relationship between elevation and flooding. 

Satellite-derived flood-extent products provide pixel-wise labels of flooded vs. non-flooded areas for specific events, suitable for training and validation.

/* 1. A narrative description and characterization of your dataset, interspersed 
2. summary statistics
3. plots */

== Precipitation
1. The averaged Sacramento precipitation data from 2011–2024 shows clear interannual variability, with total rainfall ranging from about 25 to 40 inches per year. Years such as 2017 and 2018 recorded the highest totals, aligning with known regional flood events. In contrast, 2021–2022 represent drier periods consistent with drought conditions.
2. The number of rainfall days decreases with depth threshold: light rain (≥0.01 in) occurs 40–70 days per year, moderate rain (≥0.10 in) around 20–50 days, and heavy rain (≥1.00 in) fewer than 6 days annually. These results indicate that most precipitation in Sacramento falls as frequent low-intensity events, while a few high-intensity storms contribute disproportionately to flood potential.
  
  Extreme Max Precipitation values (1.5 – 3.5 in) highlight single-day storm intensity and track closely with total annual rainfall trends, suggesting that wetter years tend to experience both greater overall rainfall and more intense storms. Together, these patterns confirm that short-duration, high-intensity rainfall events are key drivers of flooding risk in the Sacramento Valley.
3. #figure(image("figures/Precip plot 1.png"),caption: [Different Level of Precipitation by Days in Years])
   #figure(image("figures/Precip plot 2.png"),caption: [Average Precipitation by Years])

== Distance to water:
All layers were projected to WGS 1984 to support accurate area calculations (planar units in meters). We built multiple-ring buffers around rivers/streams, converted them to non-overlapping rings, and used Intersect to clip the flood polygons to each ring so the distance class is carried as an attribute. We then computed (i) share of total flood area in each class and (ii) a normalized flood rate = (flooded area within a ring) / (total ring area). 
  
  Key processing steps: Erase (flood minus permanent water), Multiple Ring Buffer → non-overlapping rings, Intersect (flood & rings), Calculate Geometry Attributes (Area in km²), and Summary Statistics by distance class.
 #figure(image("figures/Layout_DistancetoWaterway.png"),caption: [Waterway Distance Buffer Rings])

Interpretation. Within the 3 km corridor, flood area distributes fairly evenly by ring once normalized by available land (2.23–2.84 % of each ring is flooded). Raw area shares, however, are largest in the 1–3 km ring simply because that ring covers the greatest land area. The near-uniform normalized rates suggest that proximity alone does not dominate within 3 km; topography (low basin slopes), local storage, and floodplain width likely modulate where water spreads, consistent with our basin setting hypothesis.
#figure(image("figures/Water_Distance_1.png"),caption:[Flood area by distance-to-water classes.])

#figure(image("figures/Water_Distance_2.png"),caption: [Normalized flood rate (% of ring)])


== Digital Elevation Model(DEM)
1. A narrative description and characterization of your dataset, interspersed 
2. summary statistics
3. plots


== Land Use/Cover
This dataset comes from the USGS National Land Cover Database (NLCD) from a 2018 dataset, which provides 30-meter resolution land cover classifications for the United States. The dataset classifies land cover into 16 different classes based on satellite imagery and other ancillary data. 

With interest in analyzing the impacts that land cover category has on flooding outcomes, a pie chart was created to visualize the distribution of land cover types among the total flooded area.
#figure(image("figures\Flood Land Composition.png"),caption: [Portion of Flooded Area Within Each Land Cover Type])
To truly analyze the relationship between land cover and flooding, it is important to consider not just the proportion of each land cover type within the flooded area, but also the overall distribution of land cover types across the entire study area. This would allow for a more accurate assessment of whether certain land cover types are disproportionately represented in flooded areas compared to their prevalence in the landscape as a whole. As such, percentage of flood prevalence was calculated within each individual land cover type, which provides a clearer picture of how likely each land cover type is to experience flooding.
#figure(image("figures\flood percent by LC.png"),caption: [Percentage of Area Flooded by Land Cover Type])
Crop land overwhelmingly dominates the flooded area, with more than 3 times the rate of flooding as its runner up, barren land. This observation can likely be attributed to the fact that poor-drainage soils are preferable for agricultural activities due to the ability to retain moisture, but are consequently more prone to flooding. One surprising observation from this graph is that all developed land categories have a relatively low flood prevalence (below 1%). This could be due to the presence of stormwater management infrastructure in urban areas, such as storm drains and retention basins, which help mitigate flooding despite the high proportion of impervious surfaces. Other land cover types such as forest, shrub, and herbaceous also have low flood prevalence, likely due to their natural ability to absorb and slow down runoff.



= Predictive Modeling
/*A brief plan for the predictive model you will create for Deliverable 3 */
We plan to develop a supervised machine learning model with the following approach:
1. Objective: Identify the most influential environmental variables driving flood events
2. Input features: Precipitation, elevation (DEM), slope, land cover type, and distance to waterways.
3. Study area: Sacramento Valley
4. Model type: Random forest to capture nonlinear relationship
5. Goal: Identify the most influential environmental variables driving flood events.
6. Optional: Combining with a CNN UNet model to predict the flooding under different precipitation scenarios. By sensitivity analysis, we can reduce the not that important factors and accelerate the UNet model training.





= Sources

1. Global Flood Database — https://global-flood-database.cloudtostreet.ai
2. NOAA Climate Data Online (GHCN‑Daily) — https://www.ncei.noaa.gov/cdo-web/
3. USGS NWIS Current Conditions — Precipitation — https://waterdata.usgs.gov/nwis/rt
4. USA Detailed Water Bodies (Esri Hub) — https://hub.arcgis.com/datasets/esri::usa-detailed-water-bodies/about
5. USGS National Map Downloader — https://apps.nationalmap.gov/downloader/
6. NLCD (MRLC) — https://www.mrlc.gov/data

= Reference

/* == First Subsection

To add figures to your report, save the image file in the `figures` folder and use the `#figure` command as shown below to include it in your document. You can specify the width of the image and add a caption. Then you can reference the figure like this: @proofread.

#figure(
  image("figures/proof-read.png", width: 80%),
  caption: [A humble request. (Copyright: University of the Fraser Valley.)],
) <proofread>

=== First Subsubsection

You can make sub, sub-sub, and sub-sub-sub sections by adding `=` signs in front of the section title. There needs to be a space between the last `=` sign and the title text.

= Second Section

You can add tables using the `#table` command. Here is an example table:

#figure(
  caption: [Example Table],
  table(
    columns: (auto, auto, auto),
    table.header([*Column 1*], [*Column 2*], [*Column 3*]),
    "Row 1", "Data 1", [Data 2],
    image("figures/proof-read.png", width: 40%), "Data 3", "Data 4",
  ),
) <table-example>

You can reference the table like this: @table-example.

== Various Text Formatting Options

You can make text _italic_ by surrounding it with `_` symbols, *bold* by surrounding it with `*` symbols, and _*bold italic*_ by combining both. You can also use `#code` to format inline code snippets.

You can create bullet point lists using `-` or `*` symbols:
- Bullet point 1
- Bullet point 2
  - Sub bullet point 1
  - Sub bullet point 2


You can create numbered lists using numbers followed by a period:
1. First item
2. Second item
  1. Sub item 1
  2. Sub item 2



== Equations

You can create equations using `$` symbols. For example, you can make an inline equation like this $E=m c^2$ or a displayed equation like this:

$ x < y => x gt.eq.not y $ <eq1>

You can reference the equation like this: Eq. @eq1. */
