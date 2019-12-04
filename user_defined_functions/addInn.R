addInn <- function(input){
  full_inn <- 0
  outs <- 0
  for (i in 1:length(input)){
    full_inn <- full_inn + sign(input[i])*floor(abs(input[i]))
    outs <- outs + 10*(abs(input[i]) - floor(abs(input[i])))*sign(input[i])
  }
  IP <- full_inn + floor(outs/3) + (outs %% 3)/10
  part_inn <- abs(IP) - floor(abs(IP))
  if(isTRUE(all.equal(part_inn,0.3))){
    IP = floor(IP) + 1
  } else if (isTRUE(all.equal(part_inn,0.9))){
    IP = floor(IP) + 0.8
  } else if (isTRUE(all.equal(part_inn,0.8))){
    IP = floor(IP) + 0.9
  } else if (isTRUE(all.equal(part_inn,0.7))){
    IP = floor(IP)
  }
  return(IP)
}