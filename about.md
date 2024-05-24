## Welcome to Sevien's Spatial House Price Prediction Web Application! 

This tool is designed to provide accurate and data-driven estimates for house prices based on several key variables. Utilizing advanced statistical models, such as the **Spatial Autoregressive Model (SAR)** and the **Spatial Error Model (SEM)**, our app offers reliable predictions by considering both the spatial relationships and error dependencies inherent in housing data.

Users can choose between the SAR and SEM models to forecast house prices based on variables including land area (Luas Tanah), building area (Luas Gedung), electricity power (Daya Listrik), and district (Kecamatan). By incorporating these critical factors, our application ensures a comprehensive and nuanced analysis, helping you make informed decisions in the real estate market. Explore our app to discover how these models can enhance your understanding of house pricing dynamics.

#### What is Spatial Autoregressive Model (SAR)?
The Spatial Autoregressive Model (SAR) is a powerful statistical tool used to analyze and predict house prices by incorporating spatial dependencies between observations. Unlike traditional regression models that assume independence among data points, the SAR model recognizes that properties located near each other are likely to influence each other's prices. This spatial interdependence is captured through a spatial lag term, which accounts for the value of neighboring properties.

In practical terms, the SAR model enhances prediction accuracy by considering the geographic context of each property. It integrates spatial relationships, ensuring that the price of a house is not only determined by its individual characteristics, such as land area, building area, and electricity power but also by the prices of surrounding houses. This makes the SAR model particularly suited for real estate markets, where location and proximity play crucial roles in determining property values.

By using the SAR model in our web application, users can benefit from a more sophisticated and contextually aware approach to house price prediction. This model helps to provide a realistic and reliable estimate, reflecting the complex interplay of spatial factors in the housing market.

#### What is Spatial Error Model (SEM)?
The Spatial Error Model (SEM) is an advanced statistical approach designed to account for spatial autocorrelation in the error terms of a regression model. In the context of house price prediction, this model acknowledges that there might be unobserved factors influencing property values that are spatially correlated.

Unlike traditional regression models that assume errors are randomly distributed, the SEM adjusts for the possibility that the residuals (errors) from the model could be correlated across nearby locations. This is important in real estate because factors such as neighborhood amenities, environmental quality, and local policies can affect house prices in a way that creates spatial patterns in the errors.

In practical use, the SEM improves prediction accuracy by correcting for these spatial dependencies in the errors, ensuring that the influence of omitted or unobserved variables is properly accounted for. This results in more reliable estimates of house prices that reflect both the direct impact of observable characteristics (such as land area, building area, electricity power, and district) and the indirect influence of spatially correlated unobserved factors.

By incorporating the SEM in our web application, users can achieve a deeper and more accurate understanding of house pricing dynamics. This model provides robust predictions by addressing the spatial structure of the data, making it a valuable tool for anyone looking to make informed decisions in the real estate market.

> BMI = kg/m^2

where *kg* represents the person's weight and *m^2* the person's squared height.

#### References
1. Centers for Disease Control. [Body Mass Index (BMI)](https://www.cdc.gov/healthyweight/assessing/bmi/index.html), Accessed January 26, 2020.
2. Centers for Disease Control. [BMI Percentile Calculator for Child and Teen](https://www.cdc.gov/healthyweight/bmi/calculator.html), Accessed January 26, 2020.