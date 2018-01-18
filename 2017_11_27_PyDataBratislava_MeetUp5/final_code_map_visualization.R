# nacitat libky
library(readxl) # otvaranie excelu
library(leaflet) # praca s frameworkom leaflet
# library(dplyr)
library(rgdal) # na pracu s json


getwd()
setwd("C:/Users/Martin/Desktop/Pracovny_priecinok")

# library(htmltools) # na popupy a pod

SVK_districts <- rgdal::readOGR("districts_epsg_4326.geojson", "OGRGeoJSON")
okresy <- read_excel("poradie_okresov.xlsx")

bins <- c(550, 650, 750, 800, 850, 900, 950, 1000, Inf)
pal <- colorBin("YlOrRd", domain = okresy$Mzdy, bins = bins)

labels <- sprintf(
  "<strong>%s</strong><br/>Priemerná mzda 2015: %g",
  okresy$Okres,okresy$Priemerna_mzda_2015) %>% lapply(htmltools::HTML)



# vyplotit json slovenske okresy

leaflet() %>% 
  addTiles() %>%
  setView(lng = 19, lat = 47, zoom = 3) %>% 
  addPolygons(data = SVK_districts3)


# TOP TOPOV vizualne tato mapa, obsahuje vsetko, co ma

leaflet() %>% 
  addTiles() %>%
  setView(lng = 19.411622, lat = 48.696708, zoom = 7) %>% 
  addPolygons(data = SVK_districts, opacity = 0.25, weight = 1, color = "black",
              fillColor = ~pal(okresy$Mzdy), fillOpacity = 0.50,smoothFactor = 1, 
              stroke = 0.1, label = labels, 
              highlightOptions = highlightOptions(color = "black", weight = 5, bringToFront = TRUE)) %>%
  addProviderTiles('CartoDB.Positron') %>%
  addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
  addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
  addLayersControl( baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
                    options = layersControlOptions(collapsed = TRUE)) %>%
  addLegend(pal = pal, values = okresy$Mzdy, opacity = 0.7, title = "Priemerne mzdy na rok 2015",
            position = "bottomright")
