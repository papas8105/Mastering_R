## Reference Class
## Encapsulated Classes Python Style

Student <- setRefClass("Student",
  fields = list(name      = 'character',
                grad_year = 'numeric',
                credits   = 'numeric',
                id        = 'character',
                courses   = 'list'),
  methods = list(
    hello = function() {
      paste("Hi! My name is",name)
    },
    add_credits = function(n) {
      credits <<- credits + n
    },
    get_email = function() {
      paste0(id,"@jhu.edu")
    })
)

## Create two instances

brooke <- Student$new(name = "Brooke", 
                      grad_year = 2019,
                      credits = 40,
                      id = "ba123", 
                      courses = list("Ecology", "Calculus III"))
roger <- Student$new(name = "Roger", 
                     grad_year = 2020, 
                     credits = 10,
                     id  = "rp456", 
                     courses = list("Puppetry", "Elementary Algebra"))

## Access Fields

brooke$credits
roger$hello()
roger$get_email()
brooke$add_credits(4)
brooke$credits

## Inheritance

Grad_Student <- setRefClass("Grad_Student",
                            contains = "Student",
                            fields = list(thesis_topic = "character"),
                            methods = list(
                              defend = function() {
                                paste0(thesis_topic, ". QED.")
                              }
                            ))

## Create Instance

jeff <- Grad_Student$new(name = "Jeff", 
                         grad_year = 2021, 
                         credits = 8,
                         id = "jl55", 
                         courses = list("Fitbit Repair", 
                                        "Advanced Base Graphics"),
                         thesis_topic = "Batch Effects")

jeff$defend()