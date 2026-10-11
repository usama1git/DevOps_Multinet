# Task C1: custom Nginx image serving a static page
FROM nginx:alpine

# Stretch goal: custom server config with a custom 404 page
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html 404.html /usr/share/nginx/html/

EXPOSE 80

# Stretch goal: container reports healthy once Nginx answers on port 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://127.0.0.1/ || exit 1
