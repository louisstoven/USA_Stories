library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)

# Load your cleaned data
df1 <- read.csv("~/Downloads/USA_Stories_Cleaned.csv", row.names = NULL)
df1 <- df1 %>% select(-X)


# numeric columns only for plotting
df_num <- df1 %>% select(where(is.numeric))

ui <- page_sidebar(
  sidebar = sidebar(
    varSelectInput("xvar", "X variable", df_num, selected = "Profitability"),
    varSelectInput("yvar", "Y variable", df_num, selected = "Worldwide.Gross"),
    
        selectInput("plot_type", "Choose Plot Type", 
                choices = c("Scatter Plot", "Histogram", "Density Curve"),
                selected = "Scatter Plot")
  ),
  
  plotOutput("main_plot")
)

server <- function(input, output, session) {
    subsetted <- reactive({
    df1
  })
  output$main_plot <- renderPlot({
    if (input$plot_type == "Scatter Plot") {
      # Scatter plot uses both x and y
      p <- ggplot(subsetted(), aes(x = !!input$xvar, y = !!input$yvar)) +
        geom_point() +
        theme_minimal()
      
    } else if (input$plot_type == "Histogram") {
      # Histogram
      p <- ggplot(subsetted(), aes(x = !!input$xvar)) +
        geom_histogram(bins = 30, fill = "skyblue", color = "black", alpha = 0.7) +
        theme_minimal()
      
    } else if (input$plot_type == "Density Curve") {
      # Density plot
      p <- ggplot(subsetted(), aes(x = !!input$xvar)) +
        geom_density(fill = "lightblue", color = "black", alpha = 0.7) +
        theme_minimal()
    }
    # Return
    p
  })
}

shinyApp(ui, server)
