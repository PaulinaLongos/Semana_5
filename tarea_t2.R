# Autor: Paulina Longos Ulloa
# Fecha: 2026-09-22
# Qué hace: Desarrollo tarea semana 5 con objetivo de responder una **pregunta económica propia** usando los cinco verbos de dplyr y`group_by()`, y **explicar en palabras** lo que muestran los números.

library(dplyr)

# 1. Declara tu pregunta
# Pregunta: ¿Existe una diferencia sistemática de ingreso entre sectores, y cuánto de esa diferencia se explica por el nivel educativo en lugar del sector mismo?

# 2. Carga y explora
casen    <- read.csv("data/raw/casen_reducido.csv")   # desde la raíz del proyecto
ingresos <- read.csv("data/raw/casen_ingresos.csv")   # base de apoyo (punto 2b)

str(casen) # 60 obs de 6 variables, region (chr), sector (chr), educ (int), edad (int), ingreso (int), genero (chr).
str(ingresos) # 60 obs de 10 variables; region (chr), sector (chr), educ (int), edad (int), genero (chr), horas (int), ing_trabajo (num), ing_capital (int), ing_subsidios (int), ing_total (int).
sum(is.na(casen$ingreso)) # Muestra 5 NA en ingreso

# 2b. Elige columnas por patrón
 
names(select(ingresos, starts_with("ing")))   # por el NOMBRE  -> 4 columnas
names(select(ingresos, where(is.numeric)))    # por el TIPO    -> 7 columnas

# ¿Por qué no devuelven el mismo resultado? Porque el primero esta aplicando un filtro para identificar los que comienzan con "ing" y el segundo esta filtrando solo por el tipo, en este caso numeric.
# ¿Por qué suma educ, edad y horas? Estas son numéricas pero no están relacionadas con ingresos, si elijo eequivocadamente calcularía sobre columnas que no corresponden a mi pregunta.

# 3. Usa los cinco verbos — al menos una vez cada uno

casen_filtrado <- filter(casen, !is.na(ingreso) & edad >= 18) # 55 obs de 6 variables.
casen_select   <- select(casen_filtrado, sector, educ, edad, ingreso) # 55 obs de 4 variables: sector, educ, edad, ingreso.
casen_mutate   <- mutate(casen_select, experiencia = pmax(edad - educ - 6, 0)) # 55 obs de 5 variables: se agrega experiencia (num). 
casen_arrange  <- arrange(casen_mutate, sector, ingreso) # 55 obs de 5 variables, se ven los ingresos por cada sector.

# 3b. Clasifica con `case_when()`

casen_final <- mutate(casen_arrange,
                      nivel_educ = case_when(
                        educ <  12 ~ "Sin media completa",
                        educ == 12 ~ "Media completa",
                        TRUE       ~ "Superior"
                      ))
table(casen_final$nivel_educ, useNA = "ifany") # Se ve Media completa (7), Sin media completa (21), Superior (27).

# 4. Agrega con `group_by()`
# **(a) Dos agregaciones con `summarise()`**, que colapsan a una tabla de grupos:
# - una por **un** grupo (ej. por `sector`),
resumen_sector <- casen_final |>
  group_by(sector) |>
  summarise(
    ingreso_prom = mean(ingreso, na.rm = TRUE), 
    N = n ()
  ) # Se ve 6 obs de 3 variables: sector, ingreso_prom, N.

# - una por **dos** grupos cruzados (ej. `sector` × `genero`).
resumen_sector_educ <- casen_final |>
  group_by(sector, nivel_educ) |>
  summarise(
    ingreso_prom = mean(ingreso, na.rm = TRUE), 
    N = n ()
    ) # Se ve 16 obs de 4 variables: sector, nivel_educ, ingreso_prom, N.

# **(b) Una comparación con `group_by()` + `mutate()`**, que conserva las filas: sitúa a cada persona respecto del promedio de su propio grupo.
casen_brecha <- casen_final |>
  group_by(sector) |>
  mutate(brecha = ingreso - mean(ingreso, na.rm = TRUE)) |>
  ungroup()
# ¿Qué responde esto que `summarise()` no puede responder? 
# Esto responde con más información (con mutate se ven 55 obs y por cada persona se ve la brecha con respecto al promedio de su porpio grupo) incluyendo los ingresos y las brechas más específicas, en cambio con summarise solo muestra un promedio por sector.

# 5. Trata los `NA` explícitamente

mean(casen$ingreso)                 # Sin na.rm
mean(casen$ingreso, na.rm = TRUE)   # Con na.rm

# ¿Cuántos casos pierdes y por qué es (o no es) aceptable perderlos?
# Antes con sum(is.na(casen$ingreso)) nos decia que existían 5 NA en ingreso, serían 5 de 60 que no se muestran con ingresos, con mean(casen$ingreso) me da NA lo que explica que un dato que falta no permite que se calcule el promedio,
# con mean(casen$ingreso, na.rm = TRUE) si se puede calcular usando las 55 obs en donde me da 655290.9.
# Creo que no es del todo aceptable perderlos porque al ser una muestra pequeña representa un problema para verificar si es confiable el análisis del caso.

# 6. Encadena con el pipe

casen_brecha <- casen_final |>
  group_by(sector) |>
  mutate(brecha = ingreso - mean(ingreso, na.rm = TRUE)) |>
  ungroup()

# 7. Interpreta (esto es lo que más pesa)
# Mi pregunta: ¿Existe una diferencia sistemática de ingreso entre sectores, y cuánto de esa diferencia se explica por el nivel educativo en lugar del sector mismo?

# Sí existe una diferencia sistemática de ingresos entre sectores, observando resumen_sector se puede ver en Educación el ingreso promedio
# más alto ($908.857) y el más bajo en Agricultura ($447.846) teniendo una brecha de $461.011, esta diferencia se asocia parcialmente con el nivel educativo, 
# comparando con quiénes cumplen con educación superior la brecha entre Educación ($908.857) y Agricultura ($542.000) es de $366.857, es menor la brecha pero sigue siendo grande,
# con esto se observa que a pesar de tener un mismo nivel educativo el sector se asocia con un ingreso distinto.
# En cuánto a la limitación encontrada varias combinaciones sector x nivel_educ tienen muestras muy pequeñas (De N= 1 o N=2), esto hace que esos promedios sean poco confiables y limita que se analice con una mejor precisión.
