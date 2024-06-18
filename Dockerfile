FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ./src/FastEndPoint.csproj FastEndPoint/

RUN dotnet restore ./src/FastEndPoint.csproj

COPY . .
WORKDIR /src/FastEndPoint
RUN dotnet build FastEndPoint.csproj -c Release -o /app/build

FROM build AS publish
RUN dotnet publish FastEndPoint.csproj -c Release -o /app/publish

FROM base as final
WORKDIR /app
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "FastEndPoint.dll"]