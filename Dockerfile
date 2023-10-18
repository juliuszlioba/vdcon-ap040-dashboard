FROM node:lts AS build
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY src ./src
COPY public ./public
COPY astro.config.mjs .
COPY components.json .
COPY tailwind.config.mjs .
COPY tsconfig.json .

RUN npm run build

FROM nginx:alpine AS runtime
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8080