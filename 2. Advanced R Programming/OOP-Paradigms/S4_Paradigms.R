## S4 is more restrictive than S3
## Create a bus object class

setClass("bus_S4",
         slots = list(
           n_seats = "numeric",
           top_speed = "numeric",
           current_speed = "numeric",
           brand = "character"
         )
)

## Inheritance --> party bus

setClass("party_bus_S4",
         slots = list(
           n_subwoofers = "numeric",
           smoke_machine_on = "logical"
         ),
         contains = "bus_S4")

## Create instances

my_bus <- new("bus_S4",n_seats = 20,top_speed = 80,
              current_speed = 0,brand = "Volvo")
my_bus

## Create child instance

my_party_bus <- new("party_bus_S4",n_seats = 10,top_speed = 100,
                    current_speed = 0,brand = "Mercedes-Benz",
                    n_subwoofers = 2,smoke_machine_on = FALSE)
my_party_bus

## access slots

my_bus@n_seats
my_party_bus@top_speed

## Generic method system

setGeneric("is_bus_moving",function(x) {
  standardGeneric("is_bus_moving")
})

## set method

setMethod("is_bus_moving",c(x = "bus_S4"),
          function(x) {
            x@current_speed > 0
          })

is_bus_moving(my_bus) # FALSE
my_bus@current_speed <- 1
is_bus_moving(my_bus) # TRUE

## print is already a generic method no need to register

setMethod("print",c(x = "bus_S4"),
          function(x) {
            paste("This",x@brand,"bus is travelling at speed of",
                  x@current_speed)})

print(my_bus)
print(my_party_bus)
