# InterviewTrainer-iOS

Aplicación para iOS orientada a practicar y prepararse para entrevistas. Permite configurar un examen, responder preguntas de opción múltiple y revisar los resultados con explicaciones.

## Funcionalidades actuales

- Pantalla de inicio para comenzar una práctica.
- Configuración del examen por tema, dificultad e idioma (español o inglés).
- Generación de exámenes y carga de preguntas desde un servicio HTTP.
- Navegación entre preguntas y selección de respuestas.
- Envío de respuestas y consulta de puntuación, respuestas correctas e incorrectas y explicaciones.
- Validaciones de respuestas y manejo de errores del servicio.

## Tecnologías

- Swift 5.9
- SwiftUI
- iOS 15 o posterior
- Tuist para definir y generar el proyecto Xcode
- `URLSession` para la comunicación con el backend

## Requisitos y ejecución

1. Abre `InterviewTrainer.xcworkspace` en Xcode.
2. Selecciona el esquema `InterviewTrainer` y un simulador o dispositivo iOS.
3. Ejecuta la aplicación con **Run**.

La aplicación espera que el backend esté disponible en `http://127.0.0.1:8000`. La URL base se configura en `Practice/Sources/Data/Services/APIConfiguration.swift`; actualízala si tu backend utiliza otra dirección. El backend no está incluido en este repositorio.

Para ejecutar las pruebas, selecciona el esquema `InterviewTrainer`, `Home` o `Practice` en Xcode y usa **Product > Test**.

## Estructura del proyecto

```text
InterviewTrainer/       Aplicación iOS y punto de entrada
InterviewTrainerTests/  Pruebas de integración de la aplicación
Home/                   Pantalla de inicio y sus pruebas
Practice/
  Sources/
    Data/               DTOs y servicio HTTP
    Domain/             Modelos y tipos del dominio
    Presentation/       Configuración, examen y resultados
  Tests/                Pruebas de API, modelos y flujo de práctica
Project.swift           Definición de targets y dependencias con Tuist
Tuist.swift             Configuración de Tuist
```

La aplicación se organiza en módulos: `InterviewTrainer` integra las funcionalidades, mientras que `Home` y `Practice` separan las pantallas y su lógica. El módulo `Practice` divide su código en capas de datos, dominio y presentación.
