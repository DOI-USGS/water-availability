export default {
    SubPages: [
        {
            page: 1,
            route: '/01Budget',
            mainTitle: 'Do we have enough water? Yes, and no',
            shortTitle: 'The U.S. has enough water, but not regionally',
            keyMessage: 'At the national scale, water supply is much higher than our demand for water. However, this pattern is not true for all regions.',
            references: ["Stets2025", "Medalie2025"]
        },
        {
            page: 2,
            route: '/02SUI',
            mainTitle: 'Limits on water availability',
            shortTitle: 'About 27 million people in the U.S. live in areas of high or severe water limitation',
            keyMessage: 'About 8% of the CONUS population, or 26.7 million people, live in areas where human water use routinely meets or exceeds renewable water supply.',
            references: ["Census2020", "Stets2025", "Vörösmarty2010", "Lin2012", "Park2018", "Erickson2025", "Kaushal2018", "Waite2019", "Waite2021", "Kennedy2016", "Eng2019", "Moreira2019", "EPA2020"],
            tabData: [
                {
                    tabTitle: "Water Quantity",
                    tabSubtitle: "Water availability is limited by water quantity",
                    tabTitleID: "sui",
                    tabTitleIDname: "sui",
                    tabText: "The overall balance between water supply and consumptive use is a primary consideration in water availability studies. Globally, the factors affecting human water security are highly correlated; the infrastructure that allows elevated water use also promotes water-quality degradation and decreases biotic integrity <span v-for='reference in theseReferences.filter(item => item.refID === 'Stets2025')' class='tooltip'> <sup class='in-text-number'>{{ reference.referenceNumber }} </sup> <span class='tooltiptext'> {{ reference.refID }}</span></span>(Vörösmarty et al., 2010). For example, intense water withdrawal, even if restored to the local system through return flow, can degrade water quality because the water may return with increased sediment, nutrients, or salinity (Lin and Garcia, 2012; Park et al., 2018)."
                },{
                    tabTitle: "Surface Water Quality",
                    tabSubtitle: "Water availability is limited by surface water quality",
                    tabTitleID: "sw",
                    tabTitleIDname: "sw_wq",
                    tabText: "Surface water quality can be degraded by nutrients, sediment, temperature, pathogens, salinity, and pesticides. Sources of water quality contaminants include agriculture, wastewater, air pollution, other human sources such as mining and land-use change, and natural sources such as springs and streamflow. Areas of the country that strongly indicate surface water quality issues include the High Plains, Souris-Red-Rainy, and the Midwest regions, largely due to the application of fertilizer and manure for agriculture (Erickson et al., 2025)."
                },{
                    tabTitle: "Groundwater Quality",
                    tabSubtitle: "Water availability is limited by groundwater quality",
                    tabTitleID: "gw",
                    tabTitleIDname: "gw_wq",
                    tabText: "Groundwater-derived drinking water can be affected by high concentrations of constituents from geologic sources, including arsenic, manganese, strontium, radionuclides, fluoride, and lithium, as well as salinity and nitrogen. Mixtures of multiple groundwater contaminants can also have compounding effects, because different users may have elevated sensitivity when exposed to multiple water-quality issues at once (Kaushal et al., 2018; Waite et al., 2019, 2021). Threats to human health, corrosion of infrastructure, reduced crop yields, poor taste, impeded navigation, and economic impacts can all result from poor water quality (Erickson et al., 2025)."
                },{
                    tabTitle: "Ecoflows",
                    tabSubtitle: "Water availability for ecosystems is limited by altered natural flows",
                    tabTitleID: "eco",
                    tabTitleIDname: "ecoflow",
                    tabText: "Humans alter the natural flow of water by building water management structures, such as reservoirs, impoundments, and diversions, and covering land with impervious surfaces. We create water-management structures to improve quality of life by creating hydroelectric power, controlling flood risk, capturing and distributing drinking water, and irrigating crops. These structures can affect the flow regime through water storage and releases, potentially altering the timing, seasonality, frequency, and rate of change of flows (Kennedy et al., 2016; Eng et al., 2019; Moreira et al., 2019), even if total flow volume remains equivalent. Anthropogenic land cover, such as urban areas and impervious surfaces, can also affect flow attributes by increasing the rate of runoff, resulting in greater high-flow magnitude and frequency, while decreasing flow durations (Eng et al., 2019)."
                },
            ]
        },
        {
            page: 3,
            route: '/03SVI',
            mainTitle: 'Unequal access to water',
            shortTitle: 'Socially vulnerable Americans have a higher risk of water limitation',
            keyMessage: 'Water limitation disproportionately affects socially vulnerable populations in the U.S., creating problems for equitable access to clean water.',
            references: [ "Drakes2024", "Stets2025", "Meehan2020", "Mueller2021", "Scanlon2023", "Deitz2019", "Flanagan2011"]
        },
        {
            page: 4,
            route: '/04Drought',
            mainTitle: 'Not enough rain and snow',
            shortTitle: 'Limited water supply can cause water imbalance',
            keyMessage: 'Periods of low precipitation can have cascading effects throughout the water cycle, expanding areas of water limitation and exacerbating water quality issues' ,
            references: [
                "Legates2011",
                "Gorski2025",
                "Stets2025",
                "Medalie2025",
                "Foks2025a",
                "Foks2025b",
                "Sampson2025"
            ]
        },
        {
            page: 5,
            route: '/05WQSource',
            mainTitle: 'Nutrients in the water',
            shortTitle: 'Natural and human sources of nutrients degrade water quality',
            keyMessage: 'Sources of nutrients in our water vary across the United States. Common sources of nutrients such as nitrogen and phosphorus include fertilizer and manure, atmospheric deposition, wastewater treatment plants, urban land, and a range of natural sources including stream channel and geologic sources.',
            references: ["Erickson2025", "Shoda2019", "Wurtsbaugh2019", "Ator2019", "Hoos2019", "Robertson2019", "Wise2019a", "Wise2019b", "Martinez2024"]
        },
        {
            page: 6,
            route: '/06WQThreats',
            mainTitle: 'Threats to water quality',
            shortTitle: 'Water quality issues can potentially affect human and aquatic health',
            keyMessage: 'Drinking water, fish consumption, and recreational water use face different water quality threats.',
            references: [
                "Erickson2025",
                "EPA2023",
                "Vareda2019",
                "Canedo2013",
                "Kaushal2018",
                "Stets2020",
                "Gillespie2018",
                "AMAP2009",
                "Lauber2017",
                "Wentz2014",
                "Ngoubeyou2022",
                "Cabral2010",
                "Verhougstraete2015",
                "EPA2020",
                "Belitz2022",
                "Morris1995"
            ]
        },
        {
            page: 7,
            route: '/07WaterUse',
            mainTitle: 'For farm, home, and energy',
            shortTitle: 'The largest demands for water are for crop irrigation, public supply, and thermoelectric power',
            keyMessage: 'About 224,000 million gallons of freshwater are used every day for irrigation (48%), public supply (16%), and thermoelectric power (36%).',
            references: ["Medalie2025", "Tesoriero2013", "VanMetre2020", "Konar2020", "Erickson2025", "Dieter2018", "Symonds2015", "Eppehimer2021", "Rice2017", "Raptis2016", "Chini2020", "Galanter2023", "Luukkonen2023", "Martin2023", "Haynes2024"],
            tabData: [
                {
                    tabTitle: "Crop Irrigation",
                    tabSubtitle: "Crop irrigation is the largest use of water in the U.S.",
                    tabTitleID: "irrigation",
                    tabTitleIDname: "irrigation",
                    tabText: "As the largest category of water use overall in the country, crop irrigation has the biggest effects on water availability. Irrigation directly reduces the amount of water locally available because a large proportion of water withdrawn is evapotranspired, and thus no longer available locally. Irrigation also increases runoff and can carry contaminants such as fertilizers and pesticides to waterbodies across large areas with long-lasting impacts (Tesoriero et al., 2013; Van Metre et al., 2016; Konar and Marston, 2020; Erickson et al., 2025)."
                },
                {
                    tabTitle: "Public Supply",
                    tabSubtitle: "Public water supply is essential for our communities",
                    tabTitleID: "public",
                    tabTitleIDname: "public_supply",
                    tabText: "Across CONUS, public suppliers provide drinking water to about 87% of the population, as well as to many commercial entities (hotels, restaurants, etc) and industries (Dieter et al, 2018). The total volume of withdrawals for public supply is low compared to crop irrigation or thermoelectric power. However, depending on the area, public-supply withdrawals and the return of most of that water to the natural water supply as wastewater are locally important to water availability and quality. Treatment of water at wastewater treatment facilities can mitigate some potentially harmful effects of introduced contaminants from users of public supply water. Nevertheless, local effects on water quantity and quality—including alteration of flows and flow timing, as well as introduction of disinfection byproducts and other constituents not removed from treated wastewater—can be substantial (Symonds et al., 2015; Eppehimer et al., 2021). In dry regions, discharge from wastewater treatment facilities can dominate base flow and contain contaminants like pharmaceutical products, which are hard and expensive to remove from wastewater and can reach high concentrations (Rice and Westerhoff, 2017). In areas with combined sewers, large storms can cause untreated sewage to overflow directly into downstream waters. "
                },
                {
                    tabTitle: "Thermoelectric Power",
                    tabSubtitle: "Thermoelectric water use uses, then returns, a large amount of water",
                    tabTitleID: "thermoelectric",
                    tabTitleIDname: "thermoelectric",
                    tabText: "Water-availability effects from thermoelectric power are typically lower than for crop irrigation or public supply because most of the water is returned close to the point of withdrawal. However, withdrawals from surface water for thermoelectric power generation are large in some areas, particularly the eastern U.S. Thermoelectric water use can also degrade water quality through temperature pollution; this impact can be substantial, particularly for ecosystem uses (Raptis et al., 2016; Chini et al., 2020)."
                }
            ]
        },
        {
            page: 8,
            route: '/08WaterUseRegional',
            mainTitle: 'From sea to shining sea',
            shortTitle: 'How we use water varies across the country',
            keyMessage: 'Regionally, crop irrigation is the primary water use in the western and High Plains areas of the U.S., while the eastern half of the country uses water primarily for public supply or thermoelectric power.',
            references: ["Medalie2025", "Galanter2023", "Luukkonen2023", "Martin2023", "Haynes2024"]
        },
        {
            page: 9,
            route: '/09Consumption',
            mainTitle: 'Gone but not forgotten',
            shortTitle: 'Not all the water withdrawn for human water use returns to the local environment',
            keyMessage: 'Water that does not return to local water bodies or groundwater is lost to the atmosphere, consumed by humans or livestock, or incorporated into products or crops. Across CONUS, the proportion of water use consumed in these ways is 72% for irrigation, 12% for public supply, and 4% for thermoelectric power.',
            references: ["Medalie2025", "Martin2023", "Haynes2023", "Harris2019", "Galanter2023", "Luukkonen2023"],
            tabData: [
                {
                    tabTitle: "Crop Irrigation",
                    tabSubtitle: "On average, about 72% of water withdrawn for irrigation is consumed rather than returned to the local environment.",
                    tabTitleID: "irrigation",
                    tabTitleIDname: "irrigation",
                    tabText: "On average, about 72% of water withdrawn for irrigation is consumed rather than returned to the local environment.  This proportion, influenced primarily by climate and the ability of the irrigation system to meet crop needs (efficiency), varies greatly across the country. In general, higher proportions of water are consumed for crop irrigation in the eastern U.S. than the western U.S. During drought, crop needs for irrigation are greater, and more water is lost as consumptive use to evapotranspiration, even though the footprint of irrigated crops typically shrinks (Martin et al., 2023; Haynes et al., 2024). Some areas without sufficient local resources use water for crop irrigation that is transported from other areas with abundant water resources, changing the natural water availability in both the sending and receiving areas. Transfers of water for crop irrigation are particularly common in the western U.S."
                },
                {
                    tabTitle: "Public Supply",
                    tabSubtitle: "Most water used for public supply is returned to the local environment",
                    tabTitleID: "public",
                    tabTitleIDname: "public_supply",
                    tabText: "Most water used for public supply is returned to the local environment through wastewater treatment plant outfalls  or through sewer systems. On a national basis, about 88% of the water withdrawn for public supply is returned to the local environment. Water that is not returned includes water consumed by humans and animals, water incorporated into products or crops, water evaporated from the landscape, and water transpired from plants.  Some areas without sufficient local resources use water for public supply that is transported from other areas with more abundant water resources, changing the natural water availability in both the sending and receiving areas. Movement of water for public supply is typically from rural to urban areas."
                },
                {
                    tabTitle: "Thermoelectric Power",
                    tabSubtitle: "Thermoelectric water use uses, then returns, a large amount of water",
                    tabTitleID: "thermoelectric",
                    tabTitleIDname: "thermoelectric",
                    tabText: "Overall thermoelectric-power water use is characterized by large withdrawals and relatively low consumptive use (Diehl and Harris, 2014; Harris and Diehl, 2019). However, volumes of water withdrawn and consumed for thermoelectric power at individual facilities vary tremendously and are entirely influenced by the type of cooling system used by the facility.  One broad type of cooling system is once-through, where a large volume of water is withdrawn and a relatively small amount is consumed through evaporation. The other broad type of system recirculates water for multiple cooling cycles, resulting in much smaller withdrawals than once-through systems.  On the other hand, recirculating cooling systems consume a larger percentage, up to 70%, of the water through evaporation  (Harris and Diehl, 2019). Between 2010 to 2020, many plants shifted from once-through cooling systems towards recirculating cooling systems."
                }
            ]
        },
        {
            page: 10,
            route: '/10Future',
            mainTitle: 'Future water availability',
            shortTitle: 'The water cycle is shifting due to climate change',
            keyMessage: 'The top impacts to water availability in the U.S. in the future vary regionally and include increases in drought, flooding, and heavy precipitation along with declines in snow and ice.',
            references: [
                "Crimmins2023",
                "IPCC2022",
                "Scholl2025"
            ],
            tabData: [
                {
                    tabTitle: "Temperature",
                    tabSubtitle: "Potential impacts from rising temperature",
                    tabTitleID: "temp",
                    tabTitleIDname: "impact-temp",
                    tabText: "Climate assessments indicate a high degree of confidence that changes in extreme heat, mean air temperature, and cold spells and frost will affect water resources in every region in the U.S., including Alaska, Hawaii, and the Caribbean islands. Extreme heat amplifies the effects of drought and increases evaporative loss from reservoirs. Increased stream temperatures harm fish health, especially in native, cold-water fisheries. Harmful algal blooms also increase with increasing water temperatures.  Higher air temperatures lead to warmer and shorter winters, which can in turn affect snowfall and snowmelt in the spring and early summer. ",
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
                    tabText: "Climate assessments indicate  that increases in drought and fire weather and aridity, will have the highest likelihood of impacting the Western region of the contiguous U.S.. Overall, the amount and timing of streamflow is expected to change, the demand for groundwater to increase, and stream baseflow  to decrease.",
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
                    tabText: "Climate assessments indicate a high degree of confidence that every region in the U.S. except Hawaii and the Caribbean islands will see changes in snow and ice. The extent of snow cover is shrinking and snow is melting sooner. Ice in lakes and rivers is declining, as are glaciers. Permafrost is thawing, and the transition line between rain and snow is moving north (meaning we see more rain where we used to see snow).",
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
                    tabText: "Climate assessments indicate a high degree of confidence that climate impacts on water resources in coastal areas will impact   all areas of  the U.S. that border an ocean. Along with sea level rise we expect to see larger storm surges, an increased frequency and severity of coastal flooding, and greater incursion of saltwater into freshwater aquifers, estuaries, wetlands, and soils from storm floodwaters.",
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