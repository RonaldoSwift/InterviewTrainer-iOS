# InterviewTrainer iOS

Aplicación iOS para practicar entrevistas técnicas de desarrollo en Swift.

## Estado actual

La aplicación tiene una navegación funcional con datos locales:

1. `Home` muestra la pantalla inicial.
2. `Practice` permite elegir tema, dificultad e idioma.
3. La sesión usa un examen mock para responder preguntas y ver resultados.

La integración con API todavía no está conectada. Los DTOs, mappers y el contrato están preparados para esa siguiente etapa.

## Arquitectura

El proyecto usa Tuist y separa cada feature en un target independiente:

```text
InterviewTrainer/
├── Sources/
│   ├── App/
│   └── Features/
│       ├── Home/
│       │   ├── Data/
│       │   ├── Domain/
│       │   ├── Presentation/
│       │   └── Resources/
│       └── Practice/
│           ├── Data/
│           │   ├── DTOs/
│           │   ├── Mappers/
│           │   └── Mocks/
│           ├── Domain/
│           │   ├── Enums/
│           │   └── Models/
│           ├── Presentation/
│           └── Resources/
└── Resources/
```

### Responsabilidad de cada capa

- **Presentation:** vistas SwiftUI y view models; transforma el estado de la aplicación en interfaz.
- **Domain:** modelos y reglas propias del negocio, independientes de API o SwiftUI.
- **Data:** DTOs de API, mappers, proveedores y mocks. Aquí vivirá la implementación de red más adelante.
- **Resources:** textos localizados y otros recursos propios del target.

Las carpetas vacías (`Data` y `Domain` en `Home`) se conservan para que la feature pueda crecer con la misma convención que `Practice`, sin crear archivos artificiales.

## Conceptos importantes

### `AnswerOption` vs. `AnswerOptionDTO`

- `AnswerOption` es el modelo de dominio que usa la aplicación. Vive en `Domain/Models`.
- `AnswerOptionDTO` representa el JSON que recibiremos del backend. Vive en `Data/DTOs`.
- `ExamMapper` convierte el DTO en el modelo de dominio. La UI no debería depender directamente de DTOs.

Esta separación permite cambiar el contrato de API sin contaminar las vistas ni los modelos de negocio.

## Localización

Cada target mantiene sus propios recursos:

- `Home/Resources/{es,en}.lproj/Localizable.strings`
- `Practice/Resources/{es,en}.lproj/Localizable.strings`
- `Resources/{es,en}.lproj/Localizable.strings` para `App`

Los textos visibles no deben escribirse directamente en las vistas o view models. Se accede a ellos mediante `HomeStrings`, `PracticeStrings` o `AppStrings`.

## Documentación

- [Contrato de API](Documentation/API/api-contract.md)

## Generar y probar

```bash
tuist generate
xcodebuild test -workspace InterviewTrainer.xcworkspace -scheme Practice-Tests -destination 'platform=iOS Simulator,name=iPhone 16'
```
