# Base image
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

WORKDIR /app
COPY ./bin/production/net6.0/publish ./

# Expose ports
EXPOSE 80

RUN sed -i 's/DEFAULT@SECLEVEL=2/DEFAULT@SECLEVEL=1/g' /etc/ssl/openssl.cnf
# Start IIS
ENTRYPOINT ["dotnet", "generate.web.dll"] 