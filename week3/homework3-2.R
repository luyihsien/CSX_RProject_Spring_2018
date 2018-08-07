#TF-IDF_PCA_Kmeans

#setup
library(tm)
library(tmcn)
library(factoextra)
library(Matrix)
library(NLP)
#資料匯整
#將txt檔匯入成corpus檔
docs.corpus <- Corpus(DirSource("G:/Programming/homework/CS-X_106_Summer/week 2/TXT"))
#將corpus檔斷詞
docs.seg <- tm_map(docs.corpus, segmentCN) 
#將斷詞後的檔案轉成tdm檔
docs.tdm <- TermDocumentMatrix(docs.seg)

#計算TF值
docs.tf <- apply(as.matrix(docs.tdm), 2, function(word) { word/sum(word) })
#計算IDF值
idf_fun<- function(doc) {
  return ( log2(10/ nnzero(doc)) )
}
docs.idf <- apply(as.matrix(docs.tdm), 1, idf_fun)
#計算TF-IDF值
docs.tfidf <- docs.tf * docs.idf
docs.tfidf<- t(docs.tfidf)

#PCA
docs.pca <- prcomp(docs.tfidf)

#Drawing
fviz_eig(docs.pca)

fviz_pca_ind(docs.pca, geom.ind = c("point"), col.ind = "cos2")

fviz_pca_var(docs.pca, col.var = "contrib")

fviz_pca_biplot(docs.pca, geom.ind = "point")

#PCA results
docs.eig <- get_eig(docs.pca)
docs.var <- get_pca_var(docs.pca)
docs.ind <- get_pca_ind(docs.pca)

#Kmeans
ind.coord2 <- docs.ind$coord[1:10,]
wss <- c()
for (i in 1:10) { wss[i] <- kmeans(ind.coord2, i)$tot.withinss }
plot(wss, type = "b")

#Clustering
km <- kmeans(ind.coord2, 3)
plot(ind.coord2, col = km$cluster)
points(km$centers, col = 1:3, pch = 8, cex = 2)
