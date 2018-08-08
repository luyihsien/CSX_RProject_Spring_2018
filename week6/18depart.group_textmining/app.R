#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

library(wordcloud)
library(wordcloud2)
library(memoise)

cog1 <- read.csv(file = "cog1.csv", header = TRUE, sep=",")
cog2 <- read.csv(file = "cog2.csv", header = TRUE, sep=",")
cog3 <- read.csv(file = "cog3.csv", header = TRUE, sep=",")
cog4 <- read.csv(file = "cog4.csv", header = TRUE, sep=",")
cog5 <- read.csv(file = "cog5.csv", header = TRUE, sep=",")
cog6 <- read.csv(file = "cog6.csv", header = TRUE, sep=",")
cog7 <- read.csv(file = "cog7.csv", header = TRUE, sep=",")
cog8 <- read.csv(file = "cog8.csv", header = TRUE, sep=",")
cog9 <- read.csv(file = "cog9.csv", header = TRUE, sep=",")
cog10 <- read.csv(file = "cog10.csv", header = TRUE, sep=",")
cog11 <- read.csv(file = "cog11.csv", header = TRUE, sep=",")
cog12 <- read.csv(file = "cog12.csv", header = TRUE, sep=",")
cog13 <- read.csv(file = "cog13.csv", header = TRUE, sep=",")
cog14 <- read.csv(file = "cog14.csv", header = TRUE, sep=",")
cog15 <- read.csv(file = "cog15.csv", header = TRUE, sep=",")
cog16 <- read.csv(file = "cog16.csv", header = TRUE, sep=",")
cog17 <- read.csv(file = "cog17.csv", header = TRUE, sep=",")
cog18 <- read.csv(file = "cog18.csv", header = TRUE, sep=",")


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("106 College's professor profession by CEEC 18 school group"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("freqFrame", "Choice CEEC 18 school group:",
                  choices = c(
      "1.Information",
      "2.Engineering",
      "3.Mathematical, Physics and Chemistry",
      "4.Medicine and Health",
      "5.Life Sciences",
      "6.Bioresources",
      "7.Earth and Environment",
      "8.Architecture and Design",
      "9.Art",
      "10.Social and Psychology",
      "11.Mass Communication",
      "12.Foreign Languages",
      "13.Literature, History and Philosophy",
      "14.Education",
      "15.Law and Politics",
      "16.Management",
      "17.Finance and Economics",
      "18.Recreation and Sports")),      
    
      actionButton("update", "Update View"),
      hr(),
      sliderInput("freq",
                  "Minimum Frequency:",
                  min = 1,  max = 100, value = 20),
      sliderInput("max",
                  "Maximum Number of Words:",
                  min = 1,  max = 1000,  value = 200)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)




# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  datasetInput <- eventReactive(input$update, {
    switch(input$freqFrame,
           "1.Information" = cog1,
           "2.Engineering" = cog2,
           "3.Mathematical, Physics and Chemistry" = cog3,
           "4.Medicine and Health" = cog4,
           "5.Life Sciences" = cog5,
           "6.Bioresources" = cog6,
           "7.Earth and Environment" = cog7,
           "8.Architecture and Design" = cog8,
           "9.Art" = cog9,
           "10.Social and Psychology" = cog10,
           "11.Mass Communication" = cog11,
           "12.Foreign Languages" = cog12,
           "13.Literature, History and Philosophy" = cog13,
           "14.Education" = cog14,
           "15.Law and Politics" = cog15,
           "16.Management" = cog16,
           "17.Finance and Economics" = cog17,
           "18.Recreation and Sports" = cog18)
  }, ignoreNULL = FALSE)
  
  wordcloud_rep <- repeatable(wordcloud)

  output$distPlot <- renderPlot({
    freqFrame <- datasetInput() 
    
    # generate bins based on input$bins from ui.R
    wordcloud_rep(freqFrame$Var1,freqFrame$Freq, scale=c(5,0.1),
                  min.freq = input$freq, max.words=input$max,
                  random.order = FALSE,colors=palette())
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

