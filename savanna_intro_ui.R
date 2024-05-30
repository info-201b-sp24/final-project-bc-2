library(shiny)
library(ggplot2)
library(dplyr)
library(readr)
library(plotly)
library(shinythemes)
library(rsconnect)

custom_css <- "
  body {
    font-family: 'Arial', sans-serif;
  }
  h1 {
    color: #2E4053;
    border-bottom: 2px solid #D5D8DC;
    padding-bottom: 10px;
  }
  p {
    text-align: justify;
    font-size: 16px;
    line-height: 1.6;
  }
  a {
    color: #1F618D;
  }
  .navbar {
    background-color: #ffffff !important;  /* Set background to white */
    border: none;  /* Remove any border */
  }
  .navbar-brand {
    font-size: 24px;
    color: #ffffff !important;
  }
"

introduction_tab <- tabPanel("Introduction",
  h1("Introduction"),
  p("Civic engagement through voter registration is the foundation of a functioning democracy, where people can share their societal values and opinions. We pose the question: how do voter demographics among registered voters affect the level of civic engagement? To answer this issue, we will examine voter registration statistics from various cities and counties, and examine voter turnout by gender to uncover general trends in civic engagement and public opinion. Identifying trends such as which counties, cities, and genders have the most civic engagement in Washington will provide great insight for active politicians and societal development."),
  h1("Keywords"),
  p("Washington State, Voter Demographics, Counties, Cities, Gender"),
  h1("Potential Questions"),
  p("Which city has the highest voter turnout?"),
  p("Which gender has a higher voter turnout?"),
  p("How might Washington’s demographics be helpful in predicting demographics in the U.S.?"),
  p("The topic of civic engagement has many large implications and important questions. The data can give insight into trends in public opinion. One important question is simply how many people register in each city. Cities in Washington and the US in general, have vastly differing populations and political views. By understanding the number of people registering to vote in different cities, you can observe which areas and groups of people feel more inclined to vote."),
  p("Another important question is how the gender of voter turnout varies across counties. Learning what areas of the state show trends of a certain gender voting more could help to identify what factors are in play. This trend could raise many questions about how Washington fits into national trends. It could also explain changes in the state itself."),
  p("The last important question raised by this data is how Washington compares to other states in voter turnout and political beliefs. Understanding voter trends is an incredibly important aspect of a democratic system. Knowledge of these trends can reveal areas of unrest and anger among the people. Voter turnout and political affiliation can vary greatly with the changing of topics in public discussion. By analyzing and interpreting voter data, a greater understanding of public belief and social values can be achieved."),
  h1("Related Work"),
  p("The topic of civic engagement and voter behavior can be crucial in understanding the dynamics of democracy and public opinion. Scholars and researchers have examined various aspects of this subject, utilizing data to reveal trends, patterns, and potential implications. It is important to understand voter registration and turnout in order to evaluate the level of civic engagement in a community or nation."),
  p("Details on voter behavior can be gained from reports like the Washington Secretary of State's as well as data from state election boards and the U.S. Census Bureau. For example, recent reports from the Washington Secretary of State indicate shifts in voter turnout, with some elections experiencing modern lows in participation rates, as highlighted in Alison Saldanha's article in The Seattle Times. Another important part is examining how political opinions and partisanship have changed throughout time. Opinion surveys, comparative analyses between regions, and ongoing studies are frequently used by researchers to monitor shifts in voter preferences."),
  p("FOX13 News reported on recent statistics from the 2024 Presidential Primary in Washington, which provides insight into regional differences in ideologies and party support and offers data on how different counties voted. Related work in this space includes academic research articles, government reports like those published by the Washington Secretary of State, and media coverage from outlets such as The Seattle Times and FOX13 News. These resources add to the continuing discussion about voter behavior and civic involvement, which deepens our understanding of how democracies work and the opportunities and challenges they bring."),
  p(a("General Election Turnout.", href="https://www.sos.wa.gov/elections/data-research/election-data-and-maps/reports-data-and-statistics/general-election-turnout"), " Accessed 1 May 2024."),
  p(a("Saldanha, Alison. “Did You Vote? A Lot of Your Neighbors Didn’t.” The Seattle Times.", href="https://www.seattletimes.com/seattle-news/voter-turnout-hits-modern-low-in-wa/"), " Accessed 1 May 2024."),
  p(a("Seattle, FOX 13. “How Every WA County Voted in the 2024 Presidential Primary.” FOX13 News.", href="https://www.fox13seattle.com/election/wa-primary-results-county"), " Accessed 1 May 2024."),
  h1("The Dataset"),
  p("We found our dataset from Washington's ", a("City Registration Table", href="https://www.sos.wa.gov/elections/data-research/election-data-and-maps/reports-data-and-statistics/voter-demographics"), ". It was collected by the Washington Secretary of State, which records data when people register to vote. The voter demographics are collected to ensure fair representation, shape policies, strategize elections, and study voting behavior. Our dataset has 328 rows and 5 features."),
  p("Considering potential ethical questions, voter registration data contains sensitive information, such as names, addresses, and voting history. It is essential to handle this data with care and ensure that individuals' privacy is protected. Furthermore, we should be aware of potential biases in the data, such as underrepresentation of certain demographic groups, and take steps to mitigate these biases in our analysis."),
  h1("Potential Limitations or Problems with the Dataset"),
  p("For the most part, the data is truthful and accurate since it is recorded by the government. However, voter demographics are input by people, so there could be inaccuracies due to human error. For example, voters might accidentally fill in the wrong bubble or other personal information. Also, the data may not fully reflect the complexity of voter demographics since people may not fit exactly into the categories provided, or simply opt out of submitting some information."),
  p("Voter demographics are usually updated every year or in other specific intervals, and may be inaccurate if voters are not regularly updating their government registrations, so the data would become outdated quickly. This could especially be the case for counties and cities where population mobility is high, or in election years in which voter registration becomes intensified."),
  p("Some of the registered voters could also be inactive because they moved away or just disengaged from the electoral process, so their data would lead to inaccuracies in predicting voter preference. One last concern could be data manipulation or tampering, where voter registration systems or people try to manipulate the demographics for political benefit. Though this is unlikely as government information has higher levels of security, it is still a possibility that could affect the data."),
  h1("Implications"),
  p("Possible implications for technologists include the development of better systems of data collection, reducing the level of human error, including measures that detect and prevent data manipulation and tampering, and systems that update voter demographics in real time to reduce outdated information. User-friendly systems with a good design and proper instructions could go a long way in minimizing errors."),
  p("Systems to keep real-time records of voter information could also result in consistently reliable data. The collaboration between technologists and designers is going to be very important to identify ways to locate and eliminate inactive voters and increase the number of citizens into active voter participation in the electoral process."),
  p("This could be troublesome for policymakers to devise effective strategies of changing voters' minds in case the demographics happen to be wrong. They might have to rely on errors in the collected data or, alternatively, direct more energy to ensuring that the data collected is correct and safe. Again, the implications with government recorded data are very few apart from human recorded error. Still, technologists, designers, and policymakers can work up innovations to tackle the issue."),
  h1("Challenges and Limitations"),
  p("Throughout the course of this challenge, there may be a variety of challenges and limitations that arise. One limitation would be that access to voter registration and election result data may be limited or restricted due to data protection regulations or simply due to human error. Missing data, especially in demographic variables, can pose challenges when analyzing voter demographics. Thus, imputing missing values or handling them appropriately is important to avoid bias in the analysis."),
  p("One challenge that may need to be addressed would be the temporal nature of the project. Conducting a temporal analysis to understand how voter demographics and participation have changed over time requires careful consideration of data from multiple election cycles (e.g., do most areas stay republican or how have they changed?). Ensuring that the data is consistent across different time periods is essential for meaningful comparisons."),
  p("As another challenge, we need to ensure that our data is used responsibly and in accordance with ethical standards. Given that access to voter
imageOutput("vote_image")


conclusion_tab <- tabPanel("Conclusion",
h1("Conclusion"),
p("The purpose of this analysis was to explore civic engagement through the demographics of registered voters. By analyzing gender and geographical distribution, we uncovered trends and patterns across the counties and cities in Washington State. Our analysis revealed that each city has a higher number of female registrants than male registrants in 45 out of the 248 cities. This aligns with the national trend that women tend to register and vote at a higher rate than men, and sheds light on the increase in female political engagement. This is likely due to the evolution of gender roles because women can rely more on men to care for their family, allowing them more time to research and engage in political affairs. Additionally, our geographical analysis revealed there are significant differences in civic engagement across the list of counties and cities. More urban areas such as the cities in King County, and especially Seattle, showed a disproportionately higher number of voter registrants because it has such a large population. Seattle also had a more balanced gender ratio, with 233,151 female registrants and 227,984 male registrants compared to more rural areas such as Ocean Shores with 3,275 female registrants and 2,919 male registrants. Such disparities emphasize the need for targeted voter education programs to balance the engagement gap between rural and urban areas in Washington. Overall, understanding and addressing the differences in demographic and geographic factors can provide valuable insights for policymakers and each community. This data can be used to influence voter behavior and develop strategies to connect with voters and connect a more inclusive democratic process."))


ui <- navbarPage("Voter Demographics Analysis",
                 theme = shinytheme("cerulean"),
                 tags$style(HTML(custom_css)),  # Add custom CSS here
                 introduction_tab)

server <- function(input, output) {
  # Placeholder for server logic
}

shinyApp(ui = ui, server = server)
