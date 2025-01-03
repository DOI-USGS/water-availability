#' @title Create an svg with identifier that matches name of png
#' @param in_sf The spatial feature that is used to build the svg
#' @param identifier Name of the column used for IDing svg components (e.g., "AggReg_nam_nospace")
#' @param width The size of the svg's width
#' @param height The size of the svg's height
#' @param file_out Location to save the svg 
create_svg_for_web <- function(in_sf, 
                               identifier,
                               width, 
                               height, 
                               file_out,
                               color_scheme){
  
  in_sf <- in_sf %>%
    sf::st_cast("MULTIPOLYGON") %>%
    sf::st_cast("POLYGON") |>
    mutate(identifier = !! sym(identifier))
  
  p <- ggplot(in_sf) + geom_sf(fill = color_scheme$svg_fill_default, 
                               color = color_scheme$svg_col_default,
                               linewidth = 0.2) + theme_void()
  
  # gridSVG approach modified from 
  # https://gist.github.com/jimjam-slam/1d988451ae15882c889f49cf20b99a64
  grob <- p %>% ggplotGrob() %>% grid::grid.force()
  dev.new(width = width, height = height, units = 'in', res = 300)
  grid::grid.draw(grob)
  
  # Pull the identifier for the second set of paths added to the plot, which
  # is the regional paths (2nd geom_sf added above)
  grid_list <- grid::grid.ls()
  region_group <- grid_list$name[grep('GRID.pathgrob', grid_list$name)][1]
  
  # grid.garnish needs a handle - determine by running grid.ls() and checking
  # names under panel
  # CRITICAL that row order of referenced dataframe MATCHES plotting order
  gridSVG::grid.garnish(region_group,
                        'class' = rep(identifier, nrow(in_sf)),
                        'id' = gsub(' ', '_', in_sf$identifier),
                        group = FALSE, grep = TRUE, redraw = TRUE, global = FALSE)
  
  gridSVG::grid.export(file_out, strict = FALSE)
  dev.off(which=dev.cur())
  
  return(file_out)
  
}