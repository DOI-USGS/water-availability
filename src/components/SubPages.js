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
                    tabTitle: "Temperature Impacts",
                    tabTitleID: "temp",
                    tabTitleIDname: "impact-temp",
                    tabText: "Researchers are highly confident that changes in temperature will affect water resources in every region in the U.S., including Alaska, Hawaii, and the Caribbean islands. Extreme heat amplifies the effects of drought and increases evaporative loss from reservoirs. High stream temperatures harm fish health, especially in native, cold-water fisheries. Higher temperatures also lead to warmer and shorter winters, meaning less snowfall and less time for the snow to permeate into the ground.",
                },                {
                    tabTitle: "Wind Impacts",
                    tabTitleID: "wind",
                    tabTitleIDname: "impact-wind",
                    tabText: "The anticipated effects of wind on the water cycle vary from region to region. Researchers are highly confident that changes in wind will affect the Northwest and Southwest and moderately confident that they will affect the rest of the U.S., except Alaska. We expect to see an increase in severe windstorms, including sand and dust storms, as well as stronger hurricanes.",
                }
            ]
        }
    ]
};