# Spanish version 🇪🇸
# 🤖 WallaRobots Challenge

Esta aplicación es una implementación técnica para un listado y visualizador de detalles de robots, enfocada en el alto desacoplamiento, la limpieza arquitectónica y un rendimiento optimizado en SwiftUI.

 | App Icon | Dark | 
 | :--: | :--: |
 | <img src="WallaRobots/Resources/Assets.xcassets/AppIcon.appiconset/WallaRobots-iOS-Default-1024x1024%401x.png" width="150" alt="App Icon"> | <img src="WallaRobots/Resources/Assets.xcassets/AppIcon.appiconset/WallaRobots-iOS-Dark-1024x1024%401x.png" width="150" alt="App Icon"> |

 ---

## 🚀 Arquitectura y Decisiones Técnicas

### 1. MVVM
Dado que la capa de presentación está construida íntegramente con **SwiftUI**, he elegido **MVVM** como patrón de diseño principal por su excelente integración con el flujo de datos reactivo del framework.

* **Abstracción:** El acceso a los datos no se realiza directamente desde el ViewModel. He implementado un protocolo `RobotServiceProtocol` que define el contrato de datos, siguiendo principios de Clean Architecture.
* **Inyección de Dependencias:** Esta estructura me permite desacoplar la lógica de red. En las **Xcode Previews** y en los tests unitarios, inyecto un `FakeRobotService` que utiliza un JSON local, asegurando un entorno de desarrollo rápido y sin dependencias de servicios externos.

### 2. Optimización de Renderizado (Identidad de la Vista)
Una decisión clave para el rendimiento fue extraer la celda `RobotRow` a un **`struct` independiente**.

Al separar las celdas del cuerpo principal de la lista, el motor de renderizado de SwiftUI puede gestionar mejor la identidad de las vistas. Esto optimiza el cálculo del `body` y evita que se repinten filas innecesariamente cuando el usuario interactúa con la barra de búsqueda, garantizando un scroll fluido incluso con listas extensas.

### 3. Flujo de Datos y Gestión de Estado
Para la propagación de datos, he optado por una jerarquía que prioriza la consistencia y la limpieza del código:

* **`@StateObject`**: Lo utilizo en la vista raíz (`RobotListView`) para asegurar que el ViewModel persista correctamente y no se reinicie durante el ciclo de vida de la pantalla.
* **`@EnvironmentObject`**: En lugar de pasar el ViewModel manualmente a cada subvista, lo inyecto en el entorno. Esto elimina el **Prop Drilling**, manteniendo los inicializadores de las vistas mucho más limpios y facilitando que componentes profundos (como la lógica de paginación en las celdas) accedan a la misma instancia de datos.

---

## 🛠️ Tecnologías y Estrategias

### 1. Gestión Híbrida de Imágenes
Se ha optado por un enfoque mixto para demostrar versatilidad y un conocimiento de las herramientas:
* **Kingfisher (Lista):** Utilizado en el listado para aprovechar su gestión de **caché persistente en disco y memoria**, evitando descargas redundantes. También se beneficia de la **cancelación automática** (deteniendo las descargas cuando una celda sale de la pantalla), optimizando el ancho de banda y la duración de la batería.
* **AsyncImage (Detalle):** Se utiliza el framework nativo en la vista de detalle para demostrar el dominio de las herramientas estándar de Apple cuando no se requiere una lógica de caché compleja.

### 2. Concurrencia y Reactividad
* **Swift 6 y MainActor:** El proyecto está configurado para el modo de concurrencia de Swift 6, garantizando la seguridad de hilos (*thread safety*) mediante el aislamiento de las propiedades en el `MainActor`.
* **Combine (Búsqueda con Debounce):** Se ha implementado un operador `debounce` de 0,3 segundos para las búsquedas. Esto mejora la experiencia del usuario al evitar cálculos costosos en cada pulsación de tecla.

---

## 🧪 Testing

Se ha implementado una estrategia de pruebas básica pero sólida:
* **Unit Testing (Swift Testing y XCTest):** Centrado en la lógica del ViewModel, validando la carga inicial, el filtrado y el comportamiento correcto de la paginación.
* **UI Testing (XCUITest):** Pruebas de interfaz para asegurar el flujo de navegación entre la lista y las pantallas de detalle, verificando la consistencia de los datos.

---

## ⚙️ Integración Continua (CI/CD)

He implementado flujos de trabajo automatizados mediante **GitHub Actions** para asegurar la estabilidad del proyecto en cada `Pull Request` y `push` a la rama principal:

* **SwiftLint Workflow:** Automatización del análisis de estilo de código. Esto garantiza que cualquier contribución respete las reglas de formato y buenas prácticas definidas, manteniendo un código limpio y legible de forma uniforme.
* **Unit & UI Testing Workflow:** Ejecución automatizada de la suite de tests en un entorno de macOS 26 con Xcode 26.3. El workflow compila el proyecto y lanza los tests en un simulador iPhone, bloqueando el merge si alguna prueba falla.

Esta configuración permite detectar errores de regresión de forma temprana y reduce la carga de revisión manual de estilo.

![SwiftLint](https://github.com/cabreramouzo/WallaRobots/actions/workflows/lint.yml/badge.svg)
![iOS CI](https://github.com/cabreramouzo/WallaRobots/actions/workflows/build_test.yml/badge.svg)

---

## 🌳 Estrategia de Git
Este proyecto sigue un modelo de ramificación inspirado en **Git Flow**:
* `master`: Código estable y listo para producción.
* `feature/`: Nuevas funcionalidades (Búsqueda, Paginación).
* `improvement/`: Refactorizaciones arquitectónicas y optimizaciones de rendimiento.
* `fix/`: Corrección de errores y ajustes de interfaz.

*Se han mantenido las ramas de forma intencionada para mostrar el proceso de desarrollo incremental y la evolución arquitectónica del proyecto.*

---

## 🎨 Créditos y Origen de Datos
* **Diseño del Icono:** El icono de app personalizado fue creado específicamente para este challenge usando Apple [Icon Composer](https://developer.apple.com/icon-composer/).
* **API de Imágenes:** Se ha utilizado [Robohash](https://robohash.org/) para la generación dinámica de los avatares de los robots.
* **Fuente de Datos:** Debido a la API original de Marvel no funcionaba correctamente, se ha optado por utilizar un endpoint remoto con un dataset de empleados ficticio utilizado previamente en mi etapa de formación.

---

## 📱 Capturas de pantalla
| Vista Lista | Vista detalle | Búqueda | Vista sin conexión |
| :---: | :---: | :---: |  :---: |
| <img src="WallaRobots/Resources/Screenshots/RobotList.png" width="200" alt="Robot list"> | <img src="WallaRobots/Resources/Screenshots/RobotDetail.png" width="200" alt="Robot Detail"> | <img src="WallaRobots/Resources/Screenshots/Search.png" width="200" alt="Search view"> | <img src="WallaRobots/Resources/Screenshots/NoInternet.png" width="200" alt="No Internet view"> |

---

## ⚙️ Requisitos y Configuración
* **iOS:** 17.0+
* **Swift:** 6.0 (Compatible con Concurrencia Estricta)
* **Xcode Previews:** El archivo `test_robots.json` está incluido en el **Target Membership** de la App para asegurar que las Previews funcionen correctamente con datos de prueba.

---

### Instrucciones de Instalación
1. Clona el repositorio.
2. Abre `WallaRobots.xcodeproj`.
3. Compila y ejecuta. El proyecto gestiona las dependencias (Kingfisher) mediante Swift Package Manager automáticamente.
