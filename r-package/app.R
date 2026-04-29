library(shiny)
library(analysiskmeans)
data(example_sce)

#My Shiny App that unfortunately never resulted in a finished product! Maybe One day!!

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "flatly"),

  titlePanel("Kmeans Explorer"),

  sidebarLayout(
    sidebarPanel(
      h4("Settings"),
      numericInput(
        "n_top",
        "Number of top variable genes:",
        value = 500,
        min = 50,
        max = 5000,
        step = 50
      ),
      selectInput(
        "color_by",
        "Color by:",
        choices = c("treatment", "batch")
      )
    ),
    mainPanel(
      plotOutput("p_scatter", height = "500px")
    )
  )
)

server <- function(input, output, session) {
  outputs = data_config(sce)
  counts_mat = outputs[1]
  sce = outputs[3]
  mat_norm = top_x_genes(sce, counts_mat, n_top = 100, assay_name = "counts")
  pca_mat = computepca(mat_norm)



  output$pca_plot <- renderPlot({
    # Run PCA with user-selected parameters

    outputs2 = k_means(5, n_starts = 25, seed = 42, pca_mat)
    metrics = outputs2[1]
    km_list = outputs2[2]

    # Create plot
    cluster_plot(input$selected_k, km_list)

  })
}

shinyApp(ui, server)
