export default {
    key: [
      // Description of methods
      {
        page: 1,
        route: '/01Budget',
        method: [
          {
            header: "Calculating supply and demand",
            description: "Supply and demand were calculated as mean annual runoff (supply) and consumptive water use (demand) on a per-area basis for water years 2010 through 2020. Error bars on the supply and demand were calculated as standard deviations between the years of analysis.",
          },
          {
            header: "Calculating water limitation",
            description: "Water limitation was calculated as an average supply and use index, which expresses the imbalance between surface water-supply and consumptive uses in the conterminous United States for water years 2010 through 2020. Categories of water limitation included very low, which was between 0 and 0.2, low between 0.2 and 0.4, moderate between 0.4 and 0.6, high between 0.6 and 0.8, and severe, which was above 0.8."
          }
        ]
        },      {
        page: 2,
        route: '/02SUI',
        method: [
          {
            header: "Calculating water limitation",
            description: "Water limitation was calculated as an average surface water-supply and use index, which expresses the imbalance between surface water-supply and consumptive uses in the conterminous United States for water years 2010 through 2020. Categories of water limitation were very low or none indicating values <= 0.2, low indicating values > 0.2 and <= 0.4, medium indicating values > 0.4 and <= 0.6, high indicating values > 0.6 and <= 0.8, and severe indicating values > 0.8."
          },
          {
            header: "Mapping Census Data",
            description: "To calculate the number of people living in different water limitation categories, we merged census data with water limitation data by watershed (HUC12)."
          },
          {
            header: "Integrated water availability",
            description: "The extent to which water quantity, surface water quality, groundwater quality, and reduction of natural flows limit water availability were analyzed against quantitative values for a particular use. For the surface-water quantity indicator, water-supply and use index was used. For the surface water-quality indicator, surface water total nitrogen and total phosphorus were compared to the NRSA Good benchmark (U.S. Environmental Protection Agency, 2020; chap. C, Erickson and others, 202X). For the groundwater-quality indicator, predicted nitrate and arsenic concentrations were compared to the regulatory enforceable drinking water MCLs. For the flows indicator, predicted alteration of different aspects of the flow regime were compared to those aspects of the flow regime that have been shown to affect regional ecological health."
          }
        ]
      },      {
        page: 3,
        route: '/03SVI',
        description: "Water limitation was calculated as annual average water-supply and use index, which expresses the imbalance between surface water-supply and consumptive uses in the conterminous United States for water years 2010 through 2020. ",
        method: [
          {
            header: "Calculating social vulnerability",
            description: "The Centers for Disease Control (CDC) 2020 Social Vulnerability Index (SVI) was used to examine the relationship between socioeconomic factors and water limitation (Centers for Disease Control, 2022). The SVI includes indicators reflecting community characteristics and composition that may lead to differential effects from hazard exposures (Flanagan and others, 2011). The SVI provides a percentile ranking of all census tracts on a scale from 0 to 1 where higher values across all rankings indicate higher vulnerability. Categories of social vulnerability were low indicating values <= 0.4, medium indicating values > 0.4 and <= 0.6, and high indicating values > 0.6.",
          },
          {
            header: "Calculating water limitation",
            description: "Water limitation was calculated as an average surface water-supply and use index, which expresses the imbalance between surface water-supply and consumptive uses in the conterminous United States for water years 2010 through 2020. Categories of water limitation were low indicating values <= 0.4, medium indicating values > 0.4 and <= 0.6, and high indicating values > 0.6."
          }
        ]
      },      {
        page: 4,
        route: '/04Drought',
        method: [
          {
            header: "Calculating the national water cycle",
            description: "The annual average hydrologic fluxes across the conterminous United States was calculated for water years 2010 through 2020. Precipitation data were from the bias-adjusted 4-kilometer, 40-year long-term regional hydroclimate reanalysis over the conterminous United States (Foks and others, In Prep a) and evapotranspiration and streamflow data were ensembled from the National Hydrologic Model Precipitation-Runoff Modeling System (Foks and other, In Prep b) and the Weather Research and Forecasting model hydrologic modeling system (Sampson and others, In Prep). Consumptive use includes the sum of all consumptive use for crop irrigation, public supply, and thermoelectric power generation (Medalie and others, 202X (chap.D)).",
          }
        ]
      },      {
        page: 5,
        route: '/05WQSource',
        method: [
          {
            header: "Calculating nutrient sources",
            description: "Total and source-specific nutrient loads from five spatially explicit modeling studies (SPARROW) models were integrated to assess CONUS spatial patterns in loads and sources (Ator, 2019; Hoos and Roland, 2019; Robertson and Saad, 2019; Wise, 2019; Wise and others, 2019). Common sources across regions were generalized to enable a simple comparison.",
          }
        ]
      },      {
        page: 6,
        route: '/06WQThreats',
        method: [
          {
            header: "Calculating threats to water",
            description: "Water use type (drinking water, fish consumption, recreation), threat category, and threat is quantified by total river miles. These data were obtained from the United States Environmental Protection Agency (USEPA) Assessment, Total Maximum Daily Load (TMDL) Tracking and Implementation System (ATTAINS) database (U.S. Environmental Protection Agency, 2023c).",
          }
        ]
      },      {
        page: 7,
        route: '/07WaterUse',
        method: [
          {
            header: "Calculating water use by year",
            description: "Total water withdrawn was calculated for crop irrigation, public supply, and thermoelectric water use for the conterminous United States for water years 2010 through 2020. Thermoelectric water withdrawals were classified as saline or freshwater. All water use data were obtained from newly available output from three water-use models for the categories of public supply, crop irrigation, and thermoelectric power (Galanter and others, 2023; Luukkonen and others, 2023; Martin and others, 2023; Haynes and others, 2024).",
          }
        ]
      },      {
        page: 8,
        route: '/08WaterUseRegional',
        method: [
          {
            header: "Spatial patterns in water use",
            description: "The proportion of use by category (public supply, irrigation, and thermoelectric water use) were calculated based on annual average withdrawals for each HUC8 region in the conterminous United States for water years 2010 through 2020. Water use data were obtained from newly available output from three water-use models for the categories of public supply, crop irrigation, and thermoelectric power (Galanter and others, 2023; Luukkonen and others, 2023; Martin and others, 2023; Haynes and others, 2024).",
          },
          {
            header: "Comparing water sources by use",
            description: "The total water withdrawn from groundwater versus surface water was compared by use category and across all uses. The values for each HUC8 region were calculated as average annual withdrawals for the conterminous United States for water years 2010 through 2020. Water use data were obtained from newly available output from three water-use models for the categories of public supply, crop irrigation, and thermoelectric power (Galanter and others, 2023; Luukkonen and others, 2023; Martin and others, 2023; Haynes and others, 2024).",
          }
        ]
      },      {
        page: 9,
        route: '/09Consumption',
        method: [
          {
            header: "Calculating consumptive use",
            description: "The percent of consumptive use for each use category (public supply, irrigation, and thermoelectric water use) was calculated as the amount of water consumed versus the total water withdrawn. The amount of water withdrawn or consumed were calculated based on average annual values for the conterminous United States for water yeards 2010 through 2020. Water use data were obtained from newly available output from three water-use models for the categories of public supply, crop irrigation, and thermoelectric power (Galanter and others, 2023; Luukkonen and others, 2023; Martin and others, 2023; Haynes and others, 2024).",
          }
        ]
      },      {
        page: 10,
        route: '/10Future',
        method: [
          {
            header: "Determining future impacts",
            description: "The impacts to future water availability were determined by a literature review. Specifically, we used the the framework of climatic impact drivers outlined in the Intergovernmental Panel on Climate Change Sixth Assessment Report (IPCC AR6) to show primary drivers of physical change to the water cycle and to understand and predict changes in future water availability.",
          }
        ]
      }

    ]
}
