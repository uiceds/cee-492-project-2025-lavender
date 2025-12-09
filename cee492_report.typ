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

= Introduction

Flooding in California's Sacramento Valley poses significant risks to communities, economic activity, and transportation systems. Our project will integrate multiple datasets—including precipitation, distance to waterways, DEM, and land cover—to identify the parameters most critical in driving flood events. By examining two major flooding events in 2018 with these datasets, we will conduct sensitivity analysis to quantify the relative contribution of each factor.

The goal of this analysis is to develop a machine learning (ML) framework for flood prediction. By reducing the dimensionality of input data, we aim to improve both model interpretability and computational efficiency. Furthermore, this framework will enable scenario simulations—such as intensified rainfall or land cover changes—to assess potential shifts in flood risk under future conditions.

/*= Introduction */

== Dataset Description
#align(table(
  columns: (auto, auto, auto, auto),                     // padding inside cells
  stroke: 0.5pt,                    // border lines
  table.header([*Dataset*], [*Source*], [*Format*], [*Description*]), 
  "Flood Data", 
  [@flooddata],
  "TIFF",
  "Spatial distribution of flooding area for two flood events in 2018. 
  
Pixel values indicate flood (1) and non-flood (0) area.", 
  "Precipitation",
  [@precipcsv],
  "CSV",
  "Fields: 
Date, Precipitation (mm), Daily precipitation during 2018-03-21 through 2018-03-23 and 2018-12-05 through 2018-12-09.",
  "Precipitation",
  [@preciptxt],
  "TXT",
  "Fields: 
Monitoring site ID, date, time, precipitation (inches).

Recorded precipitation depth during the 15-min interval during two
flooding events in Sacramento Valley in 2018.",
  "Distance to Waterway",
  [@waterwaysdata],
  "SHP",
  "Fields: 
Name, Type, ShapeLength, ShapeArea. 

Using GIS to filter rivers/streams and drawing the centerlines where distance grids can be computed.",
  "DEM (Digital Elevation Model)",
  [@demdata],
  "TIFF",
  "Elevation around Sacramento Valley area.",
  "Land Use / Land Cover data",
  [@landcoverdata],
  "TIFF",
  "2018 National Land Cover Database (NLCD) raster data with 30-meter resolution. 

Fields: 
Land Cover Classification, Fraction Impervious Surface",
))
= Exploratory Data Analysis 

/*Narrative description and characterization of dataset:*/
Our study integrates multi-source geospatial and hydrometeorological data for the Sacramento Valley, including DEM (elevation), slope, land use/land cover, distance to waterways, precipitation, and flood extent for a December 2018 event. We quantify spatial relationships between flood labels and each factor using thematic maps and summary statistics. All layers are projected to the WGS 1984 UTM Zone 10N coordinate system.

== Feature Selection
The motivation for which parameters to include in this study stemmed from existing research on flood susceptibility, namely from an article highlighting an ML approach to flooding in Morocco  @Morocco. It specifies an array of independent variables that served as possible parameters for this project. Our team chose a set of relevant features by considering those variables in conjunction with officially recognized flood hazards. Hazards refer to environmental factors that can make an area more prone to experience flooding. 

Resources for the Future identifies some examples of hazards to include rainfall patterns and frequency, elevation, and rivers @rff. Precipitation amount, elevation, and distance to waterways account for these hazards. The National Weather Service also points out that during river flooding, low-lying areas surrounding rivers are the first to be impacted @NWS_flood_hazards. This confirms the significance of elevation and distance to waterways, especially since the area of study focuses on the (locally) low-lying Sacramento Valley intersected by the Sacramento River.

It’s rather intuitive that slope impacts flood risk, but existing research articles can be cited with this finding as well. An article on urban flood susceptibility in Mumbai states that low-slope areas facilitate much slower runoff than steeper areas, causing water to distribute slowly and potentially build up. They also noted that low-elevation areas tend to consist of more gradually-sloped land @researchgate. All that considered, slope was an important parameter for us to include.

The National Weather Service also highlights that urban areas are susceptible to flash flooding due to an increased presence of impenetrable surfaces, such as concrete, that inhibit water drainage into the soil. Additionally, they state that rocky and clay-like ground has poor drainage, which can increase flood likelihood @NWS_flood_hazards. These facts present the necessity to consider physical characteristics of the land, for which land cover is a great option for encompassing both natural and man-made classification types.

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
#figure(image("figures/Layout_1205.png"),caption: [Flood Map Overlaid on DEM Raster Data])


= Predictive Modeling
/*A brief plan for the predictive model you will create for Deliverable 3 */
We proposed a supervised machine learning model with the following approach to identify the environmental variables most strongly associated with flood occurrence in Sacramento Valley. By conducting the sensitivity analysis, we are able to understand which factors are most influential which may improve the hazard mapping or the future assessment. 
== Objective
Objective
Our goal is to identify the most influential environmental variables and hydrological factors that contribute the most to flood events in Sacramento Valley, CA. 
== Input features
Precipitation, elevation (DEM), slope, land cover type, and distance to waterways.
== Model
According to Farhadi & Najafzadeh, Random Forest is a robust model for flood-related applications, especially when working with remote sensing data. It achieves high accuracy, reduces the risk of overfitting, and effectively captures nonlinear relationships among environmental variables @Farhadi. Furthermore, Random Forest offers fast computation and simpler parameter tuning than other ML methods such as neural networks. Moreover, Random Forest provides more stable performance on moderately sized datasets. In addition, the Scikit-Learn implementation of Random Forest provides direct estimates of feature importance, which supports the objective of this project. As a result, Random Forest is a suitable method for our project.

For the loss function, the random forest also applies Gini impurity when doing the classification. Each tree in the forest relies on Gini to decide how to split the data. Since a random forest is essentially many decision trees trained on different subsets of the data and features, combining the predictions from all these trees makes the final result more robust and less sensitive compared to using a single decision tree.
#figure(image("figures/RF_structure.png"),caption: [Random Forest Structure @Farhadi])

== Training and Validation
In this project, we will test several train–test split ratios, including 70/30, 75/25, and 80/20, and compare the model performance across these settings. Since our input classes are imbalanced, we plan to apply class_weight="balanced" to address the issue and improve the model’s ability to detect flooded pixels. For feature preparation, all geospatial layers are already aligned and extracted into a consistent pixel-level dataset, so no additional normalization is required for the Random Forest model.
== Model Optimzation
We plan to adjust the hyperparameter to optimize the model. Our model. 
rf = RandomForestClassifier(n_estimators=100, max_depth=None, max_features="sqrt", n_jobs=-1, random_state=1234,)

=== N_estimators 
represent the number of trees in the forest. A larger number of trees generally makes the model more stable, but it also increases training time. Since our dataset is moderately sized, we will fine-tune this parameter using values such as 50, 100, 150, 200. If the model accuracy does not improve after a certain point, there is no need to add more trees.

=== Max_depth
 controls how deep each tree can grow. If the model shows signs of overfitting, we will limit the depth (e.g., max_depth = 10 or higher) and adjust it until the performance no longer improves.

=== Max_features 
determines how many features each tree can use when splitting. The default setting is "sqrt", which means each split considers √(number of input features). This helps introduce randomness and reduces overfitting.

=== N_jobs = -1 
means the model will use all available CPU cores to speed up training.

=== Random_state
sets the random seed to ensure that the model results are reproducible.

=== Optimization metric
  The metric used during training for the RandomForestClassifier is Gini Impurity. The post-training evaluation metrics are model accuracy, precision, recall, and F1 score.

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
      [*1674768*],
      [*347078*],

    text-cell([*Model prediction: Non-flooded*]),
      [*79075*],
      [*1861111*],
  ),
) <confusion-matrix>




The confusion matrix in Table 1 compares the model’s flood prediction to the actual flooded areas observed in the real world (ground truth). True, or correct, predictions are highlighted in green, and false ones in red. 
“True (Model prediction)” represents pixels where the model predicted flooding, and “True (Ground truth)” represents the pixels that were actually flooded in the real world flood dataset. The model correctly predicted 1674768 pixels as flooded (true positive), but incorrectly predicted that an additional 347078 pixels were flooded, which were not flooded in real life (false positive). 79075 ground truth flood points were incorrectly predicted to be non-flooded (false negative), while the other 1861111 pixels that the model predicted as non-flooded were correct (true negative). This table makes it clear how often the model successfully detected true flooding versus how often it failed, and it provides a foundation for understanding the model’s strengths and limitations.

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
    num-cell([0.814]),
    text-cell([The accuracy remains high]),

    // Precision
    text-cell([Precision]),
    num-cell([0.349]),
    text-cell([Of the model’s predicted flood area, 34.9% was truly flooded.]),

    // Recall
    text-cell([Recall]),
    num-cell([0.702]),
    text-cell([The model correctly found 70.2% of the flooded pixels.]),

    // F1-score
    text-cell([F1-score]),
    num-cell([0.466]),
    text-cell([The moderate F1 score reflects the trade-off between relatively good recall and low precision.]),
  ),
)


With an accuracy of 81.4%, the model may appear reasonably successful at first glance, but the other metrics reveal important limitations. The model has a recall of 70.2%, meaning that it correctly identified a majority of the real-world flooded zones. However, the relatively low precision of 34.9% indicates that many of the pixels the model predicted as flooded were actually non-flooded. In other words, the model tends to over-predict flooding, which may be related to how it is learning from the imbalanced dataset.

The combination of high accuracy and low precision suggests that the dataset is still dominated by non-flooded pixels, and the accuracy is influenced strongly by correct non-flooded predictions. While recall shows that the model is sensitive to flooded areas, the low precision means that many non-flooded pixels are incorrectly labeled as flooded. The F1-score of 0.466 reflects this tradeoff between relatively high recall and low precision, indicating that there is room for improvement in balancing missed floods versus false alarms.

The precision represents how much of the model’s predicted flood zones were truly flooded in the real-world data. With 34.9% precision, only about one-third of the predicted flooded area was actually flooded, so increasing this value would make the model more reliable for practical applications. Some methods for improving the model’s performance include adding more data on flooded areas, rebalancing the dataset (for example, through oversampling or other techniques), and considering additional parameters that may affect flood risk. Adjusting the model’s decision threshold or using a weighting scheme that emphasizes more accurate flood predictions could also help reduce false positives and improve overall performance.


#figure(
  caption: [Random Forest feature importance],
  table(
    columns: (auto, auto),

    table.header(
      text-cell([*Factor*]),
      text-cell([*Importance*]),
    ),

    // Rows
    text-cell([dem]),
    num-cell([0.245]),

    text-cell([slope]),
    num-cell([0.061]),

    text-cell([dist2river]),
    num-cell([0.037]),

    text-cell([landcover]),
    num-cell([0.213]),

    text-cell([aspect]),
    num-cell([0.074]),

    text-cell([curvature]),
    num-cell([0.063]),

    text-cell([TWI]),
    num-cell([0.050]),

    text-cell([rain]),
    num-cell([0.257]),
  ),
)

DEM (elevation) and precipitation are the two most important factors influencing flood occurrence, followed by land cover type. Slope, aspect, curvature, and topographic wetness index (TWI) have lower importance scores, indicating they contribute less to the model's predictions. These results align with our expectations, as elevation and rainfall are primary drivers of flooding, while land cover affects infiltration and runoff. The lesser importance of slope and other topographic features suggests that, in this region, they play a secondary role compared to elevation and precipitation.

= Discussion
Our results show that flooding in Sacramento Valley is mainly controlled by the interaction of elevation, land cover, and precipitation, with distance to waterways and detailed topographic metrics playing secondary roles. The December 2018 flood is concentrated in low-elevation, low-slope areas along the valley floor, while surrounding uplands remain largely unflooded. Within the 0–3 km river corridor, normalized flood rates are similar across distance bands, suggesting that once an area is “near” a river, local micro-topography and storage depressions are more important than exact distance to the channel. Land cover further modifies this pattern: cultivated crops have the highest flood prevalence, reflecting flat fields and limited drainage, whereas developed and vegetated areas show lower flood prevalence, likely due to stormwater infrastructure and higher infiltration and roughness.

The precipitation analysis supports the role of short-duration, high-intensity storms as the main trigger for flooding. Only a small fraction of days experience heavy rainfall, but these events contribute disproportionately to annual totals and coincide with known flood years such as 2018.

The Random Forest model captures part of this physical understanding but is clearly affected by class imbalance. Because the dataset contains far more non-flooded than flooded pixels, the model can achieve high overall accuracy by favoring non-flooded predictions, which leads to low recall for the flooded class. In other words, it is conservative and tends to miss many flooded pixels, limiting its usefulness for detecting all flooded areas. DEM (elevation) and precipitation are the two most important factors influencing flood occurrence, followed by land cover type. Slope, aspect, curvature, and topographic wetness index (TWI) have lower importance scores, indicating they contribute less to the model’s predictions. These results align with our expectations, as elevation and rainfall are primary drivers of flooding, while land cover affects infiltration and runoff. The lesser importance of slope and other topographic features suggests that, in this region, they play a secondary role compared to elevation and precipitation, and the low importance of distance to river is consistent with our finding that proximity to channels within 3 km does not sharply separate flooded from non-flooded pixels.

This study has several limitations. The model is trained on a single flood event and uses mostly static predictors at 30 m resolution, so event-specific patterns, unresolved small-scale features, and missing dynamic variables (e.g., soil moisture, river stage, reservoir operations) all restrict generalization. In future work, rebalancing the training data (e.g., oversampling flooded pixels), tuning the classification threshold, and evaluating performance with precision–recall metrics could better handle class imbalance. Incorporating multiple flood events, additional hydrologic variables, and models that account for spatial context would likely improve flood detection and make this framework more useful for operational flood-risk assessment.


#bibliography("refs.bib", title:[= V. Sources])
