library(shiny)
library(ggplot2)
library(markdown)
library(shinyWidgets)

dta <- read.csv("college4.csv",
                header = TRUE)

options(device.ask.default = FALSE)
  
choice.type <-
  c('types', 
    'Set', 
    'groupname', 
    'groupname_number', 
    'Country', 
    'System',
    'Holland_1_code'
  )

choice.value <-
  c(
    'Teacherstudentratio',
    'Numofstudents',
    'Numofteachers',
    'Decliningrate',
    'Delayrate',
    'Hitrate',
    'TotalSuspensionrate',
    'Dropoutrate',
    'salaryafter3yr_00schyr_bachelor',
    'emplorateafter3yr_00schyr_bachelor',
    'salary_mas_vs_bach',	
    'emplorate_mas_vs_bach'
    
  )

choice.type2 <-
  c('types', 
    'Set', 
    'groupname', 
    'groupname_number', 
    'Country', 
    'System',
    'Holland_1_code'
  )

choice.value2 <-
  c(
    'salaryafter3yr_99schyr_master',	
    'salaryafter3yr_99schyr_inservicemaster',	
    'salaryafter3yr_99schyr_bachelor',	
    'salaryafter3yr_99schyr_academicyear',	
    'salaryafter3yr_99schyr_dayspecialist',	
    'salaryafter3yr_99schyr_trainingspecialist',	
    'salaryafter4yr_99schyr_master',	
    'salaryafter4yr_99schyr_inservicemaster',	
    'salaryafter4yr_99schyr_bachelor',	
    'salaryafter4yr_99schyr_academicyear',	
    'salaryafter4yr_99schyr_dayspecialist',	
    'salaryafter4yr_99schyr_trainingspecialist',	
    'salaryafter3yr_00schyr_master',	
    'salaryafter3yr_00schyr_inservicemaster',	
    'salaryafter3yr_00schyr_bachelor',
    'salaryafter3yr_00schyr_academicyear',	
    'salaryafter3yr_00schyr_dayspecialist',	
    'salaryafter3yr_00schyr_trainingspecialist',	
    'emplorateafter3yr_99schyr_master',	
    'emplorateafter3yr_99schyr_inservicemaster',	
    'emplorateafter3yr_99schyr_bachelor',	
    'emplorateafter3yr_99schyr_academicyear',	
    'emplorateafter3yr_99schyr_dayspecialist',	
    'emplorateafter3yr_99schyr_trainingspecialist',	
    'emplorateafter4yr_99schyr_master',	
    'emplorateafter4yr_99schyr_inservicemaster',	
    'emplorateafter4yr_99schyr_bachelor',
    'emplorateafter4yr_99schyr_academicyear',	
    'emplorateafter4yr_99schyr_dayspecialist',	
    'emplorateafter4yr_99schyr_trainingspecialist',	
    'emplorateafter3yr_00schyr_master',	
    'emplorateafter3yr_00schyr_inservicemaster',	
    'emplorateafter3yr_00schyr_bachelor',	
    'emplorateafter3yr_00schyr_academicyear',	
    'emplorateafter3yr_00schyr_dayspecialist',	
    'emplorateafter3yr_00schyr_trainingspecialist',	
    'emplorateGrowthratebysch',	
    'salarychangesbysch',
    'emplorateGrowthratebysyr',	
    'salarychangesbyyr',
    'salary_mas_vs_bach',	
    'emplorate_mas_vs_bach'

  )

choice.type3 <-
  c('types', 
    'Set', 
    'groupname', 
    'groupname_number', 
    'Country', 
    'System',
    'Holland_1_code'
  )

choice.value3 <-
  c(
    'Decliningrate',
    'Delayrate',
    'StudySuspensionrate',
    'TotalSuspensionrate',
    'Suspension_academic_interest',
    'Dropoutrate',
    'Dropoutrate_interest',
    'dropoutrateduetointerest'
  )


ui <-navbarPage("college choice",
  tabPanel(
    "about me",
    tags$h1("Its a English format, because we cann't use the Chinese words on Shiny, sorry >///<"),
    tags$p("if you want to see our analytics results, see our read me or github resources"),
    includeMarkdown("README.md")
  ),
  tabPanel(
    "ourdata",
    mainPanel(  
      tabPanel("ourdata",
               DT::dataTableOutput("raw.data")
      ))),
  
  tabPanel(
    "Simple comparison",
    tags$h1("count what you want!"),
    br(),
    sidebarLayout(
      sidebarPanel(
        selectInput('SV.input', 'type', c(choice.type, choice.value), selectize = TRUE)
      ),
      mainPanel(plotOutput("SV.plot"))
    ),
    
    tags$h1("Summary"),
    verbatimTextOutput("summary")
    
  ),
  
  tabPanel(
    "Cross comparison",
    tags$h1("Box Plot"),
    sidebarLayout(
      sidebarPanel(
        selectInput('PA.type', 'type', choice.type, selectize = TRUE),
        selectInput('PA.value', 'Value', choice.value, selectize =
                      TRUE)
      ),
      mainPanel(plotOutput("PA.plot"))
    )),
  navbarMenu("More",
             tabPanel("Basic DataTable",
                      fluidRow(
                        column(3,
                               selectInput("types",
                                           "School types:",
                                           c("All",
                                             unique(as.character(dta$types))))
                        ),
                        column(3,
                               selectInput("Set",
                                           "School Set:",
                                           c("All",
                                             unique(as.character(dta$Set))))
                        ),
                        column(3,
                               selectInput("groupname",
                                           "group name:",
                                           c("All",
                                             unique(as.character(dta$groupname))))
                        ),
                        column(3,
                               selectInput("subgroupname_number",
                                           "subgroup name:",
                                           c("All",
                                             unique(as.character(dta$subgroupname_number))))
                                ),
                        column(3,
                               selectInput("Holland_1_code",
                                           "Your interest:",
                                           c("All",
                                             unique(as.character(dta$Holland_1_code))))
                       )
                       ),
                      column(3,
                             selectInput("Country",
                                         "Country you want to go:",
                                         c("All",
                                           unique(as.character(dta$Country))))
                      )
             ),
                      fluidRow( 
                        DT::dataTableOutput("table")
             ),        
             tabPanel("Tablecheckbox",
                      tags$h1("Which information do you wnat see? choose it!"),
                      sidebarLayout(
                        sidebarPanel(
                            'input.dataset === "dta"',
                            checkboxGroupInput("show_vars", "Columns:",
                                               names(dta), selected = names(dta))
                        ),
                        mainPanel(
                              DT::dataTableOutput("mytable1"))
                          )
                        ),
             tabPanel(
               "Career Comparison",
               tags$h1("Do you wnat to konw the salary and employee rate after graduation?"),
               sidebarLayout(
                 sidebarPanel(
                   selectInput('PA.type2', 'type2', choice.type2, selectize = TRUE),
                   selectInput('PA.value2', 'Value2', choice.value2, selectize =
                                 TRUE)
                 ),
                 mainPanel(plotOutput("PA.plot2"))
               )
          
             ),
             tabPanel(
               "Acdamic Comparison",
               tags$h1("Do you wnat to konw the acdamic performance in different situation?"),
               sidebarLayout(
                 sidebarPanel(
                   selectInput('PA.type3', 'type3', choice.type3, selectize = TRUE),
                   selectInput('PA.value3', 'Value3', choice.value3, selectize =
                                 TRUE)
                 ),
                 mainPanel(plotOutput("PA.plot3"))
               )
               
             )
  )
)           


server <- function(input, output) {
  
  output$SV.plot <- renderPlot({
    if( is.element(input$SV.input, choice.type) ){
      ggplot(data = dta, aes_string(x = input$SV.input)) +
        geom_bar() +
        labs(y = "mean", x = input$SV.input)
    }
    else{
      ggplot(data = dta, aes_string(x = input$SV.input)) +
        geom_histogram() +
        labs(y = "mean", x = input$SV.input)
    }
  })
  

  
  output$PA.plot <- renderPlot({
    ggplot(data = dta, aes_string(x = input$PA.type, y = input$PA.value)) +
      geom_boxplot(
        col = "#75AADB", pch = 19)+ coord_flip() +
      labs(y = input$PA.value, x = input$PA.type)
  })

  output$SV.plot2 <- renderPlot({
    if( is.element(input$SV.input, choice.type2) ){
      ggplot(data = dta, aes_string(x = input$SV.input)) +
        geom_bar() +
        labs(y = "count", x = input$SV.input)
    }
    else{
      ggplot(data = dta, aes_string(x = input$SV.input)) +
        geom_histogram() +
        labs(y = "count", x = input$SV.input)
    }
  })
  
  output$PA.plot2 <- renderPlot({
    ggplot(data = dta, aes_string(x = input$PA.type2, y = input$PA.value2)) +
      geom_boxplot() + coord_flip() +
      labs(y = input$PA.value2, x = input$PA.type2)
  })
  
  output$SV.plot3 <- renderPlot({
    if( is.element(input$SV.input, choice.type3) ){
      ggplot(data = dta, aes_string(x = input$SV.input)) +
        geom_bar(size=3, colour="#CC0000")+
        labs(y = "count", x = input$SV.input)
    }
    else{
      ggplot(data = dta, aes_string(x = input$SV.input)) +
        geom_histogram() +
        labs(y = "count", x = input$SV.input)
    }
  })
  
  output$PA.plot3 <- renderPlot({
    ggplot(data = dta, aes_string(x = input$PA.type3, y = input$PA.value3)) +
      geom_boxplot(
        col = "#75AADB", pch = 19) + coord_flip() +
      labs(y = input$PA.value3, x = input$PA.type3)
  })
    
  output$summary <- renderPrint({
    summary(dta)
  })
  
  
  output$data.summary <- DT::renderDataTable({
    DT::datatable(summary(dta))
  })

  dta2 = dta[sample(nrow(dta), 1000), ]
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(dta2[, input$show_vars, drop = FALSE])
  })
  
  output$raw.data <- DT::renderDataTable({
    DT::datatable(dta)
  })
  
  output$table <- DT::renderDataTable(DT::datatable({
    data <- dta
      if (input$types != "All") {
        data <- data[data$types == input$types,]
      }
      if (input$Set != "All") {
        data <- data[data$Set == input$Set,]
      }
      if (input$Holland_1_code != "All") {
       data <- data[data$Holland_1_code == input$Holland_1_code,]
       if (input$groupname != "All") {
         data <- data[data$groupname == input$groupname,]
       }
       if (input$subgroupname_number != "All") {
         data <- data[data$subgroupname_number == input$subgroupname_number,]
       }
       if (input$Country != "All") {
         data <- data[data$Country == input$Country,]
       }
       
      data
    }}))


}

shinyApp(ui = ui, server = server)