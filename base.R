library(ggplot2)
library(tibble)
library(Rmisc)
library(reshape2)

# Parameters
N = 3 # number of positions labeled 1 ... N
REWARDS = c(-1, -5, 10); # (move, miss, hit)
learningRate = 0.01
discountFactor = 1
MAX_STEPS = 1000
epsilonGreedyFlag = FALSE
epsilon = 0.05

actionNames = c("left", "right", "shoot")

Qlearning = function(){
  # Q-array: dim 1 and 2 - states, dim 3 - actions
  Q = array(rep(0, N*N*3), dim = c(N, N, 3)) 
  steps = rep(0, EPISODES)
  errors = rep(0, EPISODES)
  total_rewards = rep(0, EPISODES)
  if (file.exists("log.txt")) file.remove("log.txt")
  for(e in 1:EPISODES){ # run Q-learning
    y_init = sample(1:N, 1) # target's position
    x_init = sample(1:N, 1) # shooter's position
    if (VERBOSE) write(paste0("---------- Episode ",e," ----------"),file="log.txt",append=T)
    e_out = runEpisode(y_init, x_init, Q) # episode's output
    Q = e_out$Q
    steps[e] = e_out$steps
    errors[e] = e_out$error
    total_rewards[e] = e_out$reward
    if (VERBOSE){
      str = paste0("episode ",e,", error ",e_out$error,", reward ",e_out$reward)
      write(str,file="log.txt",append=T)
      write("Q values for action left",file="log.txt",append=T)
      write.table(round(Q[,,1],2),file="log.txt",row.names=F,col.names=F,append=T)
      write("Q values for action right",file="log.txt",append=T)
      write.table(round(Q[,,2],2),file="log.txt",row.names=F,col.names=F,append=T)
      write("Q values for action shoot",file="log.txt",append=T)
      write.table(round(Q[,,3],2),file="log.txt",row.names=F,col.names=F,append=T)
      print(str,quote=F)
    }
  }
  if(VERBOSE) print("see log.txt for complete log", quote=F)
  return(list(steps=steps,errors=errors,total_rewards=total_rewards,Q=Q))
}

runEpisode = function(y_init, x_init, Q){
  step = 0
  episodeEndFlag <<- FALSE
  reward_total = 0
  x = x_init
  y = y_init
  repeat{
    step = step + 1
    a = chooseAction(y, x, Q)
    a_out = runAction(y, x, a) # action's output
    Q[y, x, a] = updateQ(y, x, a_out$x, Q, a, a_out$r)
    if(VERBOSE) write(paste0("step ",step,", target ",y,
                             ", shooter ",x,", action ",actionNames[a],
                             ", reward ", a_out$r, ", q-value ", Q[y, x, a]),
                      file="log.txt",append=T)
    x = a_out$x
    reward_total = reward_total + a_out$r
    if(episodeEndFlag | step >= MAX_STEPS) break
  }
  steps_opt = min(abs(y_init-x_init), N - abs(y_init-x_init)) + 1
  return( list(steps=step, error=step-steps_opt, reward=reward_total, Q=Q) )
}

chooseAction = function(y, x, Q){
  if(epsilonGreedyFlag & runif(1) < epsilon) return(sample(1:3, 1))
  else return(which.max(Q[y, x, ]))
}

runAction = function(y, x, a){
  if(a == 1){
    r = REWARDS[1]
    x = (x - 1) - N*floor((x-2)/N)
  } else if(a == 2){
    r = REWARDS[1]
    x = (x + 1) - N*floor(x/N)
  } else if(a == 3 & y != x){
    r = REWARDS[2]
  } else if(a == 3 & y == x){
    r = REWARDS[3]
    episodeEndFlag <<- TRUE
  }
  return( list(x=x, r=as.numeric(r)) )
}

updateQ = function(y, x, x_new, Q, a, r){
  if(episodeEndFlag) return( Q[y, x, a] + learningRate*(r - Q[y, x, a]) ) 
  else return( Q[y, x, a] + learningRate*(r + discountFactor*max(Q[y, x_new, ]) - Q[y, x, a]) )
}
