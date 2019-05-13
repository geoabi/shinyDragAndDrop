// drag_drop_binding.js
//
// May 12, 2019
// Geovany A. Ramirez

(function() {

var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  return $(scope).find(".grid_drag_drop");
};

binding.renderValue = function(el, data) {
  // get the container
  var container = document.getElementById(el.id);
  // get the group name
  var group = data === "" ? "shared" : data;
  
  // store a list with all element inside the container
  $("#"+ el.id).data("allElements", []);
  for (var i = 0; i < container.children.length; i++) {
    $("#"+ el.id).data("allElements").push(container.children[i].getAttribute("data"));
  }  
  // report to shiny the elements in container
  Shiny.onInputChange(el.id, $("#"+ el.id).data("allElements"));
  
  // define options for container
  var options = {
    group: group,
    animation: 150,
    ghostClass: "blue-background-class",
    
    // define function to execute when a new element is added to a container
    onEnd: function (evt) {
      // remove all elements already in array
      $("#"+ evt.from.id).data("allElements", []);
      // add new elements
      for (var i = 0; i < evt.from.children.length; i++) {
        $("#"+ evt.from.id).data("allElements").push(evt.from.children[i].getAttribute("data"));
      }
      // report changes to shiny
      Shiny.onInputChange(evt.from.id, $("#" + evt.from.id).data("allElements"));
      
      if (evt.to.id != evt.from.id) {
        // remove all elements already in array
        $("#"+ evt.to.id).data("allElements", []);
        // add new elements
        for (var i = 0; i < evt.to.children.length; i++) {
          $("#"+ evt.to.id).data("allElements").push(evt.to.children[i].getAttribute("data"));
        }
        // report changes to shiny
        Shiny.onInputChange(evt.to.id, $("#" + evt.to.id).data("allElements"));
      }
    }
  };
  
  // Create a new sortable container
  new Sortable(container, options); 
}

// Tell Shiny about the new output binding
Shiny.outputBindings.register(binding, "test.grid_drag_drop");

})();
