##########################
##### User Interface #####
##########################

# Layout
##############################################################################################################################################
# The User Interface generates the visual of the application. It establishes location and layout of all outputs and inputs from server and user
# First:  The dashboard header shows the main title and introduction to the application
# Second: The sidebar shows all inputs that the user can change
# Third:  The body provides all visual outputs, statistics, and charts. It is updated every time a user changes the inputs
##############################################################################################################################################     




# Begin User Interface ------------------------------------------------------------------------------------------------------------------------------------------------------------



#Build UI
#Establishes the layout of the overall dashboard and how items are displayed
ui <- tagList(
    #Warning Banner
    HTML('<body text = white bgcolor = blue> <center> <font size = 3 color = black> *** Pre-Decisional // Projections Are Estimates and Pulled From Public Sources *** </p> </center></body>'),
    dashboardPage(skin = "black",title="COVID-19 Health Assessment Dashboard",
                  
                 # Step One - Header
                 ###################################################################################################################################################
                  dashboardHeader(title = div(img(src="AFIT_Emblem_Blue.png",height = '50',width = '110')),
                                  titleWidth = 300,
                                  dropdownMenu( 
                                      icon = tags$div(HTML('<font size = "5" color = "blue" font-weight:"bold" >More Information</font>  <i class="fa fa-info-circle" style = "font-size:18px;"></i> <body style="background-color:powderblue;"></body>')),
                                      headerText = "Want to know more?",
                                      badgeStatus = "primary",
                                      tags$li(actionLink("overviewInfo", label = "Overview", icon = icon("globe")),
                                              class = "dropdown"),
                                      tags$li(actionLink("inputInfo", label = "User Inputs", icon = icon("sliders-h")),
                                              class = "dropdown"),
                                      tags$li(actionLink("projInfo", label = "Projections", icon = icon("chart-line")),
                                              class = "dropdown"),
                                      tags$li(actionLink("calcInfo", label = "Calculations", icon = icon("calculator")),
                                              class = "dropdown"),
                                      tags$li(actionLink("sourceInfo", label = "Sources", icon = icon("user-secret")),
                                              class = "dropdown")
                                  )
                  ),
                  
                  # Step Two - Sidebar
                  ###################################################################################################################################################
                  dashboardSidebar(width = 300,
                                   sidebarMenu(
                                       selectInput(
                                           "Base",
                                           "Choose your base:", 
                                           list(`Installation` = sort(BaseList) ), 
                                           selectize = FALSE),
                                       sliderInput("Radius",
                                                   "Choose your local radius (miles):",
                                                   min = 10,
                                                   max = 100,
                                                   value = 50),
                                       br(),
                                       
                                       menuItem(
                                           "MAJCOM Summary Inputs",
                                           tabName = "MAJCOMsummary",
                                           icon = icon("sliders-h"),
                                           div(id = "single", style="display: none;", numericInput("tckt", "Ticket Number : ", 12345,  width = 300)),
                                           radioButtons("SummaryStatistic",
                                                        "Cases or Hospitalizations: ",
                                                        c("Cases"="Cases",
                                                          "Hospitalizations"="Hospitalizations")),
                                           selectInput(
                                               "MAJCOMInput",
                                               "MAJCOM:", 
                                               list(`MAJCOM` = MAJCOMList ), 
                                               selectize = FALSE),
                                           radioButtons("SummaryModelType",
                                                        "Summary Plot Model: ",
                                                        c("IHME"="IHME",
                                                          "CHIME"="CHIME")),
                                           radioButtons("SummaryForecast",
                                                        "Choose Days Forecasted: ",
                                                        c('Today'='Today',
                                                          "7 Days"="Seven",
                                                          "14 Days"="Fourteen",
                                                          "30 Days"="Thirty",
                                                          "60 Days"="Sixty"))
                                           
                                       ),
                                       br(),
                                       menuItem(
                                           "Current Local Health Inputs",
                                           tabName = "localHealthInput",
                                           icon = icon("map-marker-alt"),
                                           div(id = "single", style="display: none;", numericInput("tckt", "Ticket Number : ", 12345,  width = 300)),
                                           radioButtons("TypeLocal", "State or County Plot:",
                                                        c("County"="County",
                                                          "State"="State"))
                                       ),
                                       br(),
                                       menuItem(
                                           "Local Health Projection Inputs",
                                           tabName = "localHealthProj",
                                           icon = icon("sliders-h"),
                                           div(id = "single", style="display: none;", numericInput("tckt", "Ticket Number : ", 12345,  width = 300)),
                                           radioButtons("StatisticType", "Choose projected statistic:",
                                                        c("Hospitalizations"="Hospitalizations",
                                                          "Fatalities"="Fatalities")),
                                           sliderInput("proj_days",
                                                       "Projection days:",
                                                       min = 14,
                                                       max = 120,
                                                       value = 30),
                                           checkboxGroupInput("SocialDistanceValue", "Local Social Distancing Actions: ",
                                                              c("Close Schools" = "CS",
                                                                "Businesses Telework" = "CB",
                                                                "Social Distance" = "SD"))
                                       ),
                                       br(),
                                       menuItem(
                                           "National Health Projection Inputs",
                                           tabName = "natHealthProj",
                                           icon = icon("sliders-h"),
                                           div(id = "single", style="display: none;", numericInput("tckt", "Ticket Number : ", 12345,  width = 300)),
                                           sliderInput("proj_days_national",
                                                       "Projection days:",
                                                       min = 14,
                                                       max = 120,
                                                       value = 30),
                                           checkboxGroupInput("SocialDistanceValueNational", "National Social Distancing Actions: ",
                                                              c("Close Schools" = "CSN",
                                                                "Businesses Telework" = "CBN",
                                                                "Social Distance" = "SDN"))
                                       ),

                                       br(),
                                       
                                       div(style="text-align:center", tags$hr(style="border-color: #444;"), "Generate & Download Report:"),
                                       br(),
                                       fluidRow(
                                           downloadButton("report", "Generate Report", class = "butt"),
                                           tags$style(".skin-black .sidebar .butt{background-color:#15824d;color: white;border-color:white;}"),
                                           align = "center"
                                       )

                                       # fluidRow(
                                       #     valueBox("LOW RISK", subtitle ="Mission Risk **notional ex.**",color= "green",width = 12)
                                       # ),
                                       # fluidRow(h()
                                       #     valueBox("MEDIUM RISK", subtitle ="Installation Health Risk **notional ex.**",color= "yellow", width = 12)
                                       # ),
                                       # fluidRow(
                                       #     valueBox("HIGH RISK", subtitle ="Local Health Risk **notional ex.**",color= "red",width = 12)
                                       # )
                                   ),
                                   tags$footer(
                                       tags$p(paste0("* Current as of ",format(Sys.Date(),format = "%d %B %Y")," at 0600 EST *")),
                                       style = "
                                       position: fixed;
                                       bottom: 0;
                                       width: 90%;
                                       color: #8aacc8;
                                       padding: 20px;
                                       font-size: 15px;
                                       "
                                   )
                                   
                  ),
                  
                  
                  # Step Three - Body
                  ###################################################################################################################################################
                  dashboardBody(
                      tags$head(tags$style(HTML(
                          '.myClass { 
                    font-size: 20px;
                    line-height: 50px;
                    text-align: left;
                    font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
                    padding: 0 15px;
                    overflow: hidden;
                    color: black;
                    }
                    '))),
                      tags$script(HTML('
                                   $(document).ready(function() {
                                   $("header").find("nav").append(\'<span class="myClass"> COVID-19 Health Assessment Dashboard Beta v0.5</span>\');
                                   })
                                   ')),
                      tabsetPanel(id = "tabs",
                                  
                                  ####### BEGIN SUMMARY TAB #########
                                  # Mission Risk ------------------------------------------------------------
                                  tabPanel(
                                      title = "MAJCOM Summary",
                                      fluidRow(
                                          box(plotlyOutput("SummaryTabChoro", height = 600, width = 'auto',),height = 600, width = 900)),
                                      box(title = "Projected Daily Hospitalizations",
                                          solidHeader=T, 
                                          align = "left", 
                                          column(width = 12, 
                                                 DT::dataTableOutput("ForecastDataTable"), 
                                                 style = "height:720px;overflow-y: scroll"), 
                                          height = 900, 
                                          width =13,
                                          downloadButton('downloadData', 'Download Full Dataset'),
                                          downloadButton('HotSpotData', 'Download Hotspot Dataset'))
                                      
                                  ),
                                  ####### END Mission Risk #######
                                  
                                  # Summary Tab -------------------------------------------------------------
                                  tabPanel(
                                      title = "National Summary",
                                      
                                      box(title = "National Impact Map",solidHeader = T, align = "center", htmlOutput("SummaryPlot"),width = 13),
                                      
                                      box(title = "National Statistics", solidHeader=T, align = "left", column(width = 12, DT::dataTableOutput("NationalDataTable1"), style = "height:240px;overflow-y: scroll;overflow-x:scroll"),width = 13)
                                      
                                  ),
                                  ####### END SUMMARY TAB #######
                                  
                                  
                                  # Current Local Health ----------------------------------------------------
                                  tabPanel(
                                      title = "Current Local Health",
                                      fluidRow(
                                          # A static valueBox
                                          valueBoxOutput("CovidCases"),
                                          valueBoxOutput("LocalCovidDeaths"),
                                          valueBoxOutput("HospitalUtilization")
                                      ),
                                      fluidRow(
                                          tags$style(".small-box{border-radius:10px;}"),
                                          valueBoxOutput("CaseChangeLocal", width = 4),
                                          valueBoxOutput("DeathChangeLocal", width = 4),
                                          valueBoxOutput("HospUtlzChange", width = 4)
                                      ),
                                      fluidRow( 
                                          box(title = "Daily Reports",plotlyOutput("LocalHealthPlot1",height = 300)),
                                          box(title = "Total Reports",plotlyOutput("LocalHealthPlot2",height = 300))
                                      ),
                                      fluidRow(
                                          box(title = "Local Impact Map", plotlyOutput("LocalChoroPlot", height = 250),height = 300),
                                          box(title = "Local County Statistics", solidHeader=T, align = "left", column(width = 12, DT::dataTableOutput("CountyDataTable1"), style = "height:240px;overflow-y: scroll"), height = 300)
                                      )
                                  ),
                                  ####### END CURRENT LOCAL HEALTH TAB #######
                                  
                                  ####### BEGIN LOCAL PROJECTION TAB #########
                                  # Local Health Projections ------------------------------------------------
                                  tabPanel(
                                      title = "Local Health Projections",
                                      fluidRow(
                                          valueBoxOutput("TotalPopulation"),
                                          valueBoxOutput("IHMEPeakDate"),
                                          valueBoxOutput("CHIMEPeakDate")
                                          #valueBoxOutput("TotalPopulation"),
                                          #valueBoxOutput("IHMEMinMax"),
                                          #valueBoxOutput("CHIMEMinMax")
                                          
                                      ),
                                      fluidRow(
                                          box(plotlyOutput("IHME_State_Hosp",height = 400)),
                                          box(plotlyOutput("SEIARProjection"),height = 400)),
                                          box(plotlyOutput("OverlayPlots"), width =  900)
                                  ),
                                  ####### END PROJECTION TAB #######
                                  
                                  ####### BEGIN National PROJECTION TAB #########
                                  # National Health Projections ------------------------------------------------
                                  tabPanel(
                                      title = "National Health Projections",
                                      # fluidRow(
                                      #     valueBoxOutput("TotalPopulation_National"),
                                      #     valueBoxOutput("CHIMEPeakDate_National"),
                                      #     valueBoxOutput("IHMEPeakDate_National")
                                      #),
                                      fluidRow(
                                          box(plotlyOutput("IHMENationaProj",height = 400)),
                                          box(plotlyOutput("CHIMENationalProj"),height = 400)),
                                          box(plotlyOutput("NationalPlotOverlay"), width =  900)
                                  )
                                  ####### END PROJECTION TAB #######
                                  

                                      ) #close dash body

                                  
                                  
                                  
                      )
                  )
    )
    

              




