Summary:
The summary of this dataset provides a snapshot of various variables. Here's a breakdown of the key components:

1. **views**:
   - **Min**: 0
   - **1st Qu.**: 1,410
   - **Median**: 4,173
   - **Mean**: 187,592
   - **Max**: 218,559,516
   - This variable likely represents the number of views for a particular item (e.g., a post, article, or video). The wide range from 0 to over 218 million suggests a highly skewed distribution, with some items receiving an enormous number of views compared to others.

2. **mature**:
   - **Min**: 0
   - **1st Qu.**: 0
   - **Median**: 0
   - **Mean**: 0.471
   - **Max**: 1
   - This variable likely indicates whether an item is mature (e.g., mature content). The median and 1st quartile being 0 suggest most items are not marked as mature. The mean being 0.471 indicates that slightly less than half of the items might be classified as mature.

3. **life_time**:
   - **Min**: 41
   - **1st Qu.**: 990
   - **Median**: 1,542
   - **Mean**: 1,540
   - **Max**: 4,161
   - This variable appears to represent the lifetime of an item in some unit (e.g., days, hours). The range suggests most items have a life span of up to a few thousand units, with a fairly normal distribution around the mean of 1,540.

4. **created_at and updated_at**:
   - These variables represent dates in **character** format (likely strings).
   - They are used to track when an item was created and last updated.
   - The exact distribution of the dates isn't clear because of the "character" class, but they would need to be converted into date-time objects for proper analysis.

5. **dead_account**:
   - **Min**: 0
   - **1st Qu.**: 0
   - **Median**: 0
   - **Mean**: 0.02993
   - **Max**: 1
   - This variable likely indicates whether an account is "dead" or inactive, where 0 indicates active and 1 indicates inactive. The mean suggests a very small percentage of accounts are dead.

6. **language**:
   - **Class**: character
   - This variable indicates the language in which the item is available. It's represented as a character type, likely with various categories of language data.

7. **affiliate**:
   - **Min**: 0
   - **1st Qu.**: 0
   - **Median**: 0
   - **Mean**: 0.4839
   - **Max**: 1
   - This variable may indicate whether the item is affiliated with a certain group or category (0 = no, 1 = yes). The mean suggests that about half of the items might be affiliated.

8. **degree_centrality**:
   - **Min**: 2
   - **1st Qu.**: 3
   - **Median**: 5
   - **Mean**: 13.39
   - **Max**: 10,040
   - This variable measures the degree centrality in a network (how connected an item is). The mean of 13.39 with a high max value suggests some items are highly central, with many connections, while most are relatively less connected.

9. **eigenvector_centrality**:
   - **Min**: 0.0000013
   - **1st Qu.**: 0.0051541
   - **Median**: 0.0093801
   - **Mean**: 0.0122964
   - **Max**: 1.0000000
   - This variable measures an item’s influence in the network. The mean value is low, suggesting that most items have relatively low influence, but a few items are highly influential (max value is 1).

10. **closeness_centrality**:
   - **Min**: 0.2004
   - **1st Qu.**: 0.3168
   - **Median**: 0.3429
   - **Mean**: 0.3443
   - **Max**: 0.4678
   - This variable measures how close an item is to all other items in the network. The values are fairly clustered between 0.2 and 0.47.

11. **betweenness_centrality**:
   - **Min**: 0
   - **1st Qu.**: 1.700e-07
   - **Median**: 6.200e-07
   - **Mean**: 9.785e-06
   - **Max**: 2.275e-02
   - This variable measures an item’s role in bridging gaps between other items. The mean value is very low, suggesting that most items don’t act as bridges, but some have a higher betweenness (as indicated by the max value).

12. **maturity_rating**:
   - **0**: 13,734 items
   - **1**: 12,227 items
   - This binary variable likely represents whether the item has a certain maturity rating (e.g., mature or not). The data seems to be evenly split between the two categories.

### Summary of Key Insights:
- **Views**: There's a significant variance in views, with a few items getting massive attention and others getting very few.
- **Maturity**: A small percentage of items are classified as mature.
- **Lifetime**: The lifetime of items ranges from a short period to over 4,000 units.
- **Dead accounts**: Most accounts are active, with only a small percentage being inactive.
- **Network centrality measures**: Most items have low degree, eigenvector, and betweenness centrality, but a small number of items are highly influential.



T-Test

The results of the Welch Two Sample t-test provide insights into the relationship between **maturity rating** and **views**. Here’s what the key components of the output tell us:

### 1. **t-statistic (t = 2.7607)**:
   - The t-statistic measures the difference between the means of the two groups (group 0 and group 1), relative to the variability in the data. A higher absolute value of the t-statistic suggests a larger difference between the group means compared to the variability.
   - The t-statistic of 2.7607 indicates that there is a significant difference between the groups.

### 2. **Degrees of freedom (df = 23876)**:
   - The degrees of freedom are based on the sample size and the variability within each group. In this case, the df is quite large, suggesting that the sample size is substantial and the test results are likely reliable.

### 3. **p-value (p-value = 0.005773)**:
   - The p-value indicates the probability of obtaining a t-statistic as extreme as 2.7607 (or more extreme) if the null hypothesis were true (i.e., there is no difference between the two groups). 
   - A p-value of **0.005773** is less than the commonly used significance level of 0.05, which means we reject the null hypothesis and conclude that there is a statistically significant difference between the views in group 0 (not mature) and group 1 (mature).

### 4. **Alternative hypothesis**:
   - The alternative hypothesis tested is that the true difference in means between the two groups is **not equal to 0** (i.e., there is a difference in views between the two groups).

### 5. **Confidence Interval (95% CI: 28,607.55 to 168,682.32)**:
   - The 95% confidence interval provides a range of values within which the true difference in means is likely to fall. Since the entire interval is positive, this further supports the conclusion that group 0 (not mature) has higher views on average than group 1 (mature).

### 6. **Mean views in each group**:
   - **Group 0 (not mature)** has a mean of **234,051.3** views.
   - **Group 1 (mature)** has a mean of **135,406.3** views.
   - The mean views for group 0 are significantly higher than for group 1, indicating that items in the "not mature" category tend to have more views than items in the "mature" category.

### Conclusion:
The t-test results suggest that there is a statistically significant difference in the average number of views between items with a **maturity rating of 0** (not mature) and those with a **maturity rating of 1** (mature). Items that are not mature tend to receive more views than items classified as mature.

Basic model:
 # Regression Analysis 2: Interaction model with centrality measures
> interaction_model <- lm(
+   views ~ mature * (degree_centrality + eigenvector_centrality + closeness_centrality + betweenness_centrality), 
+   data = data
+ )
> summary(interaction_model)

Call:
lm(formula = views ~ mature * (degree_centrality + eigenvector_centrality + 
    closeness_centrality + betweenness_centrality), data = data)

Residuals:
      Min        1Q    Median        3Q       Max 
 -5950091   -225365   -133278   -114058 218225680 

Coefficients:
                                Estimate Std. Error t value Pr(>|t|)    
(Intercept)                   -2.196e+06  4.213e+05  -5.211 1.89e-07 ***
mature                         2.320e+06  6.202e+05   3.741 0.000184 ***
degree_centrality              7.128e+03  8.154e+02   8.742  < 2e-16 ***
eigenvector_centrality        -4.118e+07  5.970e+06  -6.898 5.40e-12 ***
closeness_centrality           8.287e+06  1.385e+06   5.984 2.21e-09 ***
betweenness_centrality        -1.384e+09  2.391e+08  -5.786 7.30e-09 ***
mature:degree_centrality      -7.455e+03  1.316e+03  -5.666 1.48e-08 ***
mature:eigenvector_centrality  4.250e+07  8.798e+06   4.831 1.37e-06 ***
mature:closeness_centrality   -8.293e+06  2.042e+06  -4.062 4.88e-05 ***
mature:betweenness_centrality  1.481e+09  6.216e+08   2.382 0.017225 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2937000 on 25951 degrees of freedom
Multiple R-squared:  0.003606,	Adjusted R-squared:  0.003261 
F-statistic: 10.44 on 9 and 25951 DF,  p-value: 2.844e-16

Interaction Model

The output of the **interaction model** regression provides insights into the relationship between **views** and the predictor variables, along with their interactions. This model includes interaction terms between the **mature** variable and the various **centrality** measures. Here's a breakdown of the results:

### 1. **Model Overview**:
   - The formula used in the model is:
     \[
     \text{views} \sim \text{mature} \times (\text{degree_centrality} + \text{eigenvector_centrality} + \text{closeness_centrality} + \text{betweenness_centrality})
     \]
   - The interaction terms (**mature** multiplied by each of the centrality measures) indicate how the relationship between **views** and the centrality measures changes depending on whether **mature** is 0 or 1.

### 2. **Residuals**:
   - The residuals show large differences between the minimum and maximum values:
     - **Min**: -5,950,091
     - **1st Qu.**: -225,365
     - **Median**: -133,278
     - **3rd Qu.**: -114,058
     - **Max**: 218,225,680
   - The spread of residuals is similar to the previous model, indicating the model doesn't explain the data well for all observations, with some large outliers.

### 3. **Coefficients**:
   The table below shows the estimated coefficients, **t-values**, and **p-values** for the predictor variables and their interactions.

   - **Intercept**: The intercept is **-2.196e+06**, meaning when all predictors and interaction terms are zero, the predicted number of **views** is approximately -2,196,000, which is not meaningful.
     - The **t-value** is -5.211, and the **p-value** is 1.89e-07, indicating the intercept is statistically significant.

   - **mature**: The coefficient for **mature** is **2.320e+06**, meaning that when **mature** is 1 (as opposed to 0), the number of **views** increases by 2.32 million, holding all other variables constant. 
     - The **t-value** is 3.741, and the **p-value** is 0.000184, indicating **mature** is statistically significant.

   - **degree_centrality**: The coefficient is **7.128e+03**, meaning that for each 1-unit increase in **degree_centrality**, the number of **views** increases by 7,128 views. 
     - The **t-value** is 8.742, and the **p-value** is less than 2e-16, indicating **degree_centrality** is highly significant.

   - **eigenvector_centrality**: The coefficient is **-4.118e+07**, meaning for each 1-unit increase in **eigenvector_centrality**, the number of **views** decreases by 41.18 million views. 
     - The **t-value** is -6.898, and the **p-value** is 5.40e-12, indicating **eigenvector_centrality** is statistically significant.

   - **closeness_centrality**: The coefficient is **8.287e+06**, meaning for each 1-unit increase in **closeness_centrality**, the number of **views** increases by 8.287 million views.
     - The **t-value** is 5.984, and the **p-value** is 2.21e-09, indicating **closeness_centrality** is statistically significant.

   - **betweenness_centrality**: The coefficient is **-1.384e+09**, meaning for each 1-unit increase in **betweenness_centrality**, the number of **views** decreases by 1.384 billion views. 
     - The **t-value** is -5.786, and the **p-value** is 7.30e-09, indicating **betweenness_centrality** is statistically significant.

### 4. **Interaction Terms**:
   - The interaction terms show how the relationship between **views** and the centrality measures changes depending on whether **mature** is 0 or 1.

   - **mature:degree_centrality**: The coefficient is **-7.455e+03**, meaning that the relationship between **degree_centrality** and **views** changes by **-7,455 views** when **mature** is 1, compared to when it is 0. 
     - The **t-value** is -5.666, and the **p-value** is 1.48e-08, indicating the interaction is statistically significant.

   - **mature:eigenvector_centrality**: The coefficient is **4.250e+07**, meaning the relationship between **eigenvector_centrality** and **views** changes by an increase of **42.5 million views** when **mature** is 1. 
     - The **t-value** is 4.831, and the **p-value** is 1.37e-06, indicating the interaction is statistically significant.

   - **mature:closeness_centrality**: The coefficient is **-8.293e+06**, meaning the relationship between **closeness_centrality** and **views** changes by a decrease of **8.293 million views** when **mature** is 1.
     - The **t-value** is -4.062, and the **p-value** is 4.88e-05, indicating the interaction is statistically significant.

   - **mature:betweenness_centrality**: The coefficient is **1.481e+09**, meaning the relationship between **betweenness_centrality** and **views** changes by an increase of **1.481 billion views** when **mature** is 1.
     - The **t-value** is 2.382, and the **p-value** is 0.017225, indicating the interaction is statistically significant.

### 5. **Model Fit**:
   - **Residual standard error**: The residual standard error is **2,937,000**, which is slightly lower than in the previous model, but still relatively high.
   
   - **Multiple R-squared**: The **R-squared** value is **0.003606**, which indicates that the model explains only **0.36%** of the variance in **views**. This is still very low, suggesting the model doesn't explain much of the variation in the data.
   
   - **Adjusted R-squared**: The **Adjusted R-squared** is **0.003261**, which adjusts the R-squared for the number of predictors, and remains low.

   - **F-statistic**: The **F-statistic** is **10.44** with **9** predictors and **25,951** degrees of freedom. The **p-value** is **2.844e-16**, indicating that at least one of the predictors (including interactions) is statistically significant in predicting **views**.

### Summary:
- The **interaction model** suggests that the relationship between **views** and centrality measures differs depending on whether **mature** is 0 or 1. 
- The interaction terms are statistically significant, indicating that the effect of centrality measures on **views** changes for the different levels of **mature**.
- However, like the previous model, the **R-squared** value is very low (0.36%), indicating that the model explains only a small portion of the variance in **views**.
- The model fits the data better than the previous one (with the lower residual standard error), but it still doesn't provide a strong explanation for **views**, suggesting that other factors may be influencing **views** beyond the predictors included in the model.

This model is more complex than the basic model because of the inclusion of interaction terms, but it still doesn't provide a strong explanatory power for the dependent variable.

Boxplot
This boxplot shows the distribution of view counts grouped by the maturity rating (0 and 1). Here's what can be interpreted from the graph:

1. **Median View Count**:
   - The thick horizontal line in each box represents the median view count.
   - It appears that users with a maturity rating of 1 have a higher median view count compared to those with a maturity rating of 0.

2. **Interquartile Range (IQR)**:
   - The height of each box represents the IQR (the range between the 25th and 75th percentiles).
   - The IQR for maturity rating 1 is slightly larger than that of 0, indicating a wider spread of typical view counts for mature-rated users.

3. **Outliers**:
   - The dots or vertical lines above the box represent outliers.
   - There are more extreme outliers (higher view counts) in both groups, but they seem more pronounced for maturity rating 1.

4. **Overall Spread**:
   - The whiskers (lines extending from the boxes) suggest that both groups have a wide range of view counts, but the range is slightly higher for users with maturity rating 1.

### What This Means:
- Users with a maturity rating of 1 generally seem to have higher view counts compared to users with a maturity rating of 0, based on the median and overall spread.
- However, there is significant overlap in the distributions, so maturity rating alone might not fully explain the difference in view counts. This would warrant further statistical analysis (e.g., a t-test or regression) to confirm the relationship.

Let me know if you'd like help analyzing this further!

Other Boxplot

This boxplot is similar to the previous one, but it appears to have capped the extreme outliers, which can provide a clearer view of the central tendencies and spreads of the data. Here's the interpretation:

1. **Comparison to the Previous Graph**:
   - By capping the outliers, this plot gives a more focused look at the typical view counts for each maturity rating.
   - The extreme points above the whiskers are reduced or removed, making it easier to compare the distributions.

2. **Median View Count**:
   - The median view count (thick horizontal line within each box) for maturity rating 1 (blue) remains higher than that for maturity rating 0 (red).

3. **Spread**:
   - The interquartile ranges (height of the boxes) still show that maturity rating 1 has a slightly wider spread in its view counts compared to rating 0.
   - The whiskers, which indicate the range of most data points, suggest that maturity rating 1 consistently includes higher view counts.

4. **Outlier Effect**:
   - By capping the outliers, this plot reduces the visual influence of extreme values, making it easier to observe the differences in typical (non-extreme) view counts between the two groups.

### What This Means:
This graph supports the hypothesis that users with maturity rating 1 generally tend to have higher view counts than those with maturity rating 0. It provides a more balanced representation by limiting the influence of outliers, which could skew the interpretation of the data. 

Would you like to compare these results with specific statistical measures (e.g., mean, median, variance)? Or would you like to explore another visualization?

Violin
This violin plot gives a detailed visual representation of the distribution of view counts for each maturity rating (0 and 1). Here's what it tells us:

1. **Shape of the Distributions**:
   - The width of the violins at each point represents the density of the data at that value.
   - Maturity rating 1 (blue) has a wider distribution at higher view counts, suggesting that users in this group are more likely to have a higher view count compared to maturity rating 0 (red).

2. **Peak Densities**:
   - Both ratings show peaks near the lower end of the view counts, meaning a significant number of users have lower view counts.
   - The distribution for maturity rating 1 extends higher, reinforcing the trend observed in previous plots.

3. **Outliers and Spread**:
   - The longer "tails" in both violins show the presence of users with very high view counts, but the violin plot effectively handles these without exaggeration, making it easier to understand the central trends.

4. **Comparison to Boxplot**:
   - Unlike the boxplot, this violin plot gives a sense of the overall shape and density of the data, rather than just summary statistics like median and interquartile range.

### Key Takeaways:
- Users with maturity rating 1 tend to have higher view counts on average and a wider spread in their distribution.
- While there is a concentration of lower view counts for both groups, maturity rating 1 is more likely to have users with significantly higher view counts.

This plot complements the boxplot and could be used alongside it to provide a richer analysis of the data. Would you like to dive deeper into specific density regions or explore other types of visualizations?