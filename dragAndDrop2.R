# Drag and drop a set of images using SortableJS
# 
# Images can only be dropped in a container of the same group, e.g. Class_A1 and Class_A2 have 
# the group "groupA".
#
# May 12, 2019
# Geovany A. Ramirez

library(shiny)

ui <- fluidPage(
  title = "Shiny Drag and Drop",
  
  # add custom CSS and javascript code
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    tags$script(type = "text/javascript", src = "Sortable.js"),
    tags$script(type = "text/javascript", src = "drag_drop_binding.js")
  ),

  uiOutput("main_UI")
)

server <- function(input, output, session) {

  # location of images
  imagesDir <- "./images"
  # web directory
  imagesDirWeb <- "imgs"

  # make the directory web accesible
  addResourcePath(imagesDirWeb, imagesDir)
  
  # display a set of images
  showImages <- function(fileName) {
    # read list of images
    allImgs <- read.csv(fileName)
    lapply(1:nrow(allImgs), function(i) {
      srcName <- paste0(imagesDirWeb, '/', allImgs$images[i])
      img(src = srcName, data = allImgs$images[i], class = "grid-square")
    })
  }
  
  # create a container of draggable elements in a grid 
  createGridDrag <- function(id, ..., group = "shared") {
    # to call the renderValue function in drag_drop_binding.js and
    # send the group name
    output[[id]] <- function(){ group }
    
    div(id = id, class = "grid_drag_drop group_border", ... )
  }

  output$main_UI <- renderUI({
    div(
      fluidRow(
        column(4, h3("Class A1", style = "text-align: center;"),
          createGridDrag(id = "class_A1", group = "groupA",
            showImages("imagesA.csv")
          ),
          verbatimTextOutput("elements_A1")
        ),
        column(4, h3("Class B1", style = "text-align: center;"),
          createGridDrag(id = "class_B1", group = "groupB",
            showImages("imagesB.csv")),
          verbatimTextOutput("elements_B1")
        ),
        column(4, h3("Class C1", style = "text-align: center;"),
          createGridDrag(id = "class_C1", group = "groupC",
            showImages("imagesC.csv")),
          verbatimTextOutput("elements_C1")
        )
      ),
      hr(),
      fluidRow(
        column(4, h3("Class A2", style = "text-align: center;"),
          createGridDrag(id = "class_A2", group = "groupA"),
          verbatimTextOutput("elements_A2")
        ),
        column(4, h3("Class B2", style = "text-align: center;"),
          createGridDrag(id = "class_B2", group = "groupB"),
          verbatimTextOutput("elements_B2")
        ),
        column(4, h3("Class C2", style = "text-align: center;"),
          createGridDrag(id = "class_C2", group = "groupC"),
          verbatimTextOutput("elements_C2")
        )
      )
    )
  })
  
  # display the elements in each container
  output$elements_A1 <- renderPrint({ input$class_A1 })
  output$elements_B1 <- renderPrint({ input$class_B1 })
  output$elements_C1 <- renderPrint({ input$class_C1 })
  output$elements_A2 <- renderPrint({ input$class_A2 })
  output$elements_B2 <- renderPrint({ input$class_B2 })
  output$elements_C2 <- renderPrint({ input$class_C2 })
}

shinyApp(ui = ui, server = server)




