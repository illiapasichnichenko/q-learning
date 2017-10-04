# q-learning
## Overview
In this problem, we have a target and a shooter, each initialized in one of positions 1 ... N. The target is static, while the shooter can move left, move right or shoot. The shooter hits the target, if he shoots in the same position as the target, and misses otherwise. The goal is to teach the shooter to hit the target "without being explicitly programmed" to do that. 

This is achieved through multiple repetitions using reinforcement learning technique called Q-learning. First, a reward for each state-action pair is introduced. Here states are (target's position, shooter's position) pairs and actions are 'left', 'right', and 'shoot'. For example, the reward for 'shoot' in the state (2,2) should be greater than the reward for 'shoot' in the state (1,2). In fact, we distinguish only 3 types of state-action pairs, which are 'move' (actions 'left' and 'right' for each state), 'miss' (action 'shoot' when target's position is different from shooter's positions), and 'hit' (action 'shoot' when target's and shooter's positions are the same). Therefore, the reward function is defined by 3 numbers. Then through multiple repetitions, the agent learns Q function, which shows the quality of each state-action pair taking into account possible future rewards.

## Usage
You'll need the following packages: ggplot2, tibble, Rmisc, reshape2. To run the algorithm with N=3 and 100 episodes, use the following command `rscript qlearning.R 100 verbose`

After running the script you'll find a complete description of what was going on in log.txt. To get a better idea of how the Q function looks after a lot of training, run 1000 episodes and find Q function visualized in qvalues.png and learning curves in errors.png `rscript qlearning.R 1000`

Also, you may want to see average results for a number of simulations in av_errors.png after running `rscript av_qlearning.R`
