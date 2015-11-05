library(shiny)
library(shinyjs)
library(rgeos)
library(maptools)
library(ggplot2)
library(dplyr)
library(stringr)
#ind <- readShapeSpatial("./IND_adm/IND_adm1.shp")
#ind <- fortify(ind, region = "NAME_1")
source("./literacy.R", local=TRUE)

# Read the data
#a <- read.csv("education.csv")
#save(a,file="education.RData")
load(file="education.RData")

# Clean the Area Name
colnames(a) <- gsub("Educational.level...","",colnames(a))
a$Area.Name <-gsub("State - ","",a$Area.Name)
a$Area.Name <- gsub("\\d+","",a$Area.Name)
# Remove trailing spaces
a$Area.Name <- gsub("[[:space:]]*$","",a$Area.Name)

states <- unique(a$Area.Name)

#ind <- readShapeSpatial("./India_SHP/INDIA.shp")
#plot(ind)

#ind <- fortify(ind, region = "ST_NAME")
#save(ind,file="./INDIA_SHP/ind.RData")
load(file="./INDIA_SHP/ind.RData")
# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
    
    # Expression that generates a histogram. The expression is
    # wrapped in a call to renderPlot to indicate that:
    #
    #  1) It is "reactive" and therefore should re-execute automatically
    #     when inputs change
    #  2) Its output type is a plot
    #updateSelectizeInput(session, 'id', choices = states, server = TRUE)
    #updateSelectizeInput(session, 'state', choices = states, server = TRUE)
    updateSelectizeInput(session, 'state', choices = states, server = TRUE,selected="INDIA")
    toggle("inputBox")
    toggle("state")
    output$distPlot <- renderPlot({  
        
        #print(input$radio)
        #print(input$id)
             
             educationalLevels(a,input$type,input$region, input$state,input$status)
        
    
    })
    updateSelectizeInput(session, 'state1', choices = states, server = TRUE,selected="INDIA")
    toggle("inputBox1")
    toggle("state1")
    output$statePlot <- renderPlot({  
        
        print(input$radio1)
        print(input$state1)
        if(input$state1==""){
            state <-"INDIA"
        }
        if(input$type1 == "All") {
            allPercent(a,input$region1,input$state1, input$literacy1)
        } else {
                    bar(a,input$type1,input$region1, input$state1,input$literacy1)
        }
    })
    u <- c(-1,-2,-5,-8,-12,-14,-15,-16,-17,-18,-26,-27,-31,-32,-35,-36)
    updatedStates <- states[u]
    updateSelectizeInput(session, 'state2', choices = updatedStates, server = TRUE,selected="KARNATAKA")
    toggle("inputBox2")
    toggle("state2")
    output$districtPlot <- renderPlot({  
        if(input$state2==""){
            state2 <-"PUNJAB"
        }
        #print(input$radio)
        #print(input$id)
        districtEdu(input$state2,input$type3,input$literacy3)
    })
    output$indiaLiteracy <- renderPlot({  
        if(input$state2==""){
            state2 <-"PUNJAB"
        }
        #print(input$radio)
        #print(input$id)
        literacyIndia(input$region2,input$type2,input$literacyLevel)
    })
    
})
