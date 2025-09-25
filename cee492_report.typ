#import "@preview/charged-ieee:0.1.4": ieee

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

== Proposal 

Flooding in California's Sacramento Valley poses significant risks to communities, economic activity, and transportation systems. Our project will integrate multiple datasets—including precipitation, distance to waterways, DEM, and land cover—to identify the parameters most critical in driving flood events. By examining two major flooding events in 2018 with these datasets, we will conduct sensitivity analysis to quantify the relative contribution of each factor.

The goal of this analysis is to develop a machine learning framework for flood prediction. By reducing the dimensionality of input data, we aim to improve both model interpretability and computational efficiency. Furthermore, this framework will enable scenario simulations—such as intensified rainfall or land cover changes—to assess potential shifts in flood risk under future conditions.

== Dataset Description
#align(table(
  columns: (auto, auto, auto, auto),                     // padding inside cells
  stroke: 0.5pt,                    // border lines
  table.header([*Dataset*], [*Source*], [*Format*], [*Description*]), 
  [
    Flood Data,
    [The Global Flood Dataset \
    [Global Flood Database](https://global-flood-database.cloudtostreet.ai/#interactive-map)], 
    TIFF,
    [Spatial distribution of flooding area for two flood events in 2018. \
    Pixel values indicate flood and non-flood area.]
  ],
  [
    Precipitation,
    [The Global Flood Dataset \
    [Global Flood Database](https://global-flood-database.cloudtostreet.ai/#interactive-map)],
    CSV,
    [Fields: Date, Precipitation (mm). \
    Daily precipitation during 2018-03-21 ~ 2018-03-23 \
    2018-12-05 ~ 2018-12-09.]
  ],
  [
    Precipitation,
    [USGS \
    [USGS Current Conditions for the Nation – Precipitation](https://global-flood-database.cloudtostreet.ai/#interactive-map)],
    TXT,
    [Fields: Monitoring site ID, date, time, precipitation (inches). \
    Recorded precipitation depth during the 15-min interval during two \
    flooding events in Sacramento Valley in 2018.]
  ],
  [
    Distance to Waterway,
    [USA Detailed Water Bodies \
    [USA Detailed Water Bodies | ArcGIS Hub](https://hub.arcgis.com/datasets/esri::usa-detailed-water-bodies/about)],
    SHP,
    [Fields: Name, Type, ShapeLength, ShapeArea. \
    Using GIS to filter rivers/streams and drawing the centerlines \
    where distance grids can be computed.]
  ],
  [
    DEM (Digital Elevation Model),
    [USGS TNM \
    [TNM Download v2](https://apps.nationalmap.gov/downloader/)],
    TIFF,
    [Elevation around Sacramento Valley area.]
  ],
  [
    Land Use / Land Cover data,
    —,
    —,
    —
  ]
))


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
