################################################################################
# HANDS ON 1 - EXERCISE:
# CREATE THE CODE WITH EXPLANATIONS TO COMPUTE
# THE PROBABILITY OF GETTING
# - 10 or fewer successes
# - When throwing 100 dice,
# - And the success is getting a 6 in the dice
################################################################################
################################################################################

# We know the q, size and probability (only 1 face out of 6). 
# As the documentation said, we set lower.tail to TRUE to have P[X≤10]
E1 <- pbinom(q = 10, size = 100, prob = 1/6, lower.tail = TRUE)
E1
