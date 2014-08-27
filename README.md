#CorePlotConstructor

[Core Plot](https://github.com/core-plot/core-plot) is an open source framework for creating various types of graphs on the Mac and iOS platforms. CorePlotConstructor is a developer tool supporting Core Plot.

Creating a graph requires fine-tuning a very large number of possible parameters – axis styles, fonts, labelling offsets, colors, etc. Creating a graph in code requires many dozens of lines of code. Graphs are, however, a visual medium, and it’s tricky to imagine how what is being written in code will translate on screen. The process becomes one of writing code, compiling, displaying the graph, updating the code, and repeating. This can be very time consuming. 

Core Plot Constructor is a small application that draws a graph and provides an inspector to change dozens of graph settings. All the changes are reflected instantly, allowing one to customize the design of a graph without having to think of code.

Once a graph is to your liking, you will be able to “export” it in the form of a configuration file. With classes provided here, you will be able to include this configuration file in your application and use it to create a Core Plot graph. The graph can then be further customized in your code.

### Project Status

The first major part of the code is complete – nearly all of the parameters to describe a scatter plot graph are available in the inspector. There are a few things missing which may be added later, but most everything one would want is there.

The next step is to define and export a configuration file; this has not yet been started.

Currently only a scatter plot ([CPTXYGraph](http://core-plot.github.io/MacOS/interface_c_p_t_x_y_graph.html))is implemented. I am interested in extending this to histograms ([CPTBarPlot](http://core-plot.github.io/MacOS/interface_c_p_t_bar_plot.html)), but am unlikely to personally extend this program much beyond that (unless I find a need to create other types of graphs). If others find this useful, it should be a relatively straightforward manner to extend this application to include other plot types. Contributions certainly welcome!