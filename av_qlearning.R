# run multiple instances to get average error for each episode number
source('base.R')
args = commandArgs(trailingOnly=TRUE)
if(length(args)==0){
  args[1] = 100
  args[2] = ""
} else if(length(args)==1) args[2] = ""
EPISODES = as.numeric(args[1])
VERBOSE = ifelse(args[2]=="verbose", T, F)
SIMULATIONS = 1000
errors_per_episode = matrix(nrow = EPISODES, ncol = SIMULATIONS)
rewards_per_episode = matrix(nrow = EPISODES, ncol = SIMULATIONS)
for(s in 1:SIMULATIONS){
  s_out = Qlearning()
  errors_per_episode[,s] = s_out$errors
  rewards_per_episode[,s] = s_out$total_rewards
}
av_results = tibble(errors = apply(errors_per_episode, 1, mean),
                    rewards = apply(rewards_per_episode, 1, mean))
p3 = ggplot(av_results, aes(x = 1:EPISODES, y = errors)) +
  geom_line() +
  labs(x = "Episode", y = "Average error (surplus steps)")
p4 = ggplot(av_results, aes(x = 1:EPISODES, y = rewards)) +
  geom_line() +
  labs(x = "Episode", y = "Average total rewards")
png("av_errors.png", width = 20, height = 10, units = "cm", res=300)
multiplot(p3, p4)
dev.off()