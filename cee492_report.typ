#import "@preview/charged-ieee:0.1.4": ieee

#show link: set text(fill: blue)
#show link: underline
#show: ieee.with(
  title: [Flood contributing factors analysis in Sacramento Valley, CA],
  /* abstract: [
    This is where you put your abstract. here
  ], */
  authors: (
    (
      name: "Yun-Rou Lin 1",
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
  "Spatial distribution of flooding area for two flood events in 2018. 
  
Pixel values indicate flood (1) and non-flood (0) area.", 
  "Precipitation",
  "(2)",
  "CSV",
  "Fields: 
Date, Precipitation (mm), Daily precipitation during 2018-03-21 through 2018-03-23 and 2018-12-05 through 2018-12-09.",
  "Precipitation",
  "(3)",
  "TXT",
  "Fields: 
Monitoring site ID, date, time, precipitation (inches).

Recorded precipitation depth during the 15-min interval during two
flooding events in Sacramento Valley in 2018.",
  "Distance to Waterway",
  "(4)",
  "SHP",
  "Fields: 
Name, Type, ShapeLength, ShapeArea. 

Using GIS to filter rivers/streams and drawing the centerlines where distance grids can be computed.",
  "DEM (Digital Elevation Model)",
  "(5)",
  "TIFF",
  "Elevation around Sacramento Valley area.",
  "Land Use / Land Cover data",
  "(6)",
  "TIFF",
  "2018 National Land Cover Database (NLCD) raster data with 30-meter resolution. 

Fields: 
Land Cover Classification, Fraction Impervious Surface",
))
= Exploratory Data Analysis 

/*Narrative description and characterization of dataset:*/
Our study integrates multi-source geospatial and hydrometeorological data for the Sacramento Valley, including DEM (elevation), slope, land use/land cover, distance to waterways, precipitation, and flood extent for a December 2018 event. We quantify spatial relationships between flood labels and each factor using thematic maps and summary statistics. All layers are projected to the WGS 1984 UTM Zone 10N coordinate system.

== DEM (elevation)
DEM data for the study area were obtained from the USGS for a time period close to the December 2018 flooding event. The DEM was imported into ArcGIS Pro and re-projected to WGS 1984 UTM Zone 10N. Elevation and slope rasters were then derived from this dataset, and an appropriate color ramp was selected for visualization.
The DEM indicates that elevation in the study area ranges from approximately −32 to 1,249 m above sea level. The mean elevation is about 122 m, which is much closer to the minimum than to the maximum value. This confirms that low-elevation terrain dominates the Sacramento Valley, consistent with regional topography and with our expectation that flooding is more likely to occur in local elevation minima.

#figure(image("figures/elevation_zoom.png"),caption: [DEM Data in Sacramento Valley, CA])

== Slope
From DEM, slope data was also derived in ArcGIS Pro. These results are shown in the figure below. Gentler slopes favor water accumulation and longer inundation residence times, while steep slopes promote rapid runoff. Slope consistently ranks among the most important predictors in susceptibility models.  It can be observed that the slope values at the base of the valley are very low (close to 0 degrees), which is consistent with our expectation for flooding to occur in low-slope areas.

#figure(image("figures/slope zoom.png"),caption: [Slope Data in Sacramento Valley, CA])

== Distance to waterway
Distance to waterways was computed from land cover data. We first extracted waterbodies from the land cover map to create a separate “open water” layer. Non-overlapping buffer rings were then generated around these waterbodies at specified distance intervals (in kilometers). Using the Intersect tool, we clipped flood polygons with each buffer ring so that distance class was stored as an attribute. For each ring, we calculated (i) the share of total flooded area and (ii) a normalized flood rate defined as (flooded area within a ring) / (total ring area). 

Key processing steps included:
1. Erase (flood polygons minus permanent water);


2. Multiple Ring Buffer to create non-overlapping distance classes;


3. Intersect (flood polygons with buffer rings);


4. Calculate Geometry Attributes (area in km²);


5. Summary Statistics aggregated by distance class.
#figure(image("figures/Layout_DistancetoWaterway.png"),caption: [Waterway Distance Buffer Rings])

Within a 3 km corridor around waterways, normalized flood rates are relatively uniform: approximately 2.23–2.84% of each ring’s area is flooded. Raw area shares are largest in the 1–3 km ring because that ring covers the largest land area. The near-uniform normalized rates suggest that, within 3 km of waterways, proximity alone does not fully control flood occurrence. Instead, topography (low basin slopes), local storage, and floodplain width likely govern where water spreads, which is consistent with our basin-scale hypothesis.
#figure(image("figures/Water_Distance_1.png"),caption:[Flood area by distance-to-water classes.])

#figure(image("figures/Water_Distance_2.png"),caption: [Normalized flood rate (% of ring)])

== Land use/Land Cover
This dataset comes from the USGS National Land Cover Database (NLCD) from a 2018 dataset, which provides 30 meter resolution land cover classifications for the United States. The dataset classifies land cover into 16 different classes based on satellite imagery and other ancillary data. With interest in analyzing the impacts that land cover category has on flooding outcomes, a pie chart was created to visualize the distribution of land cover types among the total flooded area.
#figure(image("figures/Flood Land Composition.png"),caption: [Portion of Flooded Area Within Each Land Cover Type])

To truly analyze the relationship between land cover and flooding, it is important to consider not just the proportion of each land cover type within the flooded area, but also the overall distribution of land cover types across the entire study area. This would allow for a more accurate assessment of whether certain land cover types are disproportionately represented in flooded areas compared to their prevalence in the landscape as a whole. As such, the percentage of flood prevalence was calculated within each individual land cover type, which provides a clearer picture of how likely each land cover type is to experience flooding.
#figure(image("figures/flood percent by LC.png"),caption: [Percentage of Area Flooded by Land Cover Type])

Crop land overwhelmingly dominates the flooded area, with more than 3 times the rate of flooding as its runner up, barren land. This observation can likely be attributed to the fact that poor-drainage soils are preferable for agricultural activities due to the ability to retain moisture, but are consequently more prone to flooding. One surprising observation from this graph is that all developed land categories have a relatively low flood prevalence (below 1%). This could be due to the presence of stormwater management infrastructure in urban areas, such as storm drains and retention basins, which help mitigate flooding despite the high proportion of impervious surfaces. Other land cover types such as forest, shrub, and herbaceous also have low flood prevalence, likely due to their natural ability to absorb and slow down runoff. 

== Daily/event precipitation
Averaged Sacramento precipitation records for 2011–2024 show substantial interannual variability, with annual totals ranging from roughly 25 to 40 inches. Years such as 2017 and 2018 exhibit the highest totals and correspond to known regional flood events, whereas 2021–2022 are markedly drier and consistent with drought conditions.
The frequency of rainfall events decreases as the intensity threshold increases. Light rain (≥ 0.01 in) occurs on approximately 40–70 days per year, moderate rain (≥ 0.10 in) on about 20–50 days per year, and heavy rain (≥ 1.00 in) on fewer than 6 days annually. Thus, most precipitation falls as frequent, low-intensity events, while a small number of high-intensity storms contribute disproportionately to flood potential.
Extreme single-day precipitation maxima (1.5–3.5 in) closely track annual total rainfall, indicating that wetter years tend to experience both higher cumulative precipitation and more intense storms. Together, these patterns support the conclusion that short-duration, high-intensity rainfall events are key drivers of flooding risk in the Sacramento Valley.
#figure(image("figures/Precip plot 1.png"),caption: [Different Level of Precipitation by Days in Years])
#figure(image("figures/Precip plot 2.png"),caption: [Average Precipitation by Years])

== Flood data
Flood extent for the December 2018 event was imported into ArcGIS Pro and clipped to the study area. The total flooded area is 261.5 km² within a total area of interest of 11,834.692 km². Visual inspection of the flood map confirms that most inundation occurs in low-elevation zones at the base of the valley, consistent with our DEM and slope analyses.
Because the observed flooding is concentrated within a relatively narrow elevation range, the study may not fully capture the broader relationship between elevation and flood occurrence. Nonetheless, the satellite-derived flood-extent product provides pixel-level labels of flooded versus non-flooded areas for this event, which is suitable for training and validating data-driven flood susceptibility models.
#figure(image("figures/Flood and DEM.png"),caption: [Flood Map Overlaid on DEM Raster Data])


= Predictive Modeling
/*A brief plan for the predictive model you will create for Deliverable 3 */
We proposed a supervised machine learning model with the following approach to identify the environmental variables most strongly associated with flood occurrence in Sacramento Valley. By conducting the sensitivity analysis, we are able to understand which factors are most influential which may improve the hazard mapping or the future assessment. 
== Objective
Objective
Our goal is to identify the most influential environmental variables and hydrological factors that contribute the most to flood events in Sacramento Valley, CA. 
== Input features
Precipitation, elevation (DEM), slope, land cover type, and distance to waterways.
== Model
According to Farhadi (2021), Random Forest is a robust model for flood-related applications, especially when working with remote sensing data. It achieves high accuracy, reduces the risk of overfitting, and effectively captures nonlinear relationships among environmental variables. Furthermore, Random Forest offers fast computation and simpler parameter tuning than other machine learning methods such as neural networks. Moreover, Random Forest provides more stable performance on moderately sized datasets. In addition, the Scikit-Learn implementation of Random Forest provides direct estimates of feature importance, which supports the objective of this project. As a result, Random Forest is a suitable method for our project.
== Training and Validation
In this project, we will test several train–test split ratios, including 70/30, 75/25, and 80/20, and compare the model performance across these settings. Since our input classes are imbalanced, we plan to apply class_weight="balanced" to address the issue and improve the model’s ability to detect flooded pixels. For feature preparation, all geospatial layers are already aligned and extracted into a consistent pixel-level dataset, so no additional normalization is required for the Random Forest model.
== Model Optimzation
We plan to adjust the hyperparameter to optimize the model. Our model. 
rf = RandomForestClassifier(n_estimators=100, max_depth=None, max_features="sqrt", n_jobs=-1, random_state=1234,)

=== N_estimators represent the number of trees in the forest. A larger number of trees generally makes the model more stable, but it also increases training time. Since our dataset is moderately sized, we will fine-tune this parameter using values such as 50, 100, 150, 200. If the model accuracy does not improve after a certain point, there is no need to add more trees.

=== Max_depth controls how deep each tree can grow. If the model shows signs of overfitting, we will limit the depth (e.g., max_depth = 10 or higher) and adjust it until the performance no longer improves.

=== Max_features determines how many features each tree can use when splitting. The default setting is "sqrt", which means each split considers √(number of input features). This helps introduce randomness and reduces overfitting.

=== N_jobs = -1 means the model will use all available CPU cores to speed up training.

=== Random_state sets the random seed to ensure that the model results are reproducible.

=== The default optimization metric– which was used for this project– utilized during training for the RandomForestClassifier is Gini Impurity. The post-training evaluation metrics are model accuracy, precision, recall, and F1 score.

== Model Performance Evaluation
  To evaluate te success of our predictive model, we use several standard performance metrics including accuracy, precision, recall, and F1-score. These metrics provide a comprehensive understanding of the model's ability to correctly classify flooded and non-flooded areas.

#let text-cell(content) = align(left, content)

#let num-cell(content, color: rgb("#f2e9ff")) = rect(
  fill: color,
  inset: 4pt,
  align(center + horizon, content)
)

#figure(
  caption: [Confusion Matrix],
  table(
    columns: (auto, auto, auto),

    table.header(
      text-cell([* *]),
      text-cell([*True (Ground truth): Flooded*]),
      text-cell([*True (Ground truth): Non-flooded*]),
    ),

    text-cell([*Model prediction: Flooded*]),
      [*391*],
      [*204*],

    text-cell([*Model prediction: Non-flooded*]),
      [*11187*],
      [*92005*],
  ),
) <confusion-matrix>




The confusion matrix in Table 1 compares the model’s flood prediction to the actual flooded areas observed in the real world (ground truth). True, or correct, predictions are highlighted in green, and false ones in red. 
“True (Model prediction)” represents pixels where the model predicted flooding, and “True (Ground truth)” represents the pixels that were actually flooded in the real world flood dataset. The model correctly predicted 391 pixels as flooded (true positive), but incorrectly predicted that an additional 11187 pixels were flooded, which were not flooded in real life (false positive). 204 ground truth flood points were incorrectly predicted to be non-flooded (false negative), while the other 92005 pixels that the model predicted as non-flooded were correct (true negative). This table makes it clear how often the model successfully detected true flooding versus how often it failed, and it provides a foundation for understanding the model’s strengths and limitations.

#let text-cell(content) = align(left, content)
#let num-cell(content) = align(center, content)

#figure(
  caption: [Table 2. Model Performance],
  table(
    columns: (auto, auto, auto),

    // Header
    table.header(
      table.cell(align: left)[*Metric*],
      table.cell(align: center)[*Value*],
      table.cell(align: left)[*Interpretation*],
    ),

    // Accuracy
    text-cell([Accuracy]),
    num-cell([0.89]),
    text-cell([The accuracy remains high, dominated by true negatives.]),

    // Precision
    text-cell([Precision]),
    num-cell([0.657]),
    text-cell([Of the model’s predicted flood area, 66% was truly flooded.]),

    // Recall
    text-cell([Recall]),
    num-cell([0.034]),
    text-cell([The model correctly found just 3.4% of the flooded pixels.]),

    // F1-score
    text-cell([F1-score]),
    num-cell([0.065]),
    text-cell([The low recall brought down the F1 score for an overall low F1 score.]),
  ),
)


With an accuracy of 89%, the model may appear very successful, but the other metrics can reveal flaws. The model has a low recall of 3.4%, meaning that a very small portion of the real-world flooded zones were predicted to flood by the model. In other words, it under-predicted the occurrence of flooding, which may be a sign of the imbalance of the data.

The low recall despite high accuracy demonstrates that the dataset is imbalanced, with a majority of the data representing non-flooded areas. Due to the dominance of non-flooded pixels over flooded pixels, the accuracy is more representative of how well the model can predict non-flooded areas than its ability to predict flooded areas.

  The precision represents how much of the model’s predicted flood zones were truly flooded in the real world data. With 66% precision, a majority of the flood prediction was actually flooded, but an increase to this number would be beneficial.
 
 Some methods for improving the model’s performance include adding more data on flooded areas and considering more parameters that may affect flood risk or to implement a weighting scheme that prioritizes parameters based on how indicative they are of flood occurrence.

= Sources

1. Global Flood Database — https://global-flood-database.cloudtostreet.ai
2. NOAA Climate Data Online (GHCN‑Daily) — https://www.ncei.noaa.gov/cdo-web/
3. USGS NWIS Current Conditions — Precipitation — https://waterdata.usgs.gov/nwis/rt
4. USA Detailed Water Bodies (Esri Hub) — https://hub.arcgis.com/datasets/esri::usa-detailed-water-bodies/about
5. USGS National Map Downloader — https://apps.nationalmap.gov/downloader/
6. NLCD (MRLC) — https://www.mrlc.gov/data

= Reference
[1] Hitouri, Sliman, et al. “Flood Susceptibility Mapping Using SAR Data and Machine Learning Algorithms in a Small Watershed in Northwestern Morocco.” Remote Sensing, vol. 16, no. 5, Feb. 2024, p. 858. DOI.org (Crossref), https://doi.org/10.3390/rs16050858.

/* 1. A narrative description and characterization of your dataset, interspersed 
2. summary statistics
3. plots

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
DEM raster data was used to derive elevation and slope information for the study area. As can be seen from the figure below, the elevation ranges from approximately -32 to 1249 meters above sea level. Yet, with a mean DEM value of about 122 meters (much closer to the minimum value than the maximum), it is clear that low elevation areas dominate the study area, which is consistent with the geography of the Sacramento Valley and with our expectation for flooding to occur at local elevation minima.

#figure(image("figures/elevation_zoom.png"),caption: [DEM Data in Sacramento Valley, CA])

From DEM, slope data was also derived in ArcGIS Pro. These results are shown in the figure below. It can be observed that the slope values at the base of the valley are very low (close to 0 degrees), which is consistent with our expectation for flooding to occur in low-slope areas.

#figure(image("figures/slope zoom.png"),caption: [Slope Data in Sacramento Valley, CA])


== Land Use/Cover
This dataset comes from the USGS National Land Cover Database (NLCD) from a 2018 dataset, which provides 30-meter resolution land cover classifications for the United States. The dataset classifies land cover into 16 different classes based on satellite imagery and other ancillary data. 

With interest in analyzing the impacts that land cover category has on flooding outcomes, a pie chart was created to visualize the distribution of land cover types among the total flooded area.
#figure(image("figures\Flood Land Composition.png"),caption: [Portion of Flooded Area Within Each Land Cover Type])
To truly analyze the relationship between land cover and flooding, it is important to consider not just the proportion of each land cover type within the flooded area, but also the overall distribution of land cover types across the entire study area. This would allow for a more accurate assessment of whether certain land cover types are disproportionately represented in flooded areas compared to their prevalence in the landscape as a whole. As such, percentage of flood prevalence was calculated within each individual land cover type, which provides a clearer picture of how likely each land cover type is to experience flooding.
#figure(image("figures\flood percent by LC.png"),caption: [Percentage of Area Flooded by Land Cover Type])
Crop land overwhelmingly dominates the flooded area, with more than 3 times the rate of flooding as its runner up, barren land. This observation can likely be attributed to the fact that poor-drainage soils are preferable for agricultural activities due to the ability to retain moisture, but are consequently more prone to flooding. One surprising observation from this graph is that all developed land categories have a relatively low flood prevalence (below 1%). This could be due to the presence of stormwater management infrastructure in urban areas, such as storm drains and retention basins, which help mitigate flooding despite the high proportion of impervious surfaces. Other land cover types such as forest, shrub, and herbaceous also have low flood prevalence, likely due to their natural ability to absorb and slow down runoff.

Land Use/Cover
1. A narrative description and characterization of your dataset, interspersed 
2. summary statistics
3. plots


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
