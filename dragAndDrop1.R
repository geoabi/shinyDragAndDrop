# Drag and drop a set of images using SortableJS
# 
# Images in container class_0 can be dropped in any other container because all containers
# have the same group ("shared")
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

  uiOutput("main_UI"),
  actionButton("test", "Test")
)

server <- function(input, output, session) {

  # location of images
  imagesDir <- "./images"
  # web directory
  imagesDirWeb <- "imgs"

  # make the directory web accesible
  addResourcePath(imagesDirWeb, imagesDir)
  
  # name of file with list of images
  imgList <- "images.csv"

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
        column(offset = 1, 10, 
          createGridDrag(id = "class_0",
            showImages(imgList)
          ),
          verbatimTextOutput("elements_0")
        )
      ),
      hr(),
      fluidRow(
        column(4, h3("Class A", style = "text-align: center;"),
          createGridDrag(id = "class_A"),
          verbatimTextOutput("elements_A")
        ),
        column(4, h3("Class B", style = "text-align: center;"),
          createGridDrag(id = "class_B"),
          verbatimTextOutput("elements_B")
        ),
        column(4, h3("Class C", style = "text-align: center;"),
          createGridDrag(id = "class_C"),
          verbatimTextOutput("elements_C")
        )
      )
    )
  })
  
  # display the elements in each container
  output$elements_0 <- renderPrint({ input$class_0 })
  output$elements_A <- renderPrint({ input$class_A })
  output$elements_B <- renderPrint({ input$class_B })
  output$elements_C <- renderPrint({ input$class_C })
  
  # display to console the elements of each container
  observeEvent(input$test, {
    cat("Class 0: ", input$class_0, "\n")
    cat("Class A: ", input$class_A, "\n")
    cat("Class B: ", input$class_B, "\n")
    cat("Class C: ", input$class_C, "\n")
    cat("=============\n")
  })
}

shinyApp(ui = ui, server = server)




