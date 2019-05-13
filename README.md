# shinyDragAndDrop

Basic Shiny Apps to illusrate the use of [SortableJS](https://github.com/SortableJS/Sortable) library to drag and drop elements.

The main idea is to create a [custom output object](https://shiny.rstudio.com/articles/building-outputs.html) to interconnect a `div` element with the SortableJS library. The output binding is implemented in the JavaScript file [drag_drop_binding.js](https://github.com/geoabi/shinyDragAndDrop/blob/master/www/drag_drop_binding.js). Inside the JavaScript code, a new `Sortable` object is created with a set of options. In the options, it is defined a function for the event `onEnd` that will update a Shiny output variable with a list of all the images in the source and destination container.

## How to use
To use this output object you need to add to your code the SortableJS library, the binding code, and the custom styles. Just add to your `ui` component the following lines:

```R
tags$head(
  tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
  tags$script(type = "text/javascript", src = "Sortable.js"),
  tags$script(type = "text/javascript", src = "drag_drop_binding.js")
)
```

Then add the following function to your code and make it accessible to your `server` component. You can just put inside the server function, but you can put it in any other location, as long it is accessible inside the server function.

```R
# create a container of draggable elements in a grid 
  createGridDrag <- function(id, ..., group = "shared") {
    # to call the renderValue function in drag_drop_binding.js and
    # send the group name
    output[[id]] <- function(){ group }
    
    div(id = id, class = "grid_drag_drop group_border", ... )
  }
```

The `grid_drag_drop` class is used by the binding function to identify elements that should be associated with the output object. The `group_border` class is used to add a border around the `div`.

Finally, just call the function `createGridDrag` to create a container where all the components can be dragged. In this case, images.

## Examples

In [dragAndDrop1.R](https://github.com/geoabi/shinyDragAndDrop/blob/master/dragAndDrop1.R) is an example where a container will start with a set of images that can be dropped to any other container.

<p align="center">
  <img src="https://github.com/geoabi/shinyDragAndDrop/blob/master/example1.jpg" width="60%">
</p>

In [dragAndDrop2.R](https://github.com/geoabi/shinyDragAndDrop/blob/master/dragAndDrop2.R) is an example where the elements of a container can only be dropped in another conteiner of the same group. This behavior is  possible by using a different group name.

<p align="center">
  <img src="https://github.com/geoabi/shinyDragAndDrop/blob/master/example2.jpg" width="60%">
</p>

## Problems and Contributions
If you have problems running the examples or you have suggestions, please open an issue [here](https://github.com/geoabi/shinyDragAndDrop/issues) at  GitHub. Also if you are interested in collaborate, please make a pull request.
