export default {
    key: [
      // Description of methods
      {
        page: 1,
        route: '/01-water-limitation',
        method: [
          {
            header: "Calculating supply and demand",
            description: [
                { 
                  id: 1,
                  text: "Supply and demand were calculated as average annual runoff (supply) and consumptive water use (demand) on a per-area basis for water years 2010 through 2020.",
                  refs: ["Stets2025", "Gorski2025", "Medalie2025"]},
                { id: 2,
                  text: "Water supply was calculated as the sum of annual runoff for all watersheds (HUC12) in the region divided by the area of the region.",
                  refs: ["Martinez2025supply"]},
                  { id: 2,
                    text: "Consumptive use was calculated as the sum of water consumed for crop irrigation, thermoelectric power, and public supply within all watersheds (HUC12) in the region divided by the area of the region.",
                    refs: ["VanMetre2020"]}
                ]
          },
          {
            header: "Calculating water limitation",
            description: [
              { 
                id: 1,
                text: "Water limitation was calculated as an average supply and use index, which expresses the imbalance between surface water-supply and consumptive uses in the lower 48 United States for water years 2010 through 2020.",
                refs: ["Stets2025"]},
              { id: 2,
                text: "The surface water-supply and use index was calculated from the balance of water supply and consumptive use at a monthly timestep on a watershed (HUC12) basis.",
                refs: ["Miller2024sui"]}
              ]
          }
        ]
      },      
      {
        page: 2,
        route: '/02-water-availability',
        method: [
          {
            header: "Determining impacts on water availability",
            description: [
              { 
                id: 1,
                text: "Integrated water availability was characterized using indices for four indicators of water availability: water quantity, surface-water quality, groundwater quality, and ecological flows. ",
                refs: ["Stets2025", "Erickson2025"]},
              { id: 2,
                text: "For each indicator, values were aggregated by hydrologic region and then ranked to create a relative value of water stress. The hydrologic regions were assigned an index value from 1 to 5 based on their ranking and natural breaks in the distribution. <ol><li>Water quantity impact assessment categories were based on the surface water-supply and use index, which was calculated from the balance of water supply and consumptive use at a monthly timestep on a 12-digit hydrologic unit code (HUC12) basis. Regional SUI rankings were based on the percentage of area with high or severe SUI, corresponding to greater than (>) 60 percent depletion of normal water supply.</li><li>Surface-water quality impact assessment categories were based on the combined results of SPAtially Referenced Regressions On Watershed attributes model estimates of surface-water total nitrogen and total phosphorus. Hydrologic regions were ranked based on the percentage of area having total nitrogen or total phosphorus concentrations >4 times higher than the Environmental Protection Agency National Rivers and Streams Assessment regional “Good” standard. </li><li>Groundwater quality impact assessment categories were based on CONUS models for nitrate and arsenic. The hydrologic regions were assigned index values from 1 to 5 for nitrate and arsenic based on their concentrations for each.</li><li>Ecological water availability impact assessment categories were based on a combination of the regional flow-ecology relationships established with machine-learning predictions of flow regime at the National Hydrography Dataset Plus v2.1 stream reach scale. Alteration status (in other words, altered or unaltered) was determined for high- and low-flow magnitude, duration, and variability metrics. </li></ol>",
                refs: []}
              ]
          },
          {
            header: "Assessing future impacts",
            description: [
            { 
              id: 1,
              text: "Impacts to future water availability were assessed by a review of recent literature in peer-reviewed journals and synthesis of information in the Intergovernmental Panel on Climate Change Sixth Assessment Report (IPCC AR6) and Fifth National Climate Assessment.",
              refs: ["IPCC2022", "Crimmins2023"]
            },
            { id: 2,
              text: "The framework of climatic impact drivers outlined in the (IPCC AR6) was used to show primary drivers of physical changes in water cycle processes and to explain projected changes in future water availability.",
              refs: ["Scholl2025"]}
            ]
          }
        ],
      },
      {
        page: 3,
        route: '/03-vulnerability',
        method: [
          {
            header: "Calculating water limitation",
            description: [
              { 
                id: 1,
                text: "Water limitation was calculated as an average supply and use index, which expresses the imbalance between surface water-supply and consumptive uses in the lower 48 United States for water years 2010 through 2020.",
                refs: ["Stets2025"]},
              { id: 2,
                text: "The surface water-supply and use index was calculated from the balance of water supply and consumptive use at a monthly timestep on a watershed (HUC12) basis.",
                refs: ["Miller2024sui"]}
              ]
            },
          {
            header: "Mapping Census Data",
            description: [
              {
                id: 1,
                text: "The population estimate within each HUC12 catchment was calculated using the 2020 U.S. Census Bureau tract-level population counts and merged with water limitation data by watershed (HUC12).",
                refs: ["Census2020"]
              }
            ]
          },
          {
            header: "Calculating social vulnerability",
            description: [
              {
                id: 1,
                text: "The Centers for Disease Control 2020 Social Vulnerability Index (SVI) was used to examine the relationship between socioeconomic factors and water limitation.",
                refs: ["CDC2022"]
              },
              { id: 2,
                text: "The SVI includes indicators reflecting community characteristics and composition that may lead to differential effects from hazard exposures. The SVI provides a percentile ranking of all census tracts on a scale from 0 to 1 where higher values across all rankings indicate higher vulnerability. Categories of social vulnerability were defined such that values less than 0.25 indicate low vulnerability, values between 0.25 and 0.5 indicate moderate vulnerability, values between 0.5 and 0.75 indicate high social vulnerability, and values greater than 0.75 indicate severe vulnerability.",
                refs: []
              }
            ]
          }
        ]
      },
      {
        page: 4,
        route: '/04-water-supply',
        method: [
          {
            header: "Modeling the national water cycle",
            description: [
              { id: 1, 
                text: "The annual average hydrologic fluxes and components across the lower 48 United States were calculated for water years 2010 through 2020.", 
                refs: ["Gorski2025"]},
              { id: 2, 
                text: "Precipitation data were from the bias-adjusted 4-kilometer, 40-year long-term regional hydroclimate reanalysis over the lower 48 United States and evapotranspiration, soil moisture, and streamflow data were ensembled from the National Hydrologic Model Precipitation-Runoff Modeling System and the Weather Research and Forecasting model hydrologic modeling system.", 
                refs: ["Foks2025a","Foks2025b","Sampson2025","Martinez2025supply"]},
              { id: 3, 
                text: "Consumptive use includes the sum of all consumptive use for crop irrigation, public supply, and thermoelectric power generation.", 
                refs: ["Medalie2025"]}
          ]
          },
          {
            header: "Comparing water supply to normal",
            description: [
              { id: 1,
                text: "The average monthly amounts of precipitation (mm), evapotranspiration (mm), soil moisture (%), and streamflow (cfs) were calculated for each hydrologic region.",
                refs: ["VanMetre2020","Martinez2025supply"]
              },
              { id: 2,
                text: "Then, the monthly values were compared to the average to calculate a normalized deviation from the average for each month and region.",
                refs: []
              }
            ]
          }
        ]
      },      
      {
        page: 5,
        route: '/05-nutrients',
        method: [
          {
            header: "Modeling nutrient loads",
            description: [
              { id: 1,
                text: "Total and source-specific nitrogen and phosphorus loads from five spatially explicit modeling studies were integrated to assess CONUS spatial patterns in loads and sources.",
                refs: ["Martinez2024sparrow", "Ator2019", "Hoos2019", "Robertson2019", "Wise2019a", "Wise2019b"]
              },
              { id: 2,
                text: "Sources were generalized to enable a simple comparison.",
                refs: []
              }
            ]
          }
        ]
      },      
      {
        page: 6,
        route: '/06-water-quality',
        method: [
          {
            header: "Calculating aquifer benchmarks",
            description: [
              { id: 1,
                text: "Pie charts display the percentage of the area studied that contained a constituent in untreated groundwater at a concentration that exceeds a human-health benchmark for drinking water (high) or one-half of that value (moderate).",
                refs: ["Erickson2025", "Belitz2022", "Azadpour2025"]
              },
              { id: 2,
                text: "For this analysis, 16 drinking water contaminants were analyzed, including arsenic, manganese, lead, and nitrate.",
                refs: []
              }
            ]
          },
          {
            header: "Calculating threats to surface water",
            description: [
              { id: 1,
                text: "Water use type (drinking water, fish consumption, recreation), threat category, and threat are quantified by total river miles. These data were obtained from the United States Environmental Protection Agency Assessment, Total Maximum Daily Load (TMDL) Tracking and Implementation System database",
                refs: ["EPA2023"]
              }
            ]
          }
        ]
      },      
      {
        page: 7,
        route: '/07-water-use',
        method: [
          {
            header: "Modeling water use by year",
            description: [
              { id: 1,
                text: "Monthly water used for crop irrigation, public supply, and thermoelectric power for the lower 48 United States was modeled for water years 2000 through 2020 and averaged to a daily value. Thermoelectric water withdrawals were classified as saline or freshwater. All water use data were obtained from water-use models for the categories of public supply, crop irrigation, and thermoelectric power.",
                refs: ["Galanter2023", "Luukkonen2023", "Martin2023", "Haynes2024"]
              },
              { id: 2,
                text: "Estimates of water use from models are made at places of use rather than where the withdrawals occur. For example, estimates are made for areas served by public suppliers, for fields that are irrigated, and for thermoelectric facilities. This distinction can be important in places where water is transported from one place in a canal, tunnel, pipe, or aqueduct for use in another place.",
                refs: []
              }
            ]
          },

          {
            header: "Calculating consumptive use",
            description: [
              { id: 1,
                text: "For this analysis, the percent of consumptive use for each use category (public supply, irrigation, and thermoelectric power) was calculated as the amount of water consumed divided by the total water withdrawn. The amounts of water withdrawn or consumed were calculated based on average annual values for the lower 48 United States for water years 2000 through 2020. Water use data were obtained from water-use models for the categories of public supply, crop irrigation, and thermoelectric power",
                refs: ["Galanter2023", "Luukkonen2023", "Martin2023", "Haynes2024"]
              }
            ]
          }
        ]
      },      
      {
        page: 8,
        route: '/08-regional-wu',
        method: [
          {
            header: "Modeling water use",
            description: [
              { id: 1,
                text: "Total water used for crop irrigation, public supply, and thermoelectric power for the lower 48 United States was modeled monthly for water year 2020 and averaged to a daily value. Thermoelectric water withdrawals were classified as saline or freshwater. All water use data were obtained from newly available output from three water-use models for the categories of public supply, crop irrigation, and thermoelectric power.",
                refs: ["Galanter2023", "Luukkonen2023", "Martin2023", "Haynes2024"]
              },
              { id: 2,
                text: "Estimates of water use from models are made at places of use rather than where the withdrawals occur. For example, estimates are made for areas served by public suppliers, for fields that are irrigated, and for thermoelectric facilities. This distinction can be important in places where water is transported from one place in a canal, tunnel, pipe, or aqueduct for use in another place.",
                refs: []
              }
            ]
          }
        ]
      }

    ]
}
