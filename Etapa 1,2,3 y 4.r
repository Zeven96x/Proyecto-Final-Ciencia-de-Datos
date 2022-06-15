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
library(ggplot)
library(ggthemes)
library(RWeka)
library(xlsx)



#ETAPA DE EXTRACCIón
#_________________________________________________________________________
consulta <- "news OR last minute OR reports OR announcement"
tweets <- search_tweets(consulta,
                        n = 1000,
                        include_rts = TRUE,
                        retryonratelimit = TRUE)



#Analisis pre-exploratorio
#_________________________________________________________________________

# a) Cantidad de filas y columnas
dim(tweets)

# b) nombres de las columnas y tipos de datos
names(tweets)
str(tweets)

# c) Gráfica de barra de noticias por región

newdata <- tweets
newdata <- newdata %>% filter(grepl("news", text))

# Filtramos por país y graficamos la cantidad de tweets por país
newdata %>%
  
  filter(location != "",!is.na(location)) %>%
  top_n(10) %>%
  ggplot() +
  geom_bar(aes(location)) +
  coord_flip() +
  labs(title = "Cantidad de tweets por país",
       x = "cantidad",
       y = "ubicación")

# d) 10 lugares más frecuentes
paises<- read_csv("topLocations.csv",col_names = c('id','pais','cantidad'))
paises <- transform(paises,cantidad = as.numeric(cantidad))
barplot(paises$cantidad,names.arg = paises$pais, horiz = TRUE)

#e)

tweets %>%
  top_n(5, followers_count) %>%
  arrange(desc(followers_count)) %>%
  select(screen_name, followers_count, location, created_at, quote_count)

tweets %>%
  top_n(5, followers_count) %>%
  ggplot() +
  geom_bar(aes(x = followers_count)) +
  coord_flip()



#Preprocesamiento de los datos
#_________________________________________________________________________

# Remueve espacios extra
newdata$text <- stripWhitespace(newdata$text)
# Remueve emoticones
newdata$text <- iconv(newdata$text, "latin1", "ASCII", sub = "")
# Remueve ligas o enlaces a otras páginas
newdata$text <- str_replace_all(newdata$text,"http\\S*", "")

# Transformar a mayúsculas
newdata$text <- toupper(newdata$text)
# Remueve puntuaciones
newdata$text <- removePunctuation(newdata$text)
# Expandir contracciones
newdata$text <- replace_contraction(newdata$text)
# Eliminación de stopword
newdata$text <- removeWords(newdata$text, stopwords('en'))
tweets$text[3]
newdata$text[3]
# tokenización
nuevo_texto <- str_split(newdata$text, " ")
#Preprocesamiento de los datos


#Etapa de visualización
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
#datos <- data.frame(newdata$user_id,newdata$created_at,newdata$screen_name,newdata$text,newdata$source,newdata$display_text_width,newdata$reply_to_status_id,newdata$reply_to_user_id,newdata$reply_to_screen_name,newdata$is_quote,newdata$is_retweet,newdata$favorite_count,newdata$quote_count,newdata$reply_count, newdata$location)

#write.csv(datos,"noticias.csv", row.names = FALSE)

newdata <- tweets
# Remueve espacios extra
newdata$location <- stripWhitespace(newdata$location)
# Remueve emoticones
newdata$location <- iconv(newdata$location, "latin1", "ASCII", sub = "")
# Remueve ligas o enlaces a otras páginas
newdata$location <- str_replace_all(newdata$location,"http\\S*", "")


write.csv(newdata$location,"locations.csv",row.names = FALSE)



