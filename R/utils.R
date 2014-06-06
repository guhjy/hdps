column_recurrence <- function(x) {
  quants <- quantile(x[x>0], probs=c(0.5, 0.75), names=FALSE)
  names(quants) <- c("_sporadic", "_frequent")
  if (quants[1]==quants[2]) quants <- quants[1]
  quants <- quants[quants != 1]
    
  mat <- matrix(0, length(x), length(quants) + 1)    
  colnames(mat) <- c("_once", names(quants))
  
  mat[, 1] <- x > 0
  if (length(quants) > 0) {
    colnames(mat)[-1] <- names(quants)
    for (i in 1:length(quants)) {
      mat[, i+1] <- x >= quants[i]
    }
  }
  
  unique(mat, MARGIN=2)
}

calc_rr_cd <- function(outcome, covar) {
  #returns rr_cd if rr_cd > 1, else returns 1/rr_cd
  #might return Inf if there are 0 outcomes at a particular level of the covar
  prevs <- by(outcome, covar, mean)
  rr_cd <- (prevs[1])/(prevs[2])
  max(rr_cd, 1/rr_cd)
}

check_inputs <- function(outcome, treatment, covars, covars_bin=FALSE) {
  n = nrow(covars)
  
  if (!length(outcome) == n || !length(treatment) == n)
    stop("outcome and treatment should be the same length, which should be equal to nrow(covars)")
  
  if (!all(outcome %in% c(0,1)))
    stop("outcome should be binary")
  if (!all(treatment %in% c(0,1)))
    stop("treatment should be binary")
  if (covars_bin && !all(covars %in% c(0,1)))
    stop("covars should be binary")
}