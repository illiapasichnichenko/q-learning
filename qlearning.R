# run an instance of Q-learning
source('base.R')
args = commandArgs(trailingOnly=TRUE)
if(length(args)==0){
  args[1] = 100
  args[2] = ""
} else if(length(args)==1) args[2] = ""
EPISODES = args[1]
VERBOSE = ifelse(args[2]=="verbose", T, F)
s_out = Qlearning()
results = tibble(errors = s_out$errors,
                 rewards = s_out$total_rewards)

# plot errors and rewards
p1 = ggplot(results, aes(x = 1:EPISODES, y = errors)) +
  geom_line() +
  labs(x = "Episode", y = "Error (surplus steps)")
p2 = ggplot(results, aes(x = 1:EPISODES, y = rewards)) +
  geom_line() + 
  labs(x = "Episode", y = "Total rewards")
png("errors.png", width = 20, height = 10, units = "cm", res=300)
multiplot(p1, p2)
dev.off()

# plot Q values
Q_tbl = melt(s_out$Q)
names(Q_tbl) = c('target', 'shooter', 'action', 'qvalue')
Q_tbl[1:3] = lapply(Q_tbl[1:3], as.factor)
levels(Q_tbl$action) = c('move left', 'move rigth', 'shoot')
png("qvalues.png", width = 20, height = 10, units = "cm", res=300)
ggplot(Q_tbl, aes(y=target,x=shooter)) +
  geom_raster(aes(fill=qvalue)) + 
  scale_fill_gradient(low="white", high="red") +
  facet_wrap(~action) +
  ggtitle('Q values') +
  theme(plot.title=element_text(size=11, hjust = 0.5))
dev.off()