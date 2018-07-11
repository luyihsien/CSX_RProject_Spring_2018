library(ggplot2)
iris
ggplot(data = iris, aes(x =  Species)) +
  geom_bar(fill = "lightblue", colour = "black")
ggplot(data = iris, aes(x = Sepal.Length)) +
  geom_bar(fill = "lightblue", colour = "black")
ggplot(data = iris, aes(x = Sepal.Length,y=Sepal.Width)) +
  geom_point()
ggplot(data = iris, aes(x = Petal.Length ,y=Sepal.Width)) +
  geom_boxplot()