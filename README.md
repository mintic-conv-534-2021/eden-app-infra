# eden-app-infra
Proyecto que contiene todas las configuraciones necesarias para que se pueda desplegar en nube.

## Contenido

- [Introducción](Introducción)
- [Requisitos](Requisitos)
- [Arquitectura física](Arquitectura-física)
- [Buenas prácticas](Buenas-prácticas)
- [Resolución de problemas](Resolución-de-problemas)

## Introducción

En este proyecto se almácenan todos los scripts necesarios para construir la infrastructura. Aunque se considero IaC como una alternativa que se considero para la creación de la infrastructura que soporta la aplicación EdenApp, se descartó debido a las restricciones temporales y economicas del proyecto, sin embargo se recomienda tenerlo presente para el futuro, puede ser una alternativa viable si las condiciones de negocio del proyecto cambian y hay una expectativa de crecimiento de usuarios relevante.

## Requisitos

Los scripts aquí guardados fueron creados para sistemas tipo *nix. Especificamente fueron probados utilizando macOS. Para ejecutar estos scripts se recomienda tener instalado:

- [aws cli](https://aws.amazon.com/es/cli/)
- [eksctl](https://eksctl.io/)
- [kubectl]()
- [helm](https://helm.sh/docs/intro/install/)
- [jq](https://stedolan.github.io/jq/)

Recuerde que para ejecutar los scripts debe ponerles permisos de ejecución:

```sh
chmod +x scripts/eks-fargate-setup.sh
```

**Credenciales**

Recuerde que debe tener las credenciales configuradas en ```~/.aws/credentials``` para que funcione correctamente el despliegue.


## Arquitectura física


## Buenas prácticas

Si desea modificar la arquitectura física de la aplicación tenga en cuenta las recomendaciones que listamos a continuación.

TODO

## Resolución de problemas

En sección se presenta un resumen de los problemas presentados en el momento del desarrollo y que pueden ser útiles mas adelante para la resolución de problemas en el futuro.

- **Importante**: una vez creados los buckets debe configurarlos manualmente para realizar la conexión con los repositorios

