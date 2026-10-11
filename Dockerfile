# Sitio estatico minimo. Existe para ejercitar el pipeline de Hexaplane de
# punta a punta: clonado por el paso `fetch`, construido por Kaniko en el paso
# `build`, escaneado por Trivy en `scan`, firmado por cosign en `sign` y
# -desde SPEC-0011- desplegado en el namespace del tenant.
#
# SIN ROOT Y EN UN PUERTO NO PRIVILEGIADO, Y NO ES UNA PREFERENCIA DE ESTILO.
# El namespace del tenant aplica Pod Security `restricted` (REQ-0011): con
# runAsNonRoot el nginx de siempre no arranca, y sin CAP_NET_BIND_SERVICE
# nadie escucha en el puerto 80.
#
# LA VERSION ANTERIOR DE ESTE ARCHIVO ERA `FROM nginx:alpine` CON `EXPOSE 80`.
# Construia, escaneaba y firmaba sin un solo aviso, y NO SE PODIA DESPLEGAR:
# el sitio de demostracion de la plataforma no cumplia la postura de la
# plataforma, y eso no se noto hasta que hubo un paso que intentara arrancarlo.
# De ahi sale una restriccion de producto que conviene saber antes de traer una
# aplicacion aqui: la imagen de un tenant corre sin root y escucha por encima
# del 1024.
#
# LA BASE SIGUE SIENDO DE DOCKER HUB A PROPOSITO. El pod de build no alcanza
# internet: solo el Artifact Registry del proyecto. Que este `FROM` resuelva es
# lo que demuestra que la reescritura de registro de Kaniko funciona
# (--registry-map index.docker.io=<registro>/dockerhub-remote, SPEC-0007 4.5).
# Cambiarlo a Artifact Registry desactivaria esa demostracion sin que nada
# avisara.
#
# FIJADO POR DIGEST (REQ-0021): con una etiqueta movil, dos builds del mismo
# commit producen imagenes distintas y el digest deja de identificar al codigo.
FROM nginxinc/nginx-unprivileged:1.29-alpine@sha256:0c79d56aee561a1d81c63f00eee5fb5fe29279560cdc55e91425133104c7fbe6
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 8080

# RAMA rollout-never-ready: EL CONTENEDOR ARRANCA Y NUNCA ABRE EL PUERTO. Es el
# Build que construye, se escanea y se firma bien y despliega algo que no
# arranca, y lo usa la prueba de REQ-0055 en Hexaplane (tests/conformance/
# app_rollout_test.go): lo que estaba en vivo tiene que seguir sirviendo. El
# bucle, y no `sleep infinity`, porque no todas las versiones de busybox lo
# admiten.
CMD ["/bin/sh", "-c", "while true; do sleep 3600; done"]
