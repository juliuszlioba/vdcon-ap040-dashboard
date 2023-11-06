FROM node:20-slim AS base
WORKDIR /app

FROM nginx:alpine AS runtime
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY /dist /usr/share/nginx/html
EXPOSE 8080