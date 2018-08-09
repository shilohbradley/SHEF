##################################################
# A Shiny app for creating custom SHEF reports.  #
##################################################

## Load packages -----
library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(openxlsx)

## Load sources -----
source("ggplot2_formatter.R")
source("load_and_clean.R")
source("aesthetics.R")

## Beginning of server -----
shinyServer(function(input, output, session) {
  
  dataset <- reactive({
    df <- df[df$State %in% input$states, ]
  })
  
  ## Beginning of main body -----
  output$mainbody <- renderUI({
    fluidPage(
      
      theme = "mystyle.css",
      
      br(), br(),
      br(), br(),
      titlePanel("State Higher Education Finance (SHEF)"), br(),
      h4("FY 1992-2017"), br(),
      br(), br(),
      br(), br(), 
      
      ## Sidebar and Subsetting Options -----
      sidebarLayout(
        sidebarPanel(
          ## Subsetting options 
          selectInput(inputId = "states",
                      label = h5("States"),
                      choices = list(default_state,
                                     "Overall United States" = usa,
                                     "Western Undergraduate Exchange (WUE)" = wue_choices,
                                     "Other States" = state_choices
                      ),
                      multiple = TRUE,
                      selected = default_state
          ),
          br(), br()
        ), 
        ## End of side bar
        
        ## Main Panel -----
        mainPanel(
          ## First plot
          output$plot1 <- renderPlot(
            ggplot(dataset(), 
                   aes(x = `Fiscal Year`, 
                       y = Rescale, 
                       color = State,
                       shape = State)) +
              geom_point() +
              geom_line() +
              scale_x_continuous(breaks = seq(1992, 2017, by = 2)) +
              scale_color_manual(values = color) +
              scale_shape_manual(values = c(0:25)) +
              labs(title = "Net Public FTE Enrollment",
                   x = "Fiscal Year",
                   y = "") +
              guides(fill = guide_legend(title = "States")) +
              expand_limits(y = 0) +
              theme_classic() +
              theme(title = bold.text,
                    axis.title = bold.text,
                    axis.text.x = bold.text,
                    axis.text.y = bold.text) +
              theme(legend.position = "bottom")
          ),
          
          br(), hr(), br(),
          ## Second Plot
          output$plot2 <- renderPlot(
            ggplot(dataset(), 
                   aes(x = `Fiscal Year`, 
                       y = `Educational Appropriations per FTE, Constant Dollars`, 
                       color = State,
                       shape = State)) +
              geom_point() +
              geom_line() +
              scale_x_continuous(breaks = seq(1992, 2017, by = 2)) +
              scale_y_continuous(labels = human_usd) +
              scale_color_manual(values = color) +
              scale_shape_manual(values = c(0:25)) +
              labs(title = "Educational Appropriations per FTE",
                   x = "Fiscal Year",
                   y = "Constant Dollars") +
              guides(fill = guide_legend(title = "States")) +
              expand_limits(y = 0) +
              theme_classic() +
              theme(title = bold.text,
                    axis.title = bold.text,
                    axis.text.x = bold.text,
                    axis.text.y = bold.text) +
              theme(legend.position = "bottom")
          ),
          
          br(), hr(), br(),
          ## Third plot
          output$plot3 <- renderPlot(
            ggplot(dataset(), 
                   aes(x = `Fiscal Year`, 
                       y = `Net Tuition per FTE, Constant Dollars`, 
                       color = State,
                       shape = State)) +
              geom_point() +
              geom_line() +
              scale_x_continuous(breaks = seq(1992, 2017, by = 2)) +
              scale_y_continuous(labels = human_usd) +
              scale_color_manual(values = color) +
              scale_shape_manual(values = c(0:25)) +
              labs(title = "Net Tuition per FTE",
                   x = "Fiscal Year",
                   y = "Constant Dollars") +
              guides(fill = guide_legend(title = "States")) +
              expand_limits(y = 0) +
              theme_classic() +
              theme(title = bold.text,
                    axis.title = bold.text,
                    axis.text.x = bold.text,
                    axis.text.y = bold.text) +
              theme(legend.position = "bottom")
          ),
          
          br(), hr(), br(),
          ## Fourth plot
          output$plot4 <- renderPlot(
            ggplot(dataset(), 
                   aes(x = `Fiscal Year`, 
                       y = `Student Share (Net Tuition as a Proportion of Total Educational Revenues)`,
                       color = State,
                       shape = State)) +
              geom_point() +
              geom_line() +
              scale_x_continuous(breaks = seq(1992, 2017, by = 2)) +
              scale_color_manual(values = color) +
              scale_shape_manual(values = c(0:25)) +
              labs(title = "Student Share",
                   x = "Fiscal Year",
                   y = "") +
              guides(fill = guide_legend(title = "States")) +
              expand_limits(y = 0) +
              theme_classic() +
              theme(title = bold.text,
                    axis.title = bold.text,
                    axis.text.x = bold.text,
                    axis.text.y = bold.text) +
              theme(legend.position = "bottom") 
          )
        ) ## End of Main panel
      ) ## End of Sidebar Layout
    ) ## End of Fluid Page
  }) ## End of Main body
})

## End of server -----