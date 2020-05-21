FROM mcr.microsoft.com/dotnet/core/sdk:2.1-alpine AS build-env
WORKDIR /app

# Copiar csproj e restaurar dependencias
COPY *.sln .
COPY produto.api/*.csproj ./produto.api/
COPY produto.domain/*.csproj ./produto.domain/
RUN dotnet restore

# Build da aplicacao
COPY . ./
RUN dotnet publish -c Release -o out

# Build da imagem
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-alpine AS runtime
ENV ASPNETCORE_URLS=http://+:5000
WORKDIR /app
COPY --from=build-env /app/out .
EXPOSE  5000
ENTRYPOINT ["dotnet", "produto.api.dll"]
