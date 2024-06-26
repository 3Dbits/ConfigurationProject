# Use the official ASP.NET 8.0 image as a base for the runtime environment
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
ENV ASPNETCORE_ENVIRONMENT=env1
EXPOSE 8080
EXPOSE 8081

# Use the official .NET SDK 8.0 image for building the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project file and restore any dependencies
COPY ConfigurationProject_v2.csproj ConfigurationProject_v2/
RUN dotnet restore ConfigurationProject_v2/ConfigurationProject_v2.csproj

# Copy the rest of the application code and build the application
COPY / ConfigurationProject_v2/
WORKDIR /src/ConfigurationProject_v2
RUN dotnet build ConfigurationProject_v2.csproj -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish ConfigurationProject_v2.csproj -c Release -o /app/publish

# Create the final image for running the application
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ConfigurationProject_v2.dll"]
