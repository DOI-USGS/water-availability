export default {
    SubPages: [
        {
            page: 1,
            route: '/01Budget',
            mainTitle: 'Do we have enough water? Yes, and no',
            shortTitle: 'The U.S. has enough water, but not regionally',
            keyMessage: 'At the national scale, water supply is much higher than our demand for water. However, this pattern is not true for all regions.',
            references: ["Stets2024", "Stets2025"]
        },
        {
            page: 2,
            route: '/02SUI',
            mainTitle: 'Living with water limitation',
            shortTitle: 'About 27 million people in the U.S. live in areas of high or severe water limitation',
            keyMessage: 'About 8% of the CONUS population, or 26.7 million people, live in areas where human water use routinely meets or exceeds renewable water supply.',
            references: ["Liu2022", "Dettingher2005","Stets2024", "Stets2025", "Census2020"]
        },
        {
            page: 3,
            route: '/03SVI',
            mainTitle: 'Unequal access to water',
            shortTitle: 'Socially vulnerable Americans have a higher risk of water limitation',
            keyMessage: 'A high proportion of the population living in areas with water limitation are socially vulnerable',
            references: [ "Drakes2024", "Stets2025"]
        },
        {
            page: 4,
            route: '/04Drought',
            mainTitle: 'Not enough rain and snow',
            shortTitle: 'Disruptions to the water cycle can cause water limitation',
            keyMessage: 'Periods of low precipitation can have cascading effects throughout the water cycle, expanding areas of water limitation and exacerbating water quality issues.' ,
            references: [
                "Bell2015",
                "Hoerling2014",
                "Legates2011",
                "Gorski2025",
                "Stets2025"
            ]
        },
        {
            page: 5,
            route: '/05WQSource',
            mainTitle: 'Nutrients in the water',
            shortTitle: 'Water quality is affected by natural and human sources',
            keyMessage: 'Sources of water quality issues vary across CONUS. Common sources include fertilizer and manure, atmospheric deposition, wastewater treatment plants, urban land, and a range of natural sources including stream channel and geologic sources.',
            references: ["Erickson2025"]
        },
        {
            page: 6,
            route: '/06WQThreats',
            mainTitle: 'Making you sick',
            shortTitle: 'Major sources of contamination affect human health',
            keyMessage: 'Drinking water, fish consumption, and recreational water use face different threats to water quality.',
            references: [
                "Canedo2013",
                "Ngoubeyou2022",
                "Kaushal2018",
                "EPA2023",
                "Vareda2019",
                "Wentz2014",
                "Erickson2025"
            ]
        },
        {
            page: 7,
            route: '/07WaterUse',
            mainTitle: 'For farm, home, and energy',
            shortTitle: 'The largest demands for water are for irrigation, public supply, and thermoelectric power',
            keyMessage: 'About 225,000 million gallons of freshwater get used per day for irrigation (48%), public supply (16%), and thermoelectric power (36%).',
            references: ["Medelie2025"]
        },
        {
            page: 8,
            route: '/08WaterUseRegional',
            mainTitle: 'From sea to shining sea',
            shortTitle: 'How we use water varies across the country',
            keyMessage: 'Regionally, irrigation is the largest use in the western US; thermoelectric power generation is the largest use in the central and eastern US; and public supply is the largest use in heavily populated eastern states such as New York, New Jersey, and Rhode Island.  ',
            references: ["Medelie2025"]
        },
        {
            page: 9,
            route: '/09Consumption',
            mainTitle: 'Gone for good',
            shortTitle: 'Not all the water withdrawn for human water use returns to the local environment',
            keyMessage: 'Water that does not return to local water bodies or groundwater is lost to the atmosphere, plant and animal growth, or transferred to other areas. The proportion of water use consumed in this way is 74% for irrigation, 12% for public supply, and 4% for thermoelectric power.',
            references: ["Medelie2025"]
        },
        {
            page: 10,
            route: '/10Future',
            mainTitle: 'Future threats',
            shortTitle: 'All elements of the water cycle are threatened by future climate conditions',
            keyMessage: 'The top future threats to water availability in the U.S. vary regionally and include increases in drought, flooding, and heavy precipitation along with declines in snow and ice.',
            references: [
                "Ranasinghe2021",
                "IPCC2022",
                "Hicke2022",
                "Arias2021",
                "Scholl2025"
            ],
            tabData: [
                {
                    tabTitle: "Temperature",
                    tabSubtitle: "Likelihood of regional impacts from rising temperature",
                    tabTitleID: "temp",
                    tabTitleIDname: "impact-temp",
                    tabText: "Climate assessments indicate a high degree of confidence that changes in extreme heat, mean air temperature, and cold spells and frost will affect water resources in every region in the U.S., including Alaska, Hawaii, and the Caribbean islands. Extreme heat amplifies the effects of drought and increases evaporative loss from reservoirs. Increased stream temperatures harm fish health, especially in native, cold-water fisheries. Harmful algal blooms also increase with increasing water temperatures.  Higher air temperatures  lead to warmer and shorter winters, meaning less precipitation occurs as snowfall and less snowmelt for streamflow in the spring and early summer.",
                    listText: [
                        "Increase average air temperature",
                        "More common extreme heat events",
                        "Amplification of drought",
                        "Increased evaporative water loss",
                        "Effects on aquatic habitats and fish health",
                        "Warmer and shorter winter season",
                        "Decreased frost and cold"
                    ]
                },                {
                    tabTitle: "Precipitation",
                    tabSubtitle: "Likelihood of regional impacts from wetter conditions",
                    tabTitleID: "water",
                    tabTitleIDname: "impact-water",
                    tabText: "Changes in mean precipitation, river floods, and heavy precipitation leading to pluvial floods  are projected to vary across the country. There is a high degree of confidence that changes in precipitation-related climate drivers will affect Alaska, the Northeast, and the Southeast, and moderately confident that changes in those drivers will affect the remaining regions of the United States. Most regions of the U.S. are seeing more extreme precipitation and flooding events than in past decades,. Extreme flooding events, like 2024’s Hurricane Helene in North Carolina, have a multitude of negative effects on water availability, including impairing water quality and disrupting water infrastructure.",
                    listText: [
                        "Increased mean precipitation",
                        "More extreme precipitation and flooding",
                        "Changes in streamflow amount and timing",
                        "Effects on agriculture",
                        "Water quality impairment"
                    ]
                },                {
                    tabTitle: "Aridity",
                    tabSubtitle: "Likelihood of regional impacts from drier conditions",
                    tabTitleID: "dry",
                    tabTitleIDname: "impact-dry",
                    tabText: "Climate assessments indicate that increases in drought and fire weather and aridity will have the highest likelihood of impacting the Western region of the contiguous U.S. Overall, the amount and timing of streamflow is expected to change, the demand for groundwater to increase, and stream baseflow  to decrease.",
                    listText: [
                        "Increased groundwater demand",
                        "Changes in streamflow amount and timing",
                        "Reduced baseflow",
                        "Effects on agriculture",
                        "Water quality impairment",
                        "More frequent and long-lasting fire weather",
                        "Amplification of drought"
                    ]
                },                {
                    tabTitle: "Snow",
                    tabSubtitle: "Likelihood of regional impacts from changing snow and ice",
                    tabTitleID: "ice",
                    tabTitleIDname: "impact-ice",
                    tabText: "Climate assessments indicate a high degree of confidence that every region in the U.S. except Hawaii and the Caribbean islands will see changes in snow and ice. Changes in many areas will bring a smaller extent of snow cover and sooner snow melt. Ice in lakes and rivers is declining, as are glaciers. Permafrost is thawing, and the transition line between rain and snow is moving north (meaning we see more rain where we used to see snow).",
                    listText: [
                        "Decrease in snowfall",
                        "Earlier snowmelt runoff",
                        "Decreasing lake and river ice extent",
                        "Reduced snow cover extent and duration",
                        "Decreasing glaciers and increasing meltwater",
                        "Thawing permafrost",
                        "Alteration of rain and snow patterns"
                    ]
                },                {
                    tabTitle: "Wind",
                    tabSubtitle: "Likelihood of regional impacts from changing winds",
                    tabTitleID: "wind",
                    tabTitleIDname: "impact-wind",
                    tabText: "The projected effects of wind on water availability vary from region to region. Climate assessments indicate a moderate degree of confidence that changes in wind will affect the Northwest and Southwest and moderate confidence that they will affect the rest of the U.S.. We expect to see decreased wind speeds, an increase in severe windstorms and sand and dust storms;, and stronger hurricanes. ",
                    listText: [
                        "Decrease in average wind speed",
                        "Increase in sand and dust storms",
                        "Stronger hurricanes",
                        "Increase in severe wind storms",
                        "Increase erosion"
                    ]
                },                {
                    tabTitle: "Coastal",
                    tabSubtitle: "Likelihood of regional impacts from coastal change",
                    tabTitleID: "coastal",
                    tabTitleIDname: "impact-coast",
                    tabText: "Climate assessments indicate a high degree of confidence that climate impacts on water resources in coastal areas will impact all areas of the U.S. that border an ocean. Along with sea level rise, we expect to see larger storm surges, an increased frequency and severity of coastal flooding, and greater incursion of saltwater into freshwater aquifers, estuaries, wetlands, and soils via storm floodwaters.",
                    listText: [
                        "Rising sea levels",
                        "Increase in storm surge",
                        "Increase in saltwater intrusion",
                        "Increased frequency and severity of coastal flooding"
                    ]
                }
            ]
        }
    ]
};