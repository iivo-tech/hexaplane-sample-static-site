# hexaplane-sample-static-site

Repositorio de prueba de Hexaplane. Un sitio estatico de una pagina, con lo
justo para ejercitar el build hermetico de punta a punta.

La imagen base viene de Docker Hub a proposito: el pod que construye no
alcanza internet, y que `FROM nginx:alpine` resuelva es lo que demuestra que
la reescritura de registro funciona.

No contiene nada de produccion.
