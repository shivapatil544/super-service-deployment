# Step 1: Build the .NET application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env

# Set working directory inside the container
WORKDIR /app

# Copy the project file to the working directory
COPY src/SuperService.csproj ./src/

# Restore dependencies
RUN dotnet restore ./src/SuperService.csproj

# Copy the rest of the application code
COPY src/ ./src/

# Build the project in Release mode
RUN dotnet publish ./src/SuperService.csproj -c Release -o /out

# Step 2: Build the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

# Set working directory for runtime
WORKDIR /app

# Copy the compiled app from the build stage
COPY --from=build-env /out .

# Expose the application on port 80
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "SuperService.dll"]
