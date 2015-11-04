getEdges = function(symadj){
  # Function devised for mutual information algorithms like aracne, clr, mrnet
  # symadj is symmetric adjacency matrix where the cells show the strength of the relationship  
  symadj[lower.tri(symadj,diag=TRUE)]=0
  res = cbind(which(symadj >0,arr.ind=TRUE),value=symadj[symadj > 0])
  int = res[order(abs(res[,3]),decreasing=TRUE),]
  return(int)
}#end function

########################################################################

mylars.vLambda = function (X, y,lambda = 0.01, use.Gram = TRUE, normalize = TRUE) 
{
  x <- X
  n <- length(y)
  if (use.Gram == TRUE) {
    type = "covariance"
  }
  if (use.Gram == FALSE) {
    type = "naive"
  }
  globalfit <- glmnet(x, y, family = "gaussian", lambda = lambda, standardize = normalize, type.gaussian = type)
  coefficients = predict(globalfit, type = "coefficients",s = lambda)
  intercept = coefficients[1]
  coefficients = coefficients[-1]
  names(coefficients) = 1:ncol(X)
  object <- list(lambda = lambda,intercept = intercept, coefficients = coefficients)
  invisible(object)
}#end function

########################################################################

lasso.net.vLambda = function (X, lambda = 0.01, use.Gram = FALSE, verbose = FALSE) 
{
  p <- ncol(X)
  X <- scale(X)
  colnames(X) <- 1:p
  B <- matrix(0, nrow = p, ncol = p)
  colnames(B) <- 1:p
  if (verbose == TRUE) {
    cat(paste("Performing local lasso regressions\n"))
    cat(paste("Vertex no "))
  }
  for (i in 1:p) {
    if (verbose == TRUE) {
      if ((i/10) == floor(i/10)) {
        cat(paste(i, "..."))
      }
    }
    noti <- (1:p)[-i]
    yi <- X[, i]
    Xi <- X[, noti]
    dummy <- mylars.vLambda(Xi, yi,lambda = lambda, use.Gram = use.Gram,normalize=TRUE)
    coefi <- dummy$coefficients
    B[i, -i] <- coefi
  }
  pcor <- Beta2parcor(B, verbose = verbose)
  cat(paste("\n"))
  return(list(pcor = pcor,lambda=dummy$lambda))
}#end function

########################################################################
ridge.net.vLambda = function (X, lambda = NULL, countLambda=500, plot.it = FALSE, scale = TRUE, k = 10, verbose = FALSE) 
{
  if (is.null(lambda) == TRUE) {
    ss <- seq(-10, -1, length = countLambda)
    ss <- 10^ss
    n <- nrow(X)
    nn <- n - floor(n/k)
    lambda <- ss * nn * ncol(X)
  }
  n <- nrow(X)
  p <- ncol(X)
  X <- scale(X, scale = scale)
  B <- matrix(0, nrow = p, ncol = p)
  lambda.opt <- rep(0, p)
  cat(paste("Performing local ridge regressions\n"))
  cat(paste("Vertex no "))
  for (i in 1:p) {
    if ((i/10) == floor(i/10)) {
      cat(paste(i, "..."))
    }
    noti <- (1:p)[-i]
    yi <- X[, i]
    Xi <- X[, noti]
    r.cv = ridge.cv(Xi, yi, lambda = lambda, scale = scale, 
                    plot.it = plot.it, k = k)
    B[i, -i] = r.cv$coefficients
    lambda.opt[i] = r.cv$lambda.opt
  }
  pcor <- Beta2parcor(B, verbose = verbose)
  return(list(pcor = pcor))
}
########################################################################

########################################################################
extract.network.vY = function (network.all, method = c("prob", "qval", "number","pval"),cutoff = 0.8, verbose = FALSE) 
{
  method = match.arg(method)

  if (method == "prob") {
    if (cutoff < 0 | cutoff > 1) 
      stop("edges: cutoff for prob must be between 0 and 1")
    edges = network.all[network.all$prob > cutoff, ]
  }
  else if (method == "qval") {
    if (cutoff < 0 | cutoff > 1) 
      stop("edges: cutoff for qval must be between 0 and 1")
    edges = network.all[network.all$qval < cutoff, ]
  }
  else if (method == "number") {
    if (cutoff%%1 != 0) 
      stop("edges: cutoff for \"number\" must be integer")
    edges = network.all[1:cutoff, ]
  }
  else if (method == "pval") {
    if (cutoff < 0 | cutoff > 1) 
      stop("edges: cutoff for pval must be between 0 and 1")
    edges = network.all[network.all$pval < cutoff, ]
  }
  
  if (verbose == TRUE) {
    cat("\nSignificant edges: ", nrow(edges), "\n")
    cat("    Corresponding to ", round(nrow(edges)/nrow(network.all), 
                                       4) * 100, "%  of possible edges \n")
  }
  network = edges

  return(network)
}# end function

################################################
# Find number of triangles
################################################
numTriangle = function(edges,prots){
  
  edgelist = cbind(prots[edges[,1]],prots[edges[,2]])
  net = network(edgelist,directed=FALSE,loops=F,multiple=F)
  x = as.matrix.network(net, matrix.type = "adjacency")
  insert = c()
  
  for(i in 1:ncol(x)){
    #print(i)
    dist1n = which(x[,i]==1)
    len = length(dist1n)
    dist2n = vector("list",len)
    for(j in 1:len){
      dist2n[[j]] = which(x[,dist1n[j]]==1)
      
      thisLen = length(dist2n[[j]])
      
      triangleInd = dist2n[[j]][which(x[i,dist2n[[j]]]==1)]
      # Merge i and dist1n[j] and each member of triangleInd
      if(length(triangleInd) > 0){
        for(k in 1:length(triangleInd)){
          sorted = sort(c(i,dist1n[j],triangleInd[k]))
          insert = rbind(insert,paste(sorted,collapse="."))
        }#end for k
      }#end if
      
    }#end for j
    
  }#end for i
  
  uniqueInsert = unique(insert)
  return(nrow(uniqueInsert))
}#end function

################################################
# 
################################################
plot.network.sequence = function(networkList,from,to,prots,colind,colorNums,algoName,versionName,doEdge=TRUE,doNode=TRUE){
  
  for(i in from:to){
    print(i)
    # ALL SAMPLES
    edges = networkList[[i]]
    edgelist = cbind(prots[edges[,1]],prots[edges[,2]])
    edgewid = 30 * abs(edges[,3])
    edgecol = ifelse(sign(edges[,3]) > 0,2,4)
    net = network(edgelist,directed=FALSE,loops=F,multiple=F)
    x = as.matrix.network(net, matrix.type = "adjacency")
    vertexSize = log(apply(x,2,sum)) + 0.5
    vertexColors = colind[colorNums[match(colnames(x),prots)]]
    
    coords = NA
    
    if(doEdge){
      # Edge-coloring
      pdf(paste("edgeColor_noText_",algoName,"_vRPPA_ovca_",versionName,"_cutoff",i,".pdf",sep=""))
      coords = plot.network(net,displaylabels=F,label.pad=0.5,label.cex=0.5,edge.lwd=edgewid,edge.col=edgecol,
                            vertex.col=colors()[230],vertex.border=1,pad=0,vertex.cex=vertexSize)
      dev.off()
      
      pdf(paste("edgeColor_Text_",algoName,"_vRPPA_ovca_",versionName,"_cutoff",i,".pdf",sep=""))
      plot.network(net,coord=coords,displaylabels=T,label.pad=0.5,label.cex=0.7,edge.lwd=edgewid,edge.col=edgecol,
                   vertex.col=colors()[230],vertex.border=0,pad=0,vertex.cex=vertexSize)
      dev.off()
    }#end if
    
    if(doNode){
      # Node-coloring
      pdf(paste("nodeColor_noText_",algoName,"_vRPPA_ovca_",versionName,"_cutoff",i,".pdf",sep=""))
      if(is.na(coords)){
        coords = plot.network(net,coord=coords,displaylabels=F,label.pad=0.5,label.cex=0.5,edge.lwd=edgewid,edge.col="gray",
                              vertex.col=vertexColors,vertex.border=1,pad=0,vertex.cex=vertexSize) 
      }else{
        plot.network(net,coord=coords,displaylabels=F,label.pad=0.5,label.cex=0.5,edge.lwd=edgewid,edge.col="gray",
                     vertex.col=vertexColors,vertex.border=1,pad=0,vertex.cex=vertexSize)
      }
      dev.off()
      
      pdf(paste("nodeColor_Text_",algoName,"_vRPPA_ovca_",versionName,"_cutoff",i,".pdf",sep=""))
      plot.network(net,coord=coords,displaylabels=T,label.pad=0.5,label.cex=0.7,edge.lwd=edgewid,edge.col="gray",
                   vertex.col=vertexColors,vertex.border=0,pad=0,vertex.cex=vertexSize)
      dev.off()
    }#end if
  }#end for
  
}#end function

################################################
# 
################################################
plot.network.custom.color = function(edges,prots,algoName,versionName,i,networkObj=NA,edgeCol=NA,vertexCol=NA,doEdge=FALSE,doNode=FALSE){
  # Edgelist with protein names, and edge widths
  edgelist = cbind(prots[edges[,1]],prots[edges[,2]])
  edgewid = 30 * abs(edges[,3])
  
  # Default network object
  net = networkObj
  if(is.na(net)){
    net = network(edgelist,directed=FALSE,loops=F,multiple=F)
  }
  
  # Adjacency matrix
  x = as.matrix.network(net, matrix.type = "adjacency")
  vertexSize = log(apply(x,2,sum)) + 0.5
  
  # Default edge color
  if(is.na(edgeCol[1])){
    edgeCol = ifelse(sign(edges[,3]) > 0,2,4)
  }
  
  # Default vertex color
  if(is.na(vertexCol[1])){
    vertexCol = colind[colorNums[match(colnames(x),prots)]]
  }
  
  coords = NA
  
  if(doEdge){
    # Edge-coloring
    pdf(paste("edgeColor_noText_",algoName,"_ovca_",versionName,"_cutoff",i,".pdf",sep=""))
    coords = plot.network(net,displaylabels=F,label.pad=0.5,label.cex=0.5,edge.lwd=edgewid,edge.col=edgeCol,
                          vertex.col=colors()[230],vertex.border=1,pad=0,vertex.cex=vertexSize)
    dev.off()
    
    pdf(paste("edgeColor_Text_",algoName,"_ovca_",versionName,"_cutoff",i,".pdf",sep=""))
    plot.network(net,coord=coords,displaylabels=T,label.pad=0.5,label.cex=0.7,edge.lwd=edgewid,edge.col=edgeCol,
                 vertex.col=colors()[230],vertex.border=0,pad=0,vertex.cex=vertexSize)
    dev.off()
  }#end if
  
  if(doNode){
    # Node-coloring
    pdf(paste("nodeColor_noText_",algoName,"_ovca_",versionName,"_cutoff",i,".pdf",sep=""))
    if(is.na(coords)){
      coords = plot.network(net,coord=coords,displaylabels=F,label.pad=0.5,label.cex=0.5,edge.lwd=edgewid,edge.col="gray",
                            vertex.col=vertexCol,vertex.border=1,pad=0,vertex.cex=vertexSize) 
    }else{
      plot.network(net,coord=coords,displaylabels=F,label.pad=0.5,label.cex=0.5,edge.lwd=edgewid,edge.col="gray",
                   vertex.col=vertexCol,vertex.border=1,pad=0,vertex.cex=vertexSize)
    }
    dev.off()
    
    pdf(paste("nodeColor_Text_",algoName,"_ovca_",versionName,"_cutoff",i,".pdf",sep=""))
    plot.network(net,coord=coords,displaylabels=T,label.pad=0.5,label.cex=0.7,edge.lwd=edgewid,edge.col="gray",
                 vertex.col=vertexColors,vertex.border=0,pad=0,vertex.cex=vertexSize)
    dev.off()
  }#end if
}#end function


makeTransparent = function(someColor, alpha=100)
{
  #note: always pass alpha on the 0-255 scale
  newColor<-col2rgb(someColor)
  apply(newColor, 2, function(curcoldata){rgb(red=curcoldata[1], green=curcoldata[2],
                                              blue=curcoldata[3],alpha=alpha, maxColorValue=255)})
}

ridge.net.vRPPA = function (X, genelist, lambda = NULL, plot.it = FALSE, scale = TRUE, k = 10, verbose = FALSE) 
{
  if (is.null(lambda) == TRUE) {
    ss <- seq(-10, -1, length = 1000)
    ss <- 10^ss
    n <- nrow(X)
    nn <- n - floor(n/k)
    lambda <- ss * nn * ncol(X)
  }
  n <- nrow(X)
  p <- ncol(X)
  X <- scale(X, scale = scale)
  B <- matrix(0, nrow = p, ncol = p)
  lambda.opt <- rep(0, p)
  cat(paste("Performing local ridge regressions\n"))
  cat(paste("Vertex no "))
  for (i in 1:p) {
    if ((i/10) == floor(i/10)) {
      cat(paste(i, "..."))
    }
    removeInd = which(genelist==genelist[i])
    Xi = X[, -removeInd]
    yi = X[, i]
    r.cv = ridge.cv(Xi, yi, lambda = lambda, scale = scale, 
                    plot.it = plot.it, k = k)
    B[i, -removeInd] = r.cv$coefficients
    lambda.opt[i] = r.cv$lambda.opt
  }
  pcor <- Beta2parcor(B, verbose = verbose)
  return(list(pcor = pcor))
}

pls.net.vRPPA = function (X, genelist, scale = TRUE, k = 10, ncomp = 15, verbose = FALSE) 
{
  p = ncol(X)
  n = nrow(X)
  genelist = as.character(genelist)
  if (is.null(ncomp)) {
    ncomp = min(n - 1, ncol(X))
  }
  k = floor(k)
  k = max(1, k)
  if (k > n) {
    cat(paste("k exceeds the number of observations. Leave-one-out is applied.\n"))
    k = n
  }
  B = matrix(0, p, p)
  m = vector(length = p)
  cat(paste("Performing local pls regressions\n"))
  kernel = FALSE
  if (n < (p - 1)) {
    kernel = TRUE
  }
  cat(paste("Vertex no "))
  for (i in 1:p) {
    if ((i/10) == floor(i/10)) {
      cat(paste(i, "..."))
    }
    removeInd = which(genelist==genelist[i])
    Xi = X[, -removeInd]
    yi = X[, i]
    fit = penalized.pls.cv(Xi, yi, scale = scale, k = k,ncomp = ncomp)
    B[i, -removeInd] = fit$coefficients
    m[i] = fit$ncomp.opt
  }
  cat(paste("\n"))
  pcor <- Beta2parcor(B, verbose = verbose)
  return(list(pcor = pcor, m = m))
}# end function 

edge2dist = function(edgelist,prots,method="jac"){
  edges = as.matrix(edgelist[,1:2])
  adjmat = matrix(0,nrow=length(prots),ncol=length(prots))
  adjmat[edges] = 1
  adjmat[edges[,2:1]]=1
  colnames(adjmat) = rownames(adjmat) = prots
  diag(adjmat) = 1
  d = vegdist(t(adjmat),method=method)
  return(d)
}#end function


plotMDS = function(edgelist,prots,filename,colvec=NA){
  
  edges = as.matrix(edgelist[,1:2])
  adjmat = matrix(0,nrow=length(prots),ncol=length(prots))
  adjmat[edges] = 1
  adjmat[edges[,2:1]]=1
  colnames(adjmat) = rownames(adjmat) = prots
  
  #### set the diagonal equal to 1 so that an edge between node X and Y will count for the similarity computation b/w X and Y
  diag(adjmat) = 1
  
  ####
  d = vegdist(t(adjmat),method="jac")
  mds = cmdscale(d,k=3,eig=TRUE)
  
  xmax = max(abs(mds$points[,1]))
  ymax = max(abs(mds$points[,2]))
  
  x.ind = 1:length(prots)
  
  ### Text version
  pdf(filename)
  par(mai=c(0.52,0.52,0.52,0.22))
  par(mfrow=c(2,2))
  
  plot(0,0,type="n",xlab="dimension 1",ylab="dimension 2",xlim=c(-xmax,xmax),ylim=c(-ymax,ymax),col=colind[colorNums],main="x=dim1, y=dim2")
  if(any(is.na(colvec))){
    text(mds$points[x.ind,1],mds$points[x.ind,2],labels=prots,font=2,cex=0.5)
  }else{
    text(mds$points[x.ind,1],mds$points[x.ind,2],labels=prots,font=2,cex=0.5,col=colvec)
  }#end if-else
  
  plot(0,0,type="n",xlab="dimension 1",ylab="dimension 3",xlim=c(-xmax,xmax),ylim=c(-ymax,ymax),col=colind[colorNums],main="x=dim1, y=dim3")
  if(any(is.na(colvec))){
    text(mds$points[x.ind,1],mds$points[x.ind,3],labels=prots,font=2,cex=0.5)
  }else{
    text(mds$points[x.ind,1],mds$points[x.ind,3],labels=prots,font=2,cex=0.5,col=colvec)
  }#end if-else
  
  plot(0,0,type="n",xlab="dimension 2",ylab="dimension 3",xlim=c(-xmax,xmax),ylim=c(-ymax,ymax),col=colind[colorNums],main="x=dim2, y=dim3")
  if(any(is.na(colvec))){
    text(mds$points[x.ind,2],mds$points[x.ind,3],labels=prots,font=2,cex=0.5)
  }else{
    text(mds$points[x.ind,2],mds$points[x.ind,3],labels=prots,font=2,cex=0.5,col=colvec)
  }#end if-else
  dev.off()
}#end for function


plotMDS2 = function(edgelist,prots,filename,mult.ind=NA,labels=FALSE,labels.ind=FALSE,inColor="blue"){
  
  edges = as.matrix(edgelist[,1:2])
  adjmat = matrix(0,nrow=length(prots),ncol=length(prots))
  adjmat[edges] = 1
  adjmat[edges[,2:1]]=1
  colnames(adjmat) = rownames(adjmat) = prots
  
  #### set the diagonal equal to 1 so that an edge between node X and Y will count for the similarity computation b/w X and Y
  diag(adjmat) = 1
  
  ####
  d = vegdist(t(adjmat),method="jac")
  mds = cmdscale(d,k=3,eig=TRUE)
  
  xmax = max(abs(mds$points[,1]))
  ymax = max(abs(mds$points[,2]))
  zmax = max(abs(mds$points[,3]))
  
  x.ind = 1:length(prots)
  
  multTargetCol = rep("gray",length(prots))
  multTargetCol[mult.ind] = inColor
  
  tpos = 1
  tcex = 0.7
  tfont = 1
  
  ### points version
  pdf(filename)
  par(mai=c(0.52,0.52,0.52,0.22))
  par(mfrow=c(2,2))
  
  plot(0,0,type="n",xlab="dimension 1",ylab="dimension 2",xlim=c(-xmax,xmax),ylim=c(-ymax,ymax),col=colind[colorNums],main="x=dim1, y=dim2")
  if(any(is.na(mult.ind))){
    points(mds$points[x.ind,1],mds$points[x.ind,2],pch=16,cex=0.8)
  }else{
    points(mds$points[setdiff(x.ind,mult.ind),1],mds$points[setdiff(x.ind,mult.ind),2],pch=16,cex=0.8,col=multTargetCol[setdiff(x.ind,mult.ind)])
    points(mds$points[mult.ind,1],mds$points[mult.ind,2],pch=1,lwd=1,cex=1,col=inColor)
    if(labels[1] != FALSE){
      text(mds$points[labels.ind,1],mds$points[labels.ind,2],labels=labels,col=inColor,pos=tpos,cex=tcex,font=tfont)
    }
  }#end if-else
  
  plot(0,0,type="n",xlab="dimension 1",ylab="dimension 3",xlim=c(-xmax,xmax),ylim=c(-zmax,zmax),col=colind[colorNums],main="x=dim1, y=dim3")
  if(any(is.na(mult.ind))){
    points(mds$points[x.ind,1],mds$points[x.ind,3],pch=16,cex=0.8)
  }else{
    points(mds$points[setdiff(x.ind,mult.ind),1],mds$points[setdiff(x.ind,mult.ind),3],pch=16,cex=0.8,col=multTargetCol[setdiff(x.ind,mult.ind)])
    points(mds$points[mult.ind,1],mds$points[mult.ind,3],pch=1,lwd=1,cex=1,col=inColor)
    if(labels[1] != FALSE){
      text(mds$points[labels.ind,1],mds$points[labels.ind,3],labels=labels,col=inColor,pos=tpos,cex=tcex,font=tfont)
    }
  }#end if-else
  
  plot(0,0,type="n",xlab="dimension 2",ylab="dimension 3",xlim=c(-ymax,ymax),ylim=c(-zmax,zmax),col=colind[colorNums],main="x=dim2, y=dim3")
  if(any(is.na(mult.ind))){
    points(mds$points[x.ind,2],mds$points[x.ind,3],pch=16,cex=0.8)
  }else{
    points(mds$points[setdiff(x.ind,mult.ind),2],mds$points[setdiff(x.ind,mult.ind),3],pch=16,cex=0.8,col=multTargetCol[setdiff(x.ind,mult.ind)])
    points(mds$points[mult.ind,2],mds$points[mult.ind,3],pch=1,lwd=1,cex=1,col=inColor)
    if(labels[1] != FALSE){
      text(mds$points[labels.ind,2],mds$points[labels.ind,3],labels=labels,col=inColor,pos=tpos,cex=tcex,font=tfont)
    }
  }#end if-else
  dev.off()
}#end for function

getSevenNumPerfCustom = function(pred,trueInt,prots,lenCustomSet){
  num = nrow(pred)
  truth = apply(trueInt,1,paste,collapse=".")
  
  # convert numbers to antibody names
  nameMap = matrix(NA,nrow=num,ncol=2)
  nameMap[,1] = prots[pred[,1]]
  nameMap[,2] = prots[pred[,2]]
  
  predEdges.L2R = apply(nameMap,1,paste,collapse=".")
  # The below line does not work when there is only 1 edge
  if(nrow(nameMap) != 1){
    predEdges.R2L = apply(nameMap[,c(2,1)],1,paste,collapse=".")
  }else{
    predEdges.R2L = paste(rev(nameMap),collapse=".")
  }
  
  # match now
  matched1 = match(truth,predEdges.L2R)
  matched2 = match(truth,predEdges.R2L)
  
  TP = length(which(!is.na(matched1))) + length(which(!is.na(matched2)))
  FP = num - TP
  P = length(truth)
  FN = P - TP
  
  x = lenCustomSet
  allPossible = x * length(prots) - (x*(x+1)/2)
  N = allPossible - P
  TN = N - FP
  
  TPR = TP / P
  FPR = FP / N
  
  PPV = TP / (TP + FP)
  
  return(list(TP=TP,FP=FP,TN=TN,FN=FN,TPR=TPR,FPR=FPR,PPV=PPV))
}#end function



################################################################################################
performance.pcor.vY = function (inferred.pcor, true.pcor = NULL, fdr = TRUE, cutoff.ggm = 0.8, vSparse=FALSE,
                                verbose = FALSE, plot.it = FALSE) 
{
  p <- ncol(inferred.pcor)
  if (fdr) {
      test.results <- network.test.edges(inferred.pcor, verbose = verbose, plot = plot.it)
      prob.results <- diag(p)
      for (i in 1:length(test.results$prob)) {
        prob.results[test.results$node1[i], test.results$node2[i]] <- test.results$prob[i]
        prob.results[test.results$node2[i], test.results$node1[i]] <- test.results$prob[i]
        #dim(prob.results)
      }#end for i
      
      # vSparse=TRUE means "don't look at FDR, get the top X percent of the edges, where X is (1-cutoff.ggm)*100
      if(vSparse){
        numEdge = length(which(abs(test.results[,1]) > 0))
        ## Here, in the case of vSparse, cutoff.ggm means that you want the top (1-cutoff.ggm)*100% of the edges 
        cutoff.number = round((1-cutoff.ggm) * numEdge)
        if(cutoff.number > 0){
          net <- extract.network(test.results, method.ggm="number",cutoff.ggm = cutoff.number)
        }else{
          net <- test.results[NULL,]
        }
      }else{
        net <- extract.network(test.results,cutoff.ggm = cutoff.ggm) 
      }#end if-else
      
      num.selected = nrow(net)
      
      # adjacency matrix
      adj <- diag(p)
      if (num.selected != 0) {
        for (j in 1:num.selected) {
          adj[net[j, 2], net[j, 3]] <- 1
          adj[net[j, 3], net[j, 2]] <- 1
        }#end for
      }#end if 
      
  }else{
    
      # adjacency matrix
      adj <- inferred.pcor
      adj[adj != 0] <- 1
      
      # Edge-list
      symadj = inferred.pcor
      symadj[lower.tri(symadj,diag=TRUE)]=0
      res = cbind(pcor=symadj[symadj != 0],which(symadj != 0,arr.ind=TRUE))
      net = res[order(abs(res[,3]),decreasing=TRUE),]
      
      num.selected = nrow(net)
  }#end if-else fdr

  # How many neighbors does each node have, i.e connectivity
  connectivity <- apply(adj, 2, FUN = function(x) return(sum(x != 0))) - 1
  
  #num.selected <- (sum(abs(adj) > 0) - p)/2
  
  ## Percent of positive edges in the set of all selected edges
  positive.cor <- NULL
  if (num.selected > 0) {
      positive.cor <- sum(net[,1] > 0)/num.selected
  }
  
  num.true <- power <- ppv <- NULL
  if (!is.null(true.pcor)) {
    num.true <- (sum(abs(true.pcor) > 0) - p)/2
    num.true.positives <- (sum(abs(true.pcor * adj) > 0) - 
                             p)/2
    num.false.positives <- num.selected - num.true.positives
    power <- -Inf
    if (num.true > 0) {
      power <- num.true.positives/num.true
    }
    ppv <- -Inf
    if (num.selected > 0) {
      ppv <- num.true.positives/num.selected
    }
  }
  
  auc <- NA
  tpr <- fpr <- NA
  TPR <- FPR <- NA
  if (fdr & (!is.null(true.pcor))) {
    xx <- seq(0, 1, length = 500)
    true.binary = (abs(true.pcor) > 0)
    predicted <- sym2vec(prob.results)
    if (var(predicted) > 0) {
      if (plot.it == TRUE) {
        plot.roc = "ROC"
      }
      if (plot.it == FALSE) {
        plot.roc = NA
      }
      myroc <- ROC(predicted, sym2vec(true.binary), plot = plot.roc)
      auc <- myroc$AUC
      TPR <- myroc$res[, 1]
      FPR <- 1 - myroc$res[, 2]
    }
  }
  
  if (!is.null(true.pcor)) {
    tpr <- power
    if (num.true > 0) {
      fpr <- num.false.positives/((p^2 - p)/2 - num.true)
    }
  }
  
  return(list(num.selected = num.selected, power = power, TPR = TPR, 
              FPR = FPR, tpr = tpr, fpr = fpr, ppv = ppv, adj = adj, 
              connectivity = connectivity, positive.cor = positive.cor, 
              auc = auc,net=net))
}#end function
