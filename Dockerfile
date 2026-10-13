# App de conformidad de REQ-0058 y REQ-0059: responde, en /cgi-bin/hash?name=X,
# el sha256 de la variable de entorno X tal como la recibe la PROPIA App, o 404
# si no la tiene. NUNCA RESPONDE UN VALOR: las pruebas comparan el hash de lo
# que guardaron, y un valor de secreto no aparece en ninguna respuesta ni en
# ningún log (PLAN-0028, restricciones de la fase 2). No es un sitio: es la
# sonda de una prueba.
#
# SIN INSTALAR NADA, Y NO ES UNA PREFERENCIA. El pod de build no alcanza
# internet, solo el Artifact Registry del proyecto con su espejo de Docker Hub
# (SPEC-0007 4.5). busybox musl trae lo que hace falta: su httpd con CGI, sh y
# sha256sum.
#
# SIN ROOT Y POR ENCIMA DEL 1024: el namespace del tenant aplica Pod Security
# `restricted` (REQ-0011). 65534 es nobody en busybox; va numérico porque
# runAsNonRoot no puede comprobar un nombre.
#
# FIJADO POR DIGEST (REQ-0021).
FROM busybox:1.37-musl@sha256:5cec3fc171c87218698e85a52af7087de727372aae264a787b8112901a5b0092
COPY www/ /www/
USER 65534
EXPOSE 8080
ENTRYPOINT ["/bin/busybox", "httpd", "-f", "-v", "-p", "8080", "-h", "/www"]
