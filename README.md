# T2 - Limpieza y agregación con dplyr, análisis de ingreso por sector

Pregunta: ¿Existe una diferencia sistemática de ingreso entre sectores, y cuánto de esa diferencia se explica por el nivel educativo en lugar del sector mismo?
Respuesta: Sí existe una diferencia sistemática de ingresos entre sectores, observando resumen_sector se puede ver en Educación el ingreso promedio
           más alto ($908.857) y el más bajo en Agricultura ($447.846) teniendo una brecha de $461.011, esta diferencia se asocia parcialmente con el nivel educativo, 
           comparando con quiénes cumplen con educación superior la brecha entre Educación ($908.857) y Agricultura ($542.000) es de $366.857, es menor la brecha pero sigue siendo grande,
           con esto se observa que a pesar de tener un mismo nivel educativo el sector se asocia con un ingreso distinto.
           En cuánto a la limitación encontrada varias combinaciones sector x nivel_educ tienen muestras muy pequeñas (De N= 1 o N=2), esto hace que esos promedios sean poco confiables y limita que se analice con una mejor precisión.


## Datos
data/raw/casen_reducido.csv
data/raw/casen_ingresos.csv

## Cómo correrlo
Paso 1: Abrir .Rproj | Paso 2: Ejecutar scripts/tarea_t2.R

## Estructura
proyecto/
├── data/raw/
├── scripts/
└── README.md

## Autor
Paulina Longos Ulloa — 2026-09-22

## Declaración de autoría y uso de IA
- Herramienta utilizada: claude 
- Para qué la usé: entender errores, verificar que estén cumplidas las instrucciones y revisar redacción de mis interpretaciones.
- Qué hice yo: Escribí y verifique todo el código, fui anotando que se observaba en cada código e interpreté los resultados.
- Verificación: confirmo que entiendo y puedo explicar todo lo que entrego.



