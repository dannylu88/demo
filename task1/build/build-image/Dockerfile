# syntax=docker/dockerfile:1

FROM golang:1.20 AS build-stage

# Set destination for COPY
WORKDIR /app

# Download Go modules
COPY go.mod ./

# Copy the source code, gonna copy everything because we have assets in repo
COPY . ./

ENV PORT=8082 customFilePath="../../assets/index.html" customURLPath="/"

# Change workdir to main package
WORKDIR /app/cmd/coffee

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o /coffee-binary

CMD ["/coffee-binary"]


# Optional multistage stage, better performance. 
# # ############## 
# # # But since we put image/asset in repo, it will break. Because golang doesn't compile those
# # # We can put those assets in CDN
# # ###############
# FROM gcr.io/distroless/base-debian11 AS build-release-stage

# WORKDIR /

# COPY --from=build-stage /coffee-binary /coffee

# EXPOSE 8082

# USER nonroot:nonroot

# ENTRYPOINT ["/coffee"]