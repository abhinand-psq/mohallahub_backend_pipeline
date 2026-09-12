# Mohalla Backend --- Dockerization Documentation

## 1. Overview

The Mohalla backend is a Node.js application that is containerized using
a **two-stage Docker build**.

The Dockerfile separates:

1.  **Dependency stage** --- installs the production Node.js
    dependencies.
2.  **Runtime stage** --- starts from a fresh Node.js Alpine image and
    copies only the required production dependencies and application
    source.

The container listens on port **8000**.
---

## 3. Stage 1 --- Production Dependencies

The first stage is:

``` dockerfile
FROM node:20-alpine AS dependencies
```

The working directory is:

``` dockerfile
WORKDIR /app
```

Only the package definition files are initially copied:

``` dockerfile
COPY package*.json ./
```

The production dependencies are installed using:

``` dockerfile
RUN npm ci --omit=dev
```

### Why `npm ci`?

`npm ci` performs a clean dependency installation based on the lock file
when it is available. It is appropriate for repeatable container builds.

### Why `--omit=dev`?

The production container does not need development-only packages.

## 4. Stage 2 --- Runtime Image

The second stage starts again from:

``` dockerfile
FROM node:20-alpine
```

This becomes the final runtime image.

The production dependencies created in the first stage are copied into
it:

``` dockerfile
COPY --from=dependencies /app/node_modules ./node_modules
```

The application source is then copied:

``` dockerfile
COPY . .
```

The result is a runtime container containing the application and its
production dependencies.

## 5. Winston Log Directory

The Dockerfile creates the directory required by the Winston logger:

``` dockerfile
RUN mkdir -p /app/logs
```

This ensures that the application has the expected directory available
inside the container.

## 6. Running as a Non-Root User

The Dockerfile changes ownership:

``` dockerfile
RUN chown -R node:node /app
```

and then switches to the built-in Node user:

``` dockerfile
USER node
```

Therefore, the backend application process does not run as root.

This is an important container-hardening measure because the application
does not require root privileges for normal execution.

## 7. Backend Port

The Dockerfile declares:

``` dockerfile
EXPOSE 8000
```

This documents that the Node.js application listens on port:

``` text
8000
```

In Kubernetes, the Service can target this container port and expose the
backend internally or through the required ingress architecture.

## 8. Container Startup

The container starts with:

``` dockerfile
CMD ["npm", "start"]
```

Therefore, the application's `package.json` `start` script is
responsible for starting the backend server.

The startup flow is:

``` text
Container starts
      |
      v
npm start
      |
      v
Node.js backend
      |
      v
Listening on :8000
```



## 10. Why Multi-Stage Build?

The dependency stage is used to isolate dependency installation from the
final runtime stage.

The final image receives the production dependencies through:

``` dockerfile
COPY --from=dependencies /app/node_modules ./node_modules
```

This follows the multi-stage Docker pattern: each stage has a specific
responsibility and artifacts can be copied from an earlier stage into
the final runtime image.

Docker documents this approach as a way to separate build/dependency
environments from runtime images and avoid carrying unnecessary build
tooling into the final image.

## 11. Security Characteristics

The backend Dockerfile includes several useful practices:

### Alpine base image

``` dockerfile
node:20-alpine
```

provides a relatively small Node.js base image.

### Production-only dependencies

``` dockerfile
npm ci --omit=dev
```

avoids installing development dependencies in the dependency stage.

### Non-root execution

``` dockerfile
USER node
```

runs the application without root privileges.

### Explicit application port

``` dockerfile
EXPOSE 8000
```

documents the expected application port.

