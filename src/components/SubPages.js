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
            mainTitle: 'Limits on water availability',
            shortTitle: 'About 27 million people in the U.S. live in areas of high or severe water limitation',
            keyMessage: 'About 8% of the CONUS population, or 26.7 million people, live in areas where most of the renewable water supply is consumed for human water use.',
            references: ["Liu2022", "Dettingher2005","Stets2024", "Stets2025", "Census2020"]
        },
        {
            page: 3,
            route: '/03SVI',
            mainTitle: 'Unequal access to water',
            shortTitle: 'Socially vulnerable Americans have a higher risk of water limitation',
            keyMessage: 'Water limitation disproportionately affects socially vulnerable populations in the U.S., creating problems for equitable access to clean water.',
            references: [ "Drakes2024", "Stets2025"]
        },
        {
            page: 4,
            route: '/04Drought',
            mainTitle: 'Not enough rain and snow',
            shortTitle: 'Limited water supply can cause water imbalance',
            keyMessage: 'Periods of low precipitation can have cascading effects throughout the water cycle, expanding areas of water limitation and exacerbating water quality issues' ,
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
            shortTitle: 'Natural and human sources of nutrients degrade water quality',
            keyMessage: 'Sources of nutrients in our water vary across the United States. Common sources of nutrients such as nitrogen and phosphorus include fertilizer and manure, atmospheric deposition, wastewater treatment plants, urban land, and a range of natural sources including stream channel and geologic sources.',
            references: ["Erickson2025"]
        },
        {
            page: 6,
            route: '/06WQThreats',
            mainTitle: 'Threats to water quality',
            shortTitle: 'Water quality issues can potentially affect human and aquatic health',
            keyMessage: 'Drinking water, fish consumption, and recreational water use face different water quality threats.',
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
            shortTitle: 'The largest demands for water are for crop irrigation, public supply, and thermoelectric power',
            keyMessage: 'About 224,000 million gallons of freshwater are used every day for irrigation (48%), public supply (16%), and thermoelectric power (36%).',
            references: ["Medelie2025"]
        },
        {
            page: 8,
            route: '/08WaterUseRegional',
            mainTitle: 'From sea to shining sea',
            shortTitle: 'How we use water varies across the country',
            keyMessage: 'Regionally, crop irrigation is the primary water use in the western and High Plains areas of the U.S., while the eastern half of the country uses water primarily for public supply or thermoelectric power.',
            references: ["Medelie2025"]
        },
        {
            page: 9,
            route: '/09Consumption',
            mainTitle: 'Gone but not forgotten',
            shortTitle: 'Not all the water withdrawn for human water use returns to the local environment',
            keyMessage: 'Water that does not return to local water bodies or groundwater is lost to the atmosphere, consumed by humans or livestock, or incorporated into products or crops. Across CONUS, the proportion of water use consumed in these ways is 72% for irrigation, 12% for public supply, and 4% for thermoelectric power.',
            references: ["Medelie2025"]
        },
        {
            page: 10,
            route: '/10Future',
            mainTitle: 'Future water availability',
<<<<<<< HEAD
            shortTitle: 'The water cycle is shifting due to climate change',
=======
            shortTitle: 'All elements of the water cycle will change under future climate conditions',
>>>>>>> 0331771e506d6135af346e341124f8a6c6672b8a
            keyMessage: 'The top impacts to water availability in the U.S. in the future vary regionally and include increases in drought, flooding, and heavy precipitation along with declines in snow and ice.',
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
                    tabSubtitle: "Potential impacts from rising temperature",
                    tabTitleID: "temp",
                    tabTitleIDname: "impact-temp",
                    tabText: "Climate assessments indicate a high degree of confidence that changes in extreme heat, mean air temperature, and cold spells and frost will affect water resources in every region in the U.S., including Alaska, Hawaii, and the Caribbean islands. Extreme heat amplifies the effects of drought and increases evaporative loss from reservoirs. Increased stream temperatures harm fish health, especially in native, cold-water fisheries. Harmful algal blooms also increase with increasing water temperatures.  Higher air temperatures  lead to warmer and shorter winters, meaning less precipitation occurs as snowfall and less snowmelt for streamflow in the spring and early summer.",
                    listText: [
                        "Increased average air temperature",
                        "More common extreme heat events",
                        "Amplified drought events",
                        "Increased evaporative water loss",
                        "Effects on aquatic habitats and fish health",
                        "Warmer and shorter winter season",
                        "Decreased frost and cold"
                    ]
                },                {
                    tabTitle: "Precipitation",
                    tabSubtitle: "Potential impacts from wetter conditions",
                    tabTitleID: "water",
                    tabTitleIDname: "impact-water",
                    tabText: "Changes in mean precipitation, river floods, and heavy precipitation leading to pluvial floods  are projected to vary across the country. There is a high degree of confidence that changes in precipitation-related climate drivers will affect Alaska, the Northeast, and the Southeast, and moderately confident that changes in those drivers will affect the remaining regions of the United States. Most regions of the U.S. are seeing more extreme precipitation and flooding events than in past decades,. Extreme flooding events, like 2024’s Hurricane Helene in North Carolina, have a multitude of negative effects on water availability, including impairing water quality and disrupting water infrastructure.",
                    listText: [
                        "Increased mean precipitation",
                        "More extreme precipitation and flooding",
                        "Changes in streamflow amount and timing",
                        "Effects on agriculture",
                        "Impaired water quality"
                    ]
                },                {
                    tabTitle: "Aridity",
                    tabSubtitle: "Potential impacts from drier conditions",
                    tabTitleID: "dry",
                    tabTitleIDname: "impact-dry",
                    tabText: "Climate assessments indicate that increases in drought and fire weather and aridity will have the highest likelihood of impacting the Western region of the contiguous U.S. Overall, the amount and timing of streamflow is expected to change, the demand for groundwater to increase, and stream baseflow  to decrease.",
                    listText: [
                        "Increased groundwater demand",
                        "Changes in streamflow amount and timing",
                        "Reduced baseflow",
                        "Effects on agriculture",
                        "Impaired water quality",
                        "More frequent and long-lasting fire weather",
                        "Amplified drought events"
                    ]
                },                {
                    tabTitle: "Snow",
                    tabSubtitle: "Potential impacts from changing snow and ice",
                    tabTitleID: "ice",
                    tabTitleIDname: "impact-ice",
                    tabText: "Climate assessments indicate a high degree of confidence that every region in the U.S. except Hawaii and the Caribbean islands will see changes in snow and ice. Changes in many areas will bring a smaller extent of snow cover and sooner snow melt. Ice in lakes and rivers is declining, as are glaciers. Permafrost is thawing, and the transition line between rain and snow is moving north (meaning we see more rain where we used to see snow).",
                    listText: [
                        "Decreased snowfall",
                        "Earlier snowmelt runoff",
                        "Decreased lake and river ice extent",
                        "Reduced snow cover extent and duration",
                        "Decreased glaciers and increasing meltwater",
                        "Thawing permafrost",
                        "Altered rain and snow patterns"
                    ]
                },                {
                    tabTitle: "Wind",
                    tabSubtitle: "Potential impacts from changing winds",
                    tabTitleID: "wind",
                    tabTitleIDname: "impact-wind",
                    tabText: "The projected effects of wind on water availability vary from region to region. Climate assessments indicate a moderate degree of confidence that changes in wind will affect the Northwest and Southwest and moderate confidence that they will affect the rest of the U.S.. We expect to see decreased wind speeds, an increase in severe windstorms and sand and dust storms;, and stronger hurricanes. ",
                    listText: [
                        "Decreased average wind speed",
                        "Increased sand and dust storms",
                        "Stronger hurricanes",
                        "Increased severe wind storms",
                        "Increased erosion"
                    ]
                },                {
                    tabTitle: "Coastal",
                    tabSubtitle: "Potential impacts from coastal change",
                    tabTitleID: "coastal",
                    tabTitleIDname: "impact-coast",
                    tabText: "Climate assessments indicate a high degree of confidence that climate impacts on water resources in coastal areas will impact all areas of the U.S. that border an ocean. Along with sea level rise, we expect to see larger storm surges, an increased frequency and severity of coastal flooding, and greater incursion of saltwater into freshwater aquifers, estuaries, wetlands, and soils via storm floodwaters.",
                    listText: [
                        "Rising sea levels",
                        "Increased storm surge",
                        "Increased saltwater intrusion",
                        "Increased frequency and severity of coastal flooding"
                    ]
                }
            ]
        }
    ]
};