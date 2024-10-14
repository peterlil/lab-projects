# Use the official .NET image as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use the SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . ./
RUN dotnet restore "CacheContentApi.csproj"
RUN dotnet build "CacheContentApi.csproj" -c Debug -o /app/build

FROM build AS publish
RUN dotnet publish "CacheContentApi.csproj" -c Debug -o /app/publish

# Use the base image to run the app
FROM base AS final
WORKDIR /app 
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CacheContentApi.dll"]