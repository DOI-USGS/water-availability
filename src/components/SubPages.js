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
            shortTitle: 'The water cycle is shifting due to climate change',
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
                    tabTitle: "Temperature Impacts",
                    tabTitleID: "temp",
                    tabText: "Researchers are highly confident that changes in temperature will affect water resources in every region in the U.S., including Alaska, Hawaii, and the Caribbean islands. Extreme heat amplifies the effects of drought and increases evaporative loss from reservoirs. High stream temperatures harm fish health, especially in native, cold-water fisheries. Higher temperatures also lead to warmer and shorter winters, meaning less snowfall and less time for the snow to permeate into the ground.",
                },                {
                    tabTitle: "Wind Impacts",
                    tabTitleID: "wind",
                    tabText: "The anticipated effects of wind on the water cycle vary from region to region. Researchers are highly confident that changes in wind will affect the Northwest and Southwest and moderately confident that they will affect the rest of the U.S., except Alaska. We expect to see an increase in severe windstorms, including sand and dust storms, as well as stronger hurricanes.",
                }
            ]
        }
    ]
};