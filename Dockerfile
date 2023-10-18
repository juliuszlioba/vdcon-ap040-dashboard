FROM node:20-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
WORKDIR /app

COPY package.json pnpm-lock.yaml ./

FROM base AS prod-deps
RUN pnpm install --production

FROM base AS build-deps
RUN pnpm install --production=false

FROM build-deps AS build
COPY src ./src
COPY public ./public
COPY astro.config.mjs .
COPY components.json .
COPY tailwind.config.mjs .
COPY tsconfig.json .
RUN pnpm run build

FROM nginx:alpine AS runtime
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8080