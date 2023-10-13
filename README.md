# Obed Noe Martinez Gonzalez

## Descripción

Esta es una aplicación diseñada para permitir la monitorización de diversos valores de acciones en el mercado de valores. En la página principal, los usuarios pueden acceder a información general sobre las acciones. Al tocar una acción en particular, pueden profundizar para ver datos más específicos y una gráfica que ofrece una representación visual de los valores y su evolución en el tiempo.

Reglas de desarrollo
------
1. El proyecto en swift se creo usando un formato de archivos UpperCamelCase, por lo que nuevos archivos, deberan tener el mismo formato
2. El formato de variables es lowerCamelCase, tambien se debe de respetar
3. El código debe estar correctamente indentado. Para esto se pueden apoyar de los comandos:

 - ** 1.- cmd + A (Para seleccionar todo)**
 - ** 2.- ctrl + I (Para indentar)**
 
## Requisitos

- Swift 16.0 o superior
- Xcode 15.0 o superior (ya que es la version en la que se genero la app)

**Importante:**

   - Ten en cuenta que el consumo de los precios de cierre de las acciones en el índice está desactivado por defecto debido a limitaciones de peticiones. 
   - Si deseas habilitar esta función, descomenta la función `loadClosesPrices` y comenta la función `hideLoader`. Estas funciones se encuentran dentro de la función `loadTickers`.
