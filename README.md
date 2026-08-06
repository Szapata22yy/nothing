# HorasSamuel

Aplicación iOS nativa para registro de horas de trabajo.

## Desarrollo con ios-builder

Este proyecto está preparado para `builder init` y `builder ios build`.

### Ejecutar

1. Configura `builder` en tu entorno Windows siguiendo la documentación de ios-builder.
2. Actualiza `builder.json` con tu repositorio GitHub.
3. Ejecuta:

```bash
builder init
builder ios build
```

## Estructura

- `Sources/HorasSamuelApp/` - Código fuente SwiftUI y SwiftData
- `Package.swift` - Paquete Swift compatible con iOS 17
- `builder.json` - Configuración de ios-builder

## Requisitos

- iOS 17+
- SwiftUI
- SwiftData
- Sin dependencias externas
