# Drag and drop a set of images using SortableJS
# 
# Images in container class_0 can be dropped in any other container because all containers
# have the same group ("shared").
#
# New class containers can be created.
#
# December 1, 2019
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
  hr(),
  uiOutput("AllElements_UI")
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

  # list of classes to start, for none use classList <- NULL
  classList <- c("Class A")
  
  # error message
  errText <- reactiveVal("")

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

  # main UI
  output$main_UI <- renderUI({
    nClass <- length(classList)
    div(
      fluidRow(
        column(2,
          textInput("className_Tx", "Class Name"),
          actionButton("addClass_Bt", "Add Class"),
          hr(),
          verbatimTextOutput("Error_Tx")
        ),
        column(10, 
          createGridDrag(id = "class_0",
            showImages(imgList)
          ),
          verbatimTextOutput("elements_0")
        )
      ),
      hr(),
      fluidRow(div(id = "allClasses_Dv",
        # create as many containers as classes in "classList"
        # class id will be "class_" + k, e.g. "class_1", "class_2"
        if (!is.null(classList)) {
          lapply(1:length(classList), function(k) {
            column(4, h3(classList[k], style = "text-align: center;"),
              createGridDrag(id = paste0("class_", k))
            )
          })
        }
      ))
    )
  })
  
  # display the elements in original container
  output$elements_0 <- renderPrint({ input$class_0 })
  
  # add a new class button
  observeEvent(input$addClass_Bt, {
    
    className <- input$className_Tx
    
    if (nchar(className) == 0) {
      errText("Please type a name")
    } else if (className %in% classList) {
      errText("Class name already exists")
    } else {
      # class id will be "class_" + k
      k <- length(classList) + 1
      insertUI(
        selector = '#allClasses_Dv',
        ui = div(id = paste0(className, "_dv"),
          column(4, h3(className, style = "text-align: center;"),
            createGridDrag(id =  paste0("class_", k))
          )
        )
      )
      # add class name to list
      classList[k] <<- className
      errText("New class addded")
    }
  })
 
  # display all elements of each container
  output$AllElements_UI <- renderUI({
    input$addClass_Bt
    if (!is.null(classList)) {
      lapply(1:length(classList), function(k) {
        tags$pre(
          paste0(classList[k], ":\n", paste0(input[[paste0("class_", k)]], collapse = ", "))
        )
      })
    }
  })
 
  # show error adding/deleting class
  output$Error_Tx <- renderPrint({ errText() })
  
}

shinyApp(ui = ui, server = server)



