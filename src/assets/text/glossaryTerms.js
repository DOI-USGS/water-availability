export default {
    key: [
        {
            term: "Water supply",
            definition: "Water supply includes all of the ways in which water enters a watershed (Gorski et al., 2025) Water supply includes precipitation as rain, sleet, snow, etc., streamflow, and melting snow and ice. Water supply can also come from reservoirs of water such as soil moisture, lakes and streams, groundwater, and human-made reservoirs and dams."
        },   
        {
            term: "Water demand",
            definition: "Water demand represents the ways in which we use water from a given watershed, including for human-uses like thermoelectric power generation, crop irrigation, or public supply (Medalie et al., 2025). Other natural demands on water include plant uptake and loss, which is called transpiration, water evaporation off surfaces, streamflow out of watersheds, and consumptive use which includes uptake by living organisms including plants and animals."
        },
        {
            term: "Water limitation",
            definition: "Water limitation was calculated as an average surface water-supply and use index (SUI), which expresses the imbalance between surface water-supply and consumptive uses (Stets et al., 2025). The SUI metric was developed to express surface water-supply and use imbalances within 12-digit hydrologic unit code (HUC12) catchments arising from climatic variability and human consumptive uses. It compares long-term average surface-water supply with monthly water supply, which varies over time because of climatic conditions and human consumptive water use. A high index value indicates that a high proportion of the average supply is either consumed by human use or unavailable because of climatic variation, leading to high water stress."
        },
        {
            term: "Water year",
            definition: "A water year is defined as the 12-month period October 1, for any given year through September 30, of the following year. The water year is designated by the calendar year in which it ends and which includes 9 of the 12 months. Thus, the water year ending beginning October 1, 2023 and ending on September 30, 2024 was the 2024 water year."
        },
        {
            term: "Hydrologic Unit Classification (HUC)",
            definition: "The U.S. Geological Survey uses a depiction and classification scheme for hydrologic units known as hydrologic unit codes (HUCs). HUCs generally represent catchments, and river basins are represented by a unique series of numbers with successively smaller hydrologic units nested inside of larger ones. Digits are added as hydrologic units become smaller, such that a 2-digit HUC encompasses multiple 4-digit HUCs, and a 4-digit HUC encompasses multiple 6-digit HUCs, etc. This assessment uses 12-digit HUCs (HUC12s), which generally range from 50 to 100 square kilometers (km2) in size. The CONUS contains 18 2-digit HUCs and over 93,000 12-digit HUCs. The median HUC12 in the conterminous United States is 90 km2. Although in practice, HUCs represent river basins, they are formally administrative units, and not always natural watersheds. As such, HUCs can depict human-created drainages and diversions or arbitrary breaks in connected flow systems.",
            visual: "glossary_huc",
            visualLogic: true
        },
        {
            term: "Streamflow",
            definition: "Streamflow is the flow of water in a natural channel on the land surface. Streamflow can be conceptualized as having two primary components: baseflow and quickflow. Quickflow is the short-term flow of water off the landscape following precipitation or snowmelt events. Quickflow is also often referred to as runoff. Baseflow is subsurface water that enters the stream channel from groundwater. Baseflow can maintain streamflow between precipitation events, if the groundwater level remains high enough to feed the stream.",            
            visual: "glossary_streamflow",
            visualLogic: true
        },
        {
            term: "Watershed",
            definition: "A watershed is an area of land that drains all water into a common outlet, such as a bay, reservoir, or stream. Watersheds can be as small as a footprint or large enough to encompass all the land that drains water into rivers that drain into San Francisco Bay, where it enters the Pacific Ocean. The word watershed is sometimes used interchangeably with drainage basin or catchment. Watersheds consist of surface water--lakes, streams, reservoirs, and wetlands--and all the underlying groundwater."
        },
        {
            term: "Social vulnerability",
            definition: "'Social vulnerability refers to the demographic and socioeconomic factors (such as poverty, lack of access to transportation, and crowded housing) that adversely affect communities that encounter hazards and other community-level stressors. These stressors can include natural or human-caused disasters (such as tornadoes or chemical spills) or disease outbreaks (such as COVID-19).' The Centers for Disease Control (CDC) Social Vulnerability Index (SVI; Centers for Disease Control, 2022) includes indicators reflecting community characteristics and composition that may lead to differential effects from hazard exposures (Flanagan and others, 2011).",
        },
        { 
            term: "Geogenic contamination",
            definition: "Geogenic contaminants are elements found in groundwater that have come from geologic sources, such as soil and bedrock. Because water is such an excellent solvent, it can contain lots of dissolved chemicals. And since groundwater moves through rocks and subsurface soil, it has a lot of opportunity to dissolve substances as it moves. For that reason, groundwater will often have more dissolved geogenic substances than surface water will. Because groundwater moves slowly in the subsurface and many contaminants stick to the sediments, restoration of a contaminated aquifer is difficult and may require years, decades, centuries, or even millennia."
        },
        {
            term: "Eutrophication",
            definition: "Eutrophication occurs when a body of water receives an excessive nutrient load, particularly phosphorus or nitrogen. This often results in an overgrowth of algae. As the algae die and decompose, oxygen is depleted from the water, and this lack of oxygen in the water causes the death of aquatic animals, like fish."
        }
    ],
    references: [
        "CDC2022",
        "Flanagan2011",
        "Medalie2025",
        "Stets2025",
        "Gorski2025"
    ]
}
