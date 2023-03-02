pacman::p_load(shiny,tidyverse,readxl,lubridate, data.table,here,DT, install = TRUE, update = getOption("pac_update"))

shinydat<-read_excel(here("participants.xlsx"))|>
  select(1:8)

ui<-fluidPage(
  titlePanel("VAC078 Participants Data"),
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset",label="Site",choices=c("Junju","Pingilikani","Chasimba"), selected = "Junju"),
      selectInput("group",label="Group",choices=c("Group A","Group B"), selected = "Group B"),
      selectInput("status",label="Current Status",choices=c("On Active Follow up","Consent withdrawal",
                                                   "Loss to follow up","Terminated due to dosing error",
                                                   "SAE resulting to death","Blood volume issues"), selected = "On Active Follow up"),
      selectInput("month",label="Dosing Month",choices=c("Jan","Feb","Mar","Apr","May","Jun",
                                                         "Jul","Aug","Sep","Oct","Nov",
                                                         "Dec"), selected = "Dec")
      #verbatimTextOutput("summary"),
    ),
    mainPanel(
      tableOutput("table")
    )
  )
)
server<-function(input, output,session){
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
