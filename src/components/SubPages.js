export default {
    SubPages: [
        {
            page: 1,
            route: '/01Budget',
            mainTitle: 'Do we have enough water? Yes, and no',
            shortTitle: 'The U.S. has enough water, but not regionally',
            keyMessage: 'At the national scale, water supply is much higher than our demand for water. However, this pattern is not true for all regions.',
            references: ["Stets2024", "Stets2025", "Medalie2025"]
        },
        {
            page: 2,
            route: '/02SUI',
            mainTitle: 'Living with water limitation',
            shortTitle: 'About 27 million people in the U.S. live in areas of high or severe water limitation',
            keyMessage: 'About 8% of the CONUS population, or 26.7 million people, live in areas where human water use routinely meets or exceeds renewable water supply.',
            references: ["Liu2022", "Dettingher2005","Stets2024", "Stets2025", "Census2020"],
            tabData: [
                {
                    tabTitle: "Water Quantity",
                    tabSubtitle: "Water availability is limited by water quantity",
                    tabTitleID: "sui",
                    tabTitleIDname: "sui",
                    tabText: "The overall balance between water supply and consumptive use is a primary consideration in water availability studies. Globally, the factors affecting human water security are highly correlated; the infrastructure that allows elevated water use also promotes water-quality degradation and decreases biotic integrity (Vörösmarty and others, 2010). For example, intense water withdrawal, even if restored to the local system through return flow, can degrade water quality because the water may return with increased sediment, nutrients, or salinity (Lin and Garcia, 2012; Park and others, 2018)."
                },{
                    tabTitle: "Surface Water Quality",
                    tabSubtitle: "Water availability is limited by surface water quality",
                    tabTitleID: "sw",
                    tabTitleIDname: "sw_wq",
                    tabText: "Surface water quality can be degraded by nutrients, sediment, temperature, pathogens, salinity, and pesticides. Sources of water quality contaminants include agriculture, wastewater, air pollution, other human sources such as mining and land-use change, and natural sources such as springs and streamflow. Areas of the country that strongly indicate surface water quality issues include the High Plains, Souris-Red-Rainy, and the Midwest regions, largely due to the application of fertilizer and manure for agriculture (chap. C, Erickson and others, 202x)."
                },{
                    tabTitle: "Groundwater Quality",
                    tabSubtitle: "Water availability is limited by groundwater quality",
                    tabTitleID: "gw",
                    tabTitleIDname: "gw_wq",
                    tabText: "Groundwater-derived drinking water can be affected by high concentrations of constituents from geologic sources, including arsenic, manganese, strontium, radionuclides, fluoride, and lithium, as well as salinity and nitrogen. Mixtures of multiple groundwater contaminants can also have compounding effects, because different users may have elevated sensitivity when exposed to multiple water-quality issues at once (Kaushal and others, 2018; Waite and others, 2019, 2021). Threats to human health, corrosion of infrastructure, reduced crop yields, poor taste, impeded navigation, and economic impacts can all result from poor water quality (chap. C, Erickson and others, 202X)."
                },{
                    tabTitle: "Ecoflows",
                    tabSubtitle: "Water availability for ecosystems is limited by altered natural flows",
                    tabTitleID: "eco",
                    tabTitleIDname: "ecoflow",
                    tabText: "Humans alter the natural flow of water by building water management structures, such as reservoirs, impoundments, and diversions, and covering land with impervious surfaces. We create water-management structures to improve quality of life by creating hydroelectric power, controlling flood risk, capturing and distributing drinking water, and irrigating crops. These structures can affect the flow regime through water storage and releases, potentially altering the timing, seasonality, frequency, and rate of change of flows (Kennedy and others, 2016; Eng and others, 2019; Moreira and others, 2019), even if total flow volume remains equivalent. Anthropogenic land cover, such as urban areas and impervious surfaces, can also affect flow attributes by increasing the rate of runoff, resulting in greater high-flow magnitude and frequency, while decreasing flow durations (Eng and others, 2019)."
                },
            ]
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
            mainTitle: 'Future water availability',
            shortTitle: 'All elements of the water cycle will change under future climate conditions',
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