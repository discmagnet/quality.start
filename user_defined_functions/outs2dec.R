outs2dec <- function(IP){
  inn <- floor(IP) + 10*(IP-floor(IP))/3
  return(inn)
}