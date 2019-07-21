#
# Mapa de 10.000 KM² de Rondonia
# Fonte: http://www.esa.int/spaceinimages/Images/2014/10/Proba-V_image_of_western_Brazil
#

install.packages("BiocManager")
BiocManager::install("EBImage")
library("EBImage")

sat_original <- readImage("D:\\rondonia.jpg") # Importanto Imagem do Satelite
#str(sat_original)
#display(sat_original)
#hist(sat_original)

sat_red <- imageData(channel(sat_original, mode="red")) # Seleciona o canl vermelho para destacar a area desmatada 
sat_red <- 1-sat_red  # Inverte a tonalidade
#hist(sat_red)
#display(sat_red)

sat_red[sat_red<0.5] <- 0
sat_red[sat_red>=0.5] <- 1
#display(sat_red)
sat_final <- bwlabel(sat_red)
kern <- makeBrush(3, shape="disc", step=FALSE) # Suavizar detalhes
sat_final <- erode(sat_final, kern) # Remover Ruidos
#display(sat_final)

detalhes <- computeFeatures.shape(sat_final)
area <- detalhes[, "s.area"]
area_desmatada = area/1000

write.table(area_desmatada, file = "area_desmatada.txt", col.names = "Area Desmatada em KM²")