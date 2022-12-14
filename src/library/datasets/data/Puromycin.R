### Reaction rate versus concentration for samples treated with
### Puromycin or untreated.  Bates and Watts (1988), Appendix A1.3
"Puromycin" <-
  structure(list(
  conc = c(0.02, 0.02, 0.06, 0.06, 0.11, 0.11, 0.22, 0.22, 0.56,
    0.56, 1.1, 1.1, 0.02, 0.02, 0.06, 0.06, 0.11, 0.11, 0.22, 0.22,
    0.56, 0.56, 1.1),
vel = c(76, 47, 97, 107, 123, 139, 159, 152, 191, 201, 207, 200,
  67, 51, 84, 86, 98, 115, 131, 124, 144, 158, 160),
state = factor(c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 2L,
                 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L), levels = 1:2,
               labels = c("treated", "untreated"))),
names = c("conc", "rate", "state"),
row.names = 1:23,
class = "data.frame",
reference = "A1.3, p. 269")
