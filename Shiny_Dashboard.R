library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)

# Load your cleaned data
df1 <- read.csv("~/Downloads/USA_Stories_Cleaned.csv", row.names = NULL)
df1 <- df1 %>% select(-X)
numeric_columns <- df1 %>% select(where(is.numeric)) %>% names()
y_columns <- c("Year", "Profitability")  # Y-axis columns specifically

# Define the UI
ui <- page_sidebar(
  sidebar = sidebar(
    # X variable selection, excluding 'Year'
    selectInput("xvar", "X variable", choices = setdiff(numeric_columns, "Year")),
    
    # Y variable selection (can choose between 'Year' and 'Profitability')
    selectInput("yvar", "Y variable", choices = y_columns),
    
    # Plot type selection
    selectInput("plot_type", "Select plot type", 
                choices = c("Histogram", "Density Curve", "Scatter Plot")),
    
    # Checkbox to toggle smoother (for Scatter Plot)
    checkboxInput("show_smooth", "Add smoother", value = FALSE)
  ),
  plotOutput("main_plot")
)

# Define the server logic
server <- function(input, output, session) {
  
  # Reactive subset for the data
  selected_data <- reactive({
    df1
  })
  
  # Render the plot based on plot type and selected variables
  output$main_plot <- renderPlot({
    req(input$xvar, input$yvar)  # Ensure inputs are selected
    
    # If the plot type is Histogram
    if (input$plot_type == "Histogram") {
      ggplot(selected_data(), aes(x = .data[[input$xvar]])) +
        geom_histogram(bins = 30, fill = "blue", color = "white") +
        labs(x = input$xvar, title = paste("Histogram of", input$xvar)) +
        theme_minimal()
      
    } else if (input$plot_type == "Density Curve") {
      # Density plot uses only the x variable
      ggplot(selected_data(), aes(x = .data[[input$xvar]])) +
        geom_density(fill = "lightblue", color = "black", alpha = 0.7) +
        labs(x = input$xvar, title = paste("Density Plot of", input$xvar)) +
        theme_minimal()
      
    } else if (input$plot_type == "Scatter Plot") {
      # Scatter plot with option to add a smoother
      p <- ggplot(selected_data(), aes(x = .data[[input$xvar]], y = .data[[input$yvar]])) +
        geom_point(color = "darkred") +
        labs(x = input$xvar, y = input$yvar, title = paste("Scatter Plot of", input$xvar, "vs", input$yvar)) +
        theme_minimal()
      
      # Optionally add a smoother (e.g., regression line)
      if (input$show_smooth) {
        p <- p + geom_smooth(method = "lm", se = FALSE, color = "blue")
      }
      
      p  # Return the plot
    }
  })
}

# Run the Shiny app
shinyApp(ui, server)
