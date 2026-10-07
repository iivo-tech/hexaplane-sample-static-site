# App de conformidad de REQ-0047: responde, en /cgi-bin/database, lo que la
# PROPIA App lee de su base con la variable DATABASE_URL que le inyecta la
# plataforma (ADR-0096). No es un sitio: es la sonda de una prueba.
#
# SIN INSTALAR NADA, Y NO ES UNA PREFERENCIA. El pod de build no alcanza
# internet, solo el Artifact Registry del proyecto con su espejo de Docker Hub
# (SPEC-0007 4.5): un `apk add` no resuelve. Por eso la imagen se arma con dos
# bases que ya traen lo necesario:
# - postgres alpine, por psql;
# - busybox musl, por su httpd con CGI, que el busybox de alpine ya no trae.
#
# SIN ROOT Y POR ENCIMA DEL 1024: el namespace del tenant aplica Pod Security
# `restricted` (REQ-0011). 70 es el usuario postgres de la imagen alpine; va
# numerico porque runAsNonRoot no puede comprobar un nombre.
#
# FIJADO POR DIGEST (REQ-0021).
FROM busybox:1.37-musl@sha256:5cec3fc171c87218698e85a52af7087de727372aae264a787b8112901a5b0092 AS busybox

FROM postgres:18-alpine@sha256:77f585114c32fbca283dc835b0596f4e52b51b4c6662d7810b2f4084f60a1873
COPY --from=busybox /bin/busybox /usr/local/bin/busybox-httpd
COPY www/ /www/
USER 70
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/busybox-httpd", "httpd", "-f", "-v", "-p", "8080", "-h", "/www"]
