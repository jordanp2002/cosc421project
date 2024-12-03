Does maturity rating have an affect on a user’s view count?

To answer that question, I will perform data cleaning and preprocessing:
Handle missing data.
Encode the maturity rating as a binary variable.
and also

Conduct statistical analysis:
Use t.test() for differences in means of view counts by maturity rating.
Build a regression model (lm or glm) to study the relationship.

Data Requirements:

Include centrality metrics as explanatory variables (e.g., degree centrality, eigenvector centrality, closeness centrality).
Ensure maturity_rating and view_count are included.
Hypothesis:

Null Hypothesis: Centrality measures and maturity rating do not significantly affect view count.
Alternative Hypothesis: Centrality measures and maturity rating significantly influence view count.
Statistical Approach:

Use a linear regression model with interaction terms between maturity rating and centrality measures to study their combined effects on view count.
Model Interpretation:

Analyze how centrality measures modify the impact of maturity rating on view count.
