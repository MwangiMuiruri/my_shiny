pacman::p_load(shiny,tidyverse,readxl,lubridate, data.table,here,DT, shinyWidgets, install = TRUE, update = getOption("pac_update"))

shinydat<-fread(here("participants.csv"))|>
  select(1:8)

ui<-fluidPage(
  titlePanel("VAC078 Participants Data"),
  sidebarLayout(
    sidebarPanel(
      #checkboxInput("checkbox", "Filter on Site", value = TRUE),
     # selectInput("dataset",label="Site",choices=c("Junju","Pingilikani","Chasimba"), selected = NULL),
      pickerInput("dataset", label="Site",choices=c("Junju","Pingilikani","Chasimba"), options = list(`actions-box` = TRUE),multiple = F),
      #checkboxInput("checkbox1", "Filter on Group", value = TRUE),
      pickerInput("group",label="Group",choices=c("Group A","Group B"), options = list(`actions-box` = TRUE),multiple = F),
      #checkboxInput("checkbox2", "Filter on Site Current Status", value = TRUE),
      selectInput("status",label="Current Status",choices=c("On Active Follow up","Consent withdrawal",
                                                   "Loss to follow up","Terminated due to dosing error",
                                                   "SAE resulting to death","Blood volume Issues"), selected = "On Active Follow up"),
      #checkboxInput("checkbox3", "Filter on dosing month", value = TRUE),
      pickerInput("month",label="Dosing Month",choices=c("Jan","Feb","Mar","Apr","May","Jun",
                                                         "Jul","Aug","Sep","Oct","Nov",
                                                         "Dec"), options = list(`actions-box` = TRUE),multiple = F)
      #verbatimTextOutput("summary"),
    ),
    mainPanel(
      verbatimTextOutput("texte",placeholder = FALSE),
      tableOutput("table")
    )
  )
)
server<-function(input, output,session){
  output$texte<-renderPrint({
    datasert<-nrow(shinydat|>
      mutate(monthe=lubridate::month(dateVac1Received, label=TRUE))|>
      filter(Site==input$dataset & group==input$group & currentStatus==input$status & monthe==input$month)|>
      mutate(screenId=as.character(screenId),
             consentDate=format(consentDate, "%Y-%m-%d"),
             enrollmentDate=format(enrollmentDate, "%Y-%m-%d"),
             randomized=factor(randomized,levels=c("TRUE","FALSE"),labels=c("Yes","No")),
             dateVac1Received=format(dateVac1Received, "%Y-%m-%d")))
    datasert
  })
  output$table<-renderTable({
    dataset<-shinydat|>
      mutate(monthe=lubridate::month(dateVac1Received, label=TRUE))|>
      filter(Site==input$dataset & group==input$group & currentStatus==input$status & monthe==input$month)|>
      mutate(screenId=as.character(screenId),
             consentDate=format(consentDate, "%Y-%m-%d"),
             enrollmentDate=format(enrollmentDate, "%Y-%m-%d"),
             randomized=factor(randomized,levels=c("TRUE","FALSE"),labels=c("Yes","No")),
             dateVac1Received=format(dateVac1Received, "%Y-%m-%d"))
    dataset
  })
}

shinyApp(ui = ui, server = server)
