library(shiny)
library(bslib)
library(shinyWidgets)
thematic::thematic_shiny(font = "auto")

data <- read.csv("data.csv", sep = ";", row.names = 1, header = T)

light <- bs_theme(primary = "#a23fd4", bg = "white", fg = "black")
dark <- bs_theme(primary = "#a23fd4", bg = "black", fg = "white")


ui <- fluidPage(includeCSS("www/style.css"),
                br(),
                titlePanel(h1("Polish Voivodeships population analysys")),
                theme = light,
                prettyCheckbox("dark_mode", "Dark mode", shape = "round", animation = "smooth"),
                img(src = "R_logo.png", align = "right", width = 150),
                tabsetPanel(
                  tabPanel("Graph",
                           h2("Population graph"),
                           sidebarLayout(
                             mainPanel(
                               h3(strong(textOutput("select"))),
                               code(textOutput("pop"),
                                    textOutput("change")), br(),
                               plotOutput("plot"),
                               "Population data source: GUS"
                             ),
                             sidebarPanel(
                               selectInput("sel", "Select desired country: ", choices = row.names(data))
                             )
                           )
                  )
                )
)

server <- function(input, output, session) {
  output$select <- renderText({
    paste(input$sel, " voivodeship")
  })
  output$pop <- renderText({
    paste("Population in 2020: ", data[input$sel, 19])
  })
  output$change <- renderText({
    paste("Change in population between 2003 and 2020: ", data[input$sel, 19] - data[input$sel, 2])
  })
  output$plot <- renderPlot({
    plot(x = c(2003:2020), y = data[input$sel, c(2:19)], col = "#a23fd4", type = "o", xlab = "Year", ylab = "Population", main = paste("Population of ", input$sel, " voivodeship."))
  })

  observe(session$setCurrentTheme(
    if (isTRUE(input$dark_mode)) dark else light
  ))


}


shinyApp(ui, server)