library(tidyverse)
library(rtweet)
library(dplyr)

library(ggmap)
library(rjson)
library(MAP)
library(tidyverse)
library(rtweet)
library(wordcloud2)
library(qdap)
library(dplyr)
library(tm)
library(wordcloud)
library(plotrix)
library(dendextend)
library(ggplot2)
library(ggthemes)
library(RWeka)
library(xlsx)




#ETAPA DE EXTRACCI�n
#_________________________________________________________________________
consulta <- "news OR last minute OR reports OR announcement"
tweets <- search_tweets(consulta,
                        n = 1000,
                        include_rts = TRUE,
                        retryonratelimit = TRUE)


newdata <- tweets

#Analisis pre-exploratorio
#_________________________________________________________________________

# a) Cantidad de filas y columnas
dim(tweets)

# b) nombres de las columnas y tipos de datos
names(tweets)
str(tweets)

# c) Gr�fica de barra de noticias por regi�n


newdata <- newdata %>% filter(grepl("news", text))

# Filtramos por pa�s y graficamos la cantidad de tweets por pa�s
newdata %>%
  filter(location != "",!is.na(location)) %>%
  ggplot() +
  geom_bar(aes(location)) +
  coord_flip() +
  labs(title = "Cantidad de tweets por pa�s",
       x = "cantidad",
       y = "ubicaci�n")

# d) 10 lugares m�s frecuentes



#Preprocesamiento de los datos
#_________________________________________________________________________

# Remueve espacios extra
newdata$text <- stripWhitespace(newdata$text)
# Remueve emoticones
newdata$text <- iconv(newdata$text, "latin1", "ASCII", sub = "")
# Remueve ligas o enlaces a otras p�ginas
newdata$text <- str_replace_all(newdata$text,"http\\S*", "")

# Transformar a may�sculas
newdata$text <- toupper(newdata$text)
# Remueve puntuaciones
newdata$text <- removePunctuation(newdata$text)
# Expandir contracciones
newdata$text <- replace_contraction(newdata$text)
# Eliminaci�n de stopword
newdata$text <- removeWords(newdata$text, stopwords('en'))
tweets$text[3]
newdata$text[3]
# tokenizaci�n
nuevo_texto <- str_split(newdata$text, " ")
#Preprocesamiento de los datos


#Etapa de visualizaci�n
#_________________________________________________________________________
texto <- VectorSource(newdata$text)
texto <- VCorpus(texto)
texto <- TermDocumentMatrix(texto)
texto <- as.matrix(texto)
frecuencia <- rowSums(texto)
frecuencia <- sort(frecuencia, decreasing = T)
data <- data.frame(
  term = names(frecuencia),
  num = frecuencia
)
head(data,100)
purple_orange <- brewer.pal(10, "PuOr")
wordcloud(data$term, data$num, max.words = 100,
          colors = purple_orange)




# Guardado del data frame
datos <- data.frame(newdata$user_id,newdata$created_at,newdata$screen_name,newdata$text,newdata$source,newdata$display_text_width,newdata$reply_to_status_id,newdata$reply_to_user_id,newdata$reply_to_screen_name,newdata$is_quote,newdata$is_retweet,newdata$favorite_count,newdata$quote_count,newdata$reply_count, newdata$location)

write.csv(datos,"noticias.csv", row.names = FALSE)



