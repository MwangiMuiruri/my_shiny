pacman::p_load(shiny,tidyverse,readxl,data.table, here, install = TRUE, update = getOption("pac_update"))
shinydat<-fread(here("participants.csv"))|> 
  select(1:8)
ui<-fluidPage(
  titlePanel("Participants Dashboard!"),
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
               information from the 2010 US Census."),
      selectInput("var", h3("Choose a variable to display"), 
                  choices = list("Percent white" , "Percent Black" ,
                                 "Percent Hispanic","Percent Asian" ), selected = 1),
      sliderInput("sliid",label="Range of interest",min = 0,max = 100,value = c(0,100))
    
  ),
  mainPanel(
    textOutput("selected_var"),
    textOutput("selected_sliid")
  ))
)

server<-function(input, output,session){
  output$selected_var <- renderText({ 
    paste("You have selected", input$var)
  })
  output$selected_sliid <- renderText({ 
    paste("You have chosen a range that goes from", input$sliid[1],"to",input$sliid[2])
  })
}

shinyApp(ui = ui, server = server)