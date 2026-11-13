# Contrato de API - InterviewTrainer AI

**Versión:** 1.0  
**Estado:** Propuesto  
**Base URL:** `/api/v1`

## 1. Objetivo

Definir el contrato de comunicación entre la aplicación iOS InterviewTrainer AI y el backend.

La API permitirá generar exámenes técnicos de iOS, recibir las respuestas del usuario y devolver los resultados con sus respectivas explicaciones.

## 2. Convenciones generales

- Formato de intercambio: JSON.
- Content-Type: `application/json`.
- Métodos HTTP: POST.
- Los nombres de propiedades JSON utilizan `snake_case`.
- La API utiliza identificadores únicos para exámenes, preguntas y alternativas.
- No se requiere autenticación para esta primera versión.

## 3. Enumeraciones

### 3.1. Temas disponibles

| Valor | Descripción |
|---|---|
| `swift` | Lenguaje Swift |
| `swiftui` | Framework SwiftUI |
| `uikit` | Framework UIKit |
| `concurrency` | Concurrencia en Swift |
| `memory_management` | Gestión de memoria |
| `combine` | Framework Combine |
| `architecture` | Arquitectura de software |

### 3.2. Dificultad

| Valor | Descripción |
|---|---|
| `beginner` | Principiante |
| `intermediate` | Intermedio |
| `advanced` | Avanzado |

### 3.3. Idioma

| Valor | Descripción |
|---|---|
| `es` | Español |
| `en` | Inglés |

## 4. Endpoints

### 4.1. Generar examen

**Método:** POST

**Endpoint:** `/api/v1/exams`

**Descripción:** Genera un examen técnico con preguntas de opción múltiple según el tema, dificultad e idioma seleccionados.

#### Request

```json
{
  "topic": "swiftui",
  "difficulty": "intermediate",
  "language": "es",
  "total_questions": 5
}
```

| Campo | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `topic` | string | Sí | Tema del examen |
| `difficulty` | string | Sí | Nivel de dificultad |
| `language` | string | Sí | Idioma del examen |
| `total_questions` | integer | Sí | Cantidad de preguntas. Para el MVP debe ser 5 |

#### Response - 201 Created

> Ejemplo abreviado: se muestra una pregunta para ilustrar la estructura. La respuesta real contiene exactamente 5 preguntas.

```json
{
  "exam_id": "exam_123",
  "topic": "swiftui",
  "difficulty": "intermediate",
  "language": "es",
  "total_questions": 5,
  "questions": [
    {
      "question_id": "q_001",
      "statement": "¿Qué propiedad wrapper permite compartir un valor entre vistas?",
      "code_snippet": null,
      "options": [
        {
          "option_id": "a",
          "text": "@State"
        },
        {
          "option_id": "b",
          "text": "@Binding"
        },
        {
          "option_id": "c",
          "text": "@Environment"
        },
        {
          "option_id": "d",
          "text": "@AppStorage"
        }
      ]
    }
  ]
}
```

**Consideraciones:**

- La respuesta real debe contener exactamente 5 preguntas.
- Cada pregunta debe contener exactamente 4 alternativas.
- `question_id` debe ser único dentro del examen.
- `option_id` debe identificar de forma única cada alternativa de su pregunta.
- `code_snippet` puede ser `null` cuando la pregunta no requiera código.
- La respuesta no debe incluir la alternativa correcta ni la explicación antes de que el usuario responda.

### 4.2. Enviar respuestas y calificar examen

**Método:** POST

**Endpoint:** `/api/v1/exams/{exam_id}/answers`

**Descripción:** Recibe las alternativas seleccionadas por el usuario y devuelve la calificación, las respuestas correctas y las explicaciones.

#### Path parameters

| Parámetro | Tipo | Descripción |
|---|---|---|
| `exam_id` | string | Identificador del examen generado previamente |

#### Request

> Ejemplo abreviado: se muestran 2 respuestas. La solicitud real debe contener exactamente 5 respuestas, una por pregunta.

```json
{
  "answers": [
    {
      "question_id": "q_001",
      "selected_option_id": "b"
    },
    {
      "question_id": "q_002",
      "selected_option_id": "a"
    }
  ]
}
```

**Consideraciones:**

- El usuario debe enviar una respuesta por cada pregunta.
- Para el MVP, se deben enviar exactamente 5 respuestas.
- Cada `question_id` debe pertenecer al examen indicado.
- Cada `selected_option_id` debe pertenecer a la pregunta correspondiente.

#### Response - 200 OK

> Ejemplo abreviado: se muestra un resultado para ilustrar la estructura. La respuesta real contiene los resultados de las 5 preguntas.

```json
{
  "exam_id": "exam_123",
  "score": 80,
  "correct_answers": 4,
  "incorrect_answers": 1,
  "total_questions": 5,
  "results": [
    {
      "question_id": "q_001",
      "selected_option_id": "b",
      "correct_option_id": "b",
      "is_correct": true,
      "explanation": "Binding permite que una vista reciba acceso de lectura y escritura a una propiedad administrada por otra vista.",
      "code_example": null
    }
  ]
}
```

**Consideraciones:**

- `score` representa el porcentaje obtenido, entre 0 y 100.
- `correct_answers` indica la cantidad de respuestas correctas.
- `incorrect_answers` indica la cantidad de respuestas incorrectas.
- `results` contiene el resultado individual de cada pregunta.
- `correct_option_id` identifica la alternativa correcta.
- `explanation` contiene la explicación de la respuesta.
- `code_example` puede ser `null` cuando no se requiera un ejemplo de código.

## 5. Manejo de errores

Todas las respuestas de error utilizarán el siguiente formato:

```json
{
  "error": {
    "code": "EXAM_NOT_FOUND",
    "message": "No se encontró el examen solicitado.",
    "details": []
  }
}
```

### Códigos HTTP

| Código | Descripción |
|---|---|
| `400` | Solicitud incorrecta por una regla de negocio |
| `404` | Examen no encontrado |
| `422` | Los datos enviados no cumplen las validaciones |
| `500` | Error interno del servidor |
| `503` | Servicio de generación de preguntas no disponible |

**Consideraciones:**

- El código `400` se utilizará cuando la solicitud sea incorrecta por una regla de negocio.
- El código `422` se utilizará cuando los datos enviados no cumplan las validaciones del esquema.
- El backend implementará un manejador de excepciones para mantener el formato de error definido en este contrato, incluyendo los errores de validación de FastAPI.

## 6. Consideraciones técnicas

- El backend será responsable de generar las preguntas y evaluar las respuestas.
- La aplicación iOS nunca debe conocer las respuestas correctas antes de enviar sus respuestas.
- El backend generará los identificadores del examen y de sus preguntas.
- En la primera versión, los exámenes se mantendrán en memoria en el backend.
- La persistencia de exámenes se incorporará en una etapa posterior.
- La aplicación iOS consumirá los endpoints mediante `URLSession` y `async/await`.

## 7. Alcance de esta versión

Este contrato define dos operaciones principales:

1. Generación de exámenes técnicos.
2. Evaluación de respuestas y obtención de resultados.

No contempla autenticación, perfiles de usuario, ranking, temporizadores ni persistencia del historial en el servidor.