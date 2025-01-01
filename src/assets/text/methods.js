export default {
    key: [
      // Description of methods
      {
        page: 1,
        route: '/01Budget',
        method: [
          {
            header: "Calculating supply and demand",
            description: "Supply and demand were calculated as average annual runoff (supply) and consumptive water use (demand) on a per-area basis for water years 2010 through 2020 [cite Stets, Medalie, Gorksi, MillerDataRelease]. Water supply was calculated as the sum of annual runoff for all watersheds (HUC12) in the region divided by the area of the region. Consumptive use was calculated as the sum of water consumed for crop irrigation, thermoelectric power, and public supply within all watersheds (HUC8) in the region divided by the area of the region. Hydrologic regions are based on Van Metre et al. (2020) river basins [cite VM].",
          },
          {
            header: "Calculating water limitation",
            description: "Water limitation was calculated as an average supply and use index, which expresses the imbalance between surface water-supply and consumptive uses in the lower 48 United States for water years 2010 through 2020. The surface water-supply and use index was calculated from the balance of water supply and consumptive use at a monthly timestep on a watershed (HUC12) basis (Stets and others, in prep.)."
          }
        ]
        },      {
        page: 2,
        route: '/02SUI',
        method: [
          {
            header: "Determining impacts on water availability",
            description: "The multi-faceted analysis of water availability was developed using metrics for the following indicators of water availability: water budget, surface-water quality, groundwater quality, and ecological flows. For each metric, values were aggregated by hydrologic region and then ranked, as described herein, to create a relative value of water stress for that indicator. The hydrologic regions were then assigned an index value from 1 to 5 based on their ranking and natural breaks in the distribution. <ol><li>Water quantity impact assessment categories were based on the surface water-supply and use index, which was calculated from the balance of water supply and consumptive use at a monthly timestep on a 12-digit hydrologic unit code (HUC12) basis (Stets and others, in prep.). Regional SUI rankings were based on the percentage of area with high or severe SUI, corresponding to greater than (>) 60 percent depletion of normal water supply (Stets and others, in prep.).</li><li>Surface-water quality impact assessment categories were based on the combined results of SPAtially Referenced Regressions On Watershed attributes model estimates of surface-water total nitrogen and total phosphorus (Cashman and others, in prep.; chap. C, Erickson and others, 202X). We ranked the hydrologic regions based on the percentage of area having total nitrogen or total phosphorus concentrations >4 times higher than the Environmental Protection Agency National Rivers and Streams Assessment (EPA NRSA) regional “Good” standard (chap. C, Erickson and others,202X). </li><li>Groundwater quality impact assessment categories were based on CONUS models for nitrate and arsenic (Lombard and others, 2021; Ransom and others, 2022). The hydrologic regions were assigned index values from 1 to 5 for nitrate and arsenic based on their concentrations for each.</li><li>Ecological water availability impact assessment categories were based on a combination of the regional flow-ecology relationships established by Carlisle and others (2019) with machine-learning predictions of flow regime at the National Hydrography Dataset Plus v2.1 stream reach scale. Alteration status (in other words, altered or unaltered) was determined for high- and low-flow magnitude, duration, and variability metrics by Carlisle (2019).</li></ol>"
          },
          {
            header: "Determining future impacts",
            description: "The impacts to future water availability were determined by a review of recent literature in peer-reviewed journals and synthesis of information in the Intergovernmental Panel on Climate Change Sixth Assessment Report (IPCC AR6) (Intergovernmental Panel on Climate Change, 2021) and Fifth National Climate Assessment (U.S. Global Change Research Program, 2023). The framework of climatic impact drivers outlined in the (IPCC AR6) was used to show primary drivers of physical changes in water cycle processes and to explain projected changes in future water availability.",
          }
        ]
      },      {
        page: 3,
        route: '/03SVI',
        method: [
          {
            header: "Calculating water limitation",
            description: "Water limitation was calculated as an average supply and use index, which expresses the imbalance between surface water-supply and consumptive uses in the conterminous United States for water years 2010 through 2020. For the population bubbles, categories of water limitation included very low, which was between 0 and 0.2, low between 0.2 and 0.4, moderate between 0.4 and 0.6, high between 0.6 and 0.8, and severe, which was above 0.8. To simplify the map with social vulnerability, the categories were low, below 0.4, moderate, between 0.4 and 0.6, and high, which was above 0.6."
          },
          {
            header: "Mapping Census Data",
            description: "The population estimate within each HUC12 catchment was calculated using the 2020 U.S. Census Bureau tract-level population counts (U.S. Census Bureau, 2020). Census data were merged with water limitation data by watershed (HUC12)."
          },
          {
            header: "Calculating social vulnerability",
            description: "The Centers for Disease Control 2020 Social Vulnerability Index (SVI) was used to examine the relationship between socioeconomic factors and water limitation (Centers for Disease Control, 2022). The SVI includes indicators reflecting community characteristics and composition that may lead to differential effects from hazard exposures (Flanagan et al., 2011). The SVI provides a percentile ranking of all census tracts on a scale from 0 to 1 where higher values across all rankings indicate higher vulnerability. Categories of social vulnerability were defined such that values less than 0.4 indicate low vulnerability, values between 0.4 and 0.6 indicate medium vulnerability, and values greater than 0.6 indicate high vulnerability.",
          }
        ]
      },      {
        page: 4,
        route: '/04Drought',
        method: [
          {
            header: "Modeling the national water cycle",
            description: "The annual average hydrologic fluxes across the conterminous United States was calculated for water years 2010 through 2020. Precipitation data were from the bias-adjusted 4-kilometer, 40-year long-term regional hydroclimate reanalysis over the conterminous United States (Foks et al. in prep) and evapotranspiration and streamflow data were ensembled from the National Hydrologic Model Precipitation-Runoff Modeling System (Foks et al. in prep) and the Weather Research and Forecasting model hydrologic modeling system (Sampson et al., in prep). Consumptive use includes the sum of all consumptive use for crop irrigation, public supply, and thermoelectric power generation (Medalie et al. 2025).",
          },
          {
            header: "Comparing water supply to normal",
            description: "The average monthly amounts of precipitation (mm), evapotranspiration (mm), soil moisture (%), and streamflow (cfs) were calculated for each hydrologic region. Then, the monthly values were compared to the average to calculate a normalized deviation from the average for each month and region.",
          }
        ]
      },      {
        page: 5,
        route: '/05WQSource',
        method: [
          {
            header: "Modeling nutrient sources",
            description: "Total and source-specific nutrient loads from five spatially explicit modeling studies were integrated to assess CONUS spatial patterns in loads and sources (Ator, 2019; Hoos and Roland, 2019; Robertson and Saad, 2019; Wise, 2019; Wise et al., 2019). Common sources across regions were generalized to enable a simple comparison.",
          },
          {
            header: "Mapping nutrient loads",
            description: "Predicted total nitrogen and phosphorus loads were modeled from 2012 mean annual 'Spatially referenced regressions on watershed' attributes models (Schwarz et al., 2006). Loads were merged spatially with watershed (HUC12) locations for mapping.",
          }
        ]
      },      {
        page: 6,
        route: '/06WQThreats',
        method: [
          {
            header: "Calculating threats to water",
            description: "Water use type (drinking water, fish consumption, recreation), threat category, and threat are quantified by total river miles. These data were obtained from the United States Environmental Protection Agency (USEPA) Assessment, Total Maximum Daily Load (TMDL) Tracking and Implementation System (ATTAINS) database (U.S. Environmental Protection Agency, 2023c).",
          },
          {
            header: "Calculating aquifer quality",
            description: "Colored pie charts indicate the percentage of the area studied that contained a constituent in untreated groundwater at a concentration that exceeds a human-health benchmark for drinking water (high) or one-half of that value (moderate). Data from Belitz and others (2022).",
          }
        ]
      },      {
        page: 7,
        route: '/07WaterUse',
        method: [
          {
            header: "Calculating water use by year",
            description: "Total water used for crop irrigation, public supply, and thermoelectric water use for the conterminous United States was calculated for water years 2010 through 2020. Thermoelectric water withdrawals were classified as saline or freshwater. All water use data were obtained from newly available output from three water-use models for the categories of public supply, crop irrigation, and thermoelectric power (Galanter et al., 2023; Luukkonen et al., 2023; Martin et al., 2023; Haynes et al., 2024). Estimates of water use from models are made at places of use rather than where the withdrawals occur. For example, estimates are made for areas served by public suppliers, for fields that are irrigated, and for thermoelectric facilities. This distinction can be important in places where water is transported from one place in a canal, tunnel, pipe, or aqueduct for use in another place.",
          }
        ]
      },      {
        page: 8,
        route: '/08WaterUseRegional',
        method: [
          {
            header: "Spatial patterns in water use",
            description: "The proportion of use by category (public supply, irrigation, and thermoelectric water use) were calculated based on annual average withdrawals for each watershed (HUC12) in the conterminous United States for water years 2010 through 2020. Water use data were obtained from newly available output from three water-use models for the categories of public supply, crop irrigation, and thermoelectric power (Galanter et al., 2023; Luukkonen et al., 2023; Martin et al., 2023; Haynes et al., 2024).",
          },
          {
            header: "Comparing water sources by use",
            description: "The total water withdrawn from groundwater versus surface water was compared by use category and across all uses. The values for each watershed (HUC12) were calculated as average annual withdrawals for water years 2010 through 2020. Water use data were obtained from newly available output from three water-use models for the categories of public supply, crop irrigation, and thermoelectric power (Galanter et al., 2023; Luukkonen et al., 2023; Martin et al., 2023; Haynes et al., 2024).",
          }
        ]
      },      {
        page: 9,
        route: '/09Consumption',
        method: [
          {
            header: "Calculating consumptive use",
            description: "For this analysis, the percent of consumptive use for each use category (public supply, irrigation, and thermoelectric water use) was calculated as the amount of water consumed divided by the total water withdrawn. The amount of water withdrawn or consumed were calculated based on average annual values for the conterminous United States for water years 2010 through 2020. Water use data were obtained from newly available output from three water-use models for the categories of public supply, crop irrigation, and thermoelectric power (Galanter et al., 2023; Luukkonen et al., 2023; Martin et al., 2023; Haynes et al., 2024).",
          }
        ]
      },      {
        page: 10,
        route: '/10Future',
        method: [
          {
            header: "Determining future impacts",
            description: "The impacts to future water availability were determined by a review of recent literature in peer-reviewed journals and synthesis of information in the Intergovernmental Panel on Climate Change Sixth Assessment Report (IPCC AR6) (Intergovernmental Panel on Climate Change, 2021) and Fifth National Climate Assessment (U.S. Global Change Research Program, 2023). The framework of climatic impact drivers outlined in the (IPCC AR6) was used to show primary drivers of physical changes in water cycle processes and to explain projected changes in future water availability.",
          }
        ]
      }

    ]
}
