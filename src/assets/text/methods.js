export default {
    key: [
      // Description of methods
      {
        page: 1,
        route: '/01Budget',
        description: "Supply and demand were calculated as mean annual runoff (supply) and consumptive water use (demand) on a per-area basis for water years 2010 through 2020. Water years begin on October 1 of the year previous and end on September 30 of the year in which they're named. Interannual variation in supply and demand are presented as standard deviations. <br><br> Water stress was calculated as an average surface water-supply and use index, which expresses the imbalance between surface water-supply and consumptive uses in the conterminous United States for water years 2010 through 2020. Categories of water stress are very low or none indicating values <= 0.2, low indicating values >0.2 and <= 0.4, medium indicating values > 0.4 and <= 0.6, high indicating values > 0.6 and <= 0.8, and severe indicating values > 0.8."
      },      {
        page: 2,
        route: '/02SUI',
        description: "To calculate the number of people living in different water stress categories, we merged census data with water stress data by watershed (HUC12). Water stress was calculated as annual average water-supply and use index, which expresses the imbalance between surface water-supply and consumptive uses in the conterminous United States for water years 2010 through 2020. Categories of water stress are very low or none indicating values <= 0.2, low indicating values >0.2 and <= 0.4, medium indicating values > 0.4 and <= 0.6, high indicating values > 0.6 and <= 0.8, and severe indicating values > 0.8.<br><br> The extent to which water quantity, surface water quality, groundwater quality, and reduction of natural flows limit water availability were analyzed against quantitative values for a particular use. For the surface-water quantity indicator, water-supply and use index was used. For the surface water-quality indicator, surface water total nitrogen and total phosphorus were compared to the NRSA Good benchmark. For the groundwater-quality indicator, predicted nitrate and arsenic concentrations were compared to the regulatory enforceable drinking water MCLs. For the ecological flow alteration indicator, predicted alteration of different aspects of the flow regime were compared to those aspects of the flow regime that have been shown to affect regional ecological health."
      },      {
        page: 3,
        route: '/03SVI',
        description: "To examine the relation between socioeconomic factors and greater vulnerability to a supply imbalance or degraded water quality in this chapter, we use the Centers for Disease Control (CDC) Social Vulnerability Index (SVI; Centers for Disease Control, 2022). The SVI, developed in the early 2000s, includes indicators reflecting community characteristics and composition that may lead to differential effects from hazard exposures (Flanagan and others, 2011). We use SVI data from 2020. The SVI provides a percentile ranking of all census tracts on a scale from 0 to 1 where higher values across all rankings indicate higher vulnerability. Water stress was calculated as annual average water-supply and use index, which expresses the imbalance between surface water-supply and consumptive uses in the conterminous United States for water years 2010 through 2020. Categories of low, medium and high were consistent for SVI and water stress with low indicating values <= 0.4, medium indicating values > 0.4 and <= 0.6, and high indicating values > 0.6."
      },      {
        page: 4,
        route: '/04Drought',
        description: "Annual average hydrologic fluxes across the conterminous United States for water years 2010 through 2020. Precipitation data are from the bias-adjusted 4-kilometer, 40-year long-term regional hydroclimate reanalysis over the conterminous United States (Foks and others, In Prep a) and evapotranspiration and streamflow data are ensembled from the National Hydrologic Model Precipitation-Runoff Modeling System (Foks and other, In Prep b) and the Weather Research and Forecasting model hydrologic modeling system (Sampson and others, In Prep). Consumptive use represents the sum of crop irrigation, public supply, and thermoelectric power generation consumptive use; further details are available in Medalie and others, 202X (chap.D)."
      },      {
        page: 5,
        route: '/05WQSource',
        description: "We integrated total and source-specific nutrient loads from five spatially explicit modeling studies (SPARROW) models to assess CONUS spatial patterns in loads and sources (Ator, 2019; Hoos and Roland, 2019; Robertson and Saad, 2019; Wise, 2019; Wise and others, 2019). The five regional models had variability in their sources, so we generalized some common sources to enable a simple comparison."
      },      {
        page: 6,
        route: '/06WQThreats',
        description: "We determined the total number of river miles by use (drinking water, fish consumption, recreation), threat category, and threat. All data were obtained from the United States Environmental Protection Agency (USEPA) Assessment, Total Maximum Daily Load (TMDL) Tracking and Implementation System (ATTAINS) database (U.S. Environmental Protection Agency, 2023c)."
      },      {
        page: 7,
        route: '/07WaterUse',
        description: "We calculated total water withdrawn for crop irrigation, public supply, and thermoelectric water use for the conterminous United States for water years 2010 through 2020. Thermoelectric water withdrawals were classified as saline or freshwater. All water use data were obtained from newly available output from three water-use models for the categories of public supply, crop irrigation, and thermoelectric power (Galanter and others, 2023; Luukkonen and others, 2023; Martin and others, 2023; Haynes and others, 2024). "
      },      {
        page: 8,
        route: '/08WaterUseRegional',
        description: "We determined the proportion of water withdrawal by use for each HUC8 region in the conterminous United States. The proportions were based on the average annual water withdrawal by category (public supply, irrigation, and thermoelectric water use) for water years 2010 through 2020. <br><br> We also compared the amount of total water withdrawn from groundwater versus surface water by use category and across all uses. The values for each HUC8 region were calculated as average annual withdrawals for the conterminous United States for water years 2010 through 2020. <br><br> All water use data were obtained from newly available output from three water-use models for the categories of public supply, crop irrigation, and thermoelectric power (Galanter and others, 2023; Luukkonen and others, 2023; Martin and others, 2023; Haynes and others, 2024). "
      },      {
        page: 9,
        route: '/09Consumption',
        description: "The percent consumed was calculated as the amount of water consumed for a use versus the water withdrawn. The amount of water withdrawn or consumed for crop irrigation, thermoelectric power, and public supply use were calculated based on average annual values for the conterminous United States for water yeards 2010 through 2020. All water use data were obtained from newly available output from three water-use models for the categories of public supply, crop irrigation, and thermoelectric power (Galanter and others, 2023; Luukkonen and others, 2023; Martin and others, 2023; Haynes and others, 2024). "
      },      {
        page: 10,
        route: '/10Future',
        description: "How we made this"
      }

    ]
}
