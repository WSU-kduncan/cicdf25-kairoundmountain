FROM httpd:2.4
COPY ./web-content ./htdocs
EXPOSE 80