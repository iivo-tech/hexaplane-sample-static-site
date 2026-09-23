# Sitio estatico minimo. Existe para ejercitar el build hermetico de Hexaplane
# de punta a punta: clonado por el paso `fetch`, construido por Kaniko en el
# paso `build` y escaneado por Trivy en el paso `scan`.
#
# LA BASE ES DE DOCKER HUB A PROPOSITO. El pod de build no alcanza internet:
# solo el Artifact Registry del proyecto. Que este `FROM` resuelva es lo que
# demuestra que la reescritura de registro de Kaniko funciona
# (--registry-map index.docker.io=<registro>/dockerhub-remote, SPEC-0007 4.5).
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
