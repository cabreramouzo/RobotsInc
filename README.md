# 🤖 WallaRobots Challenge

This application is an implementation of a robot directory and detail viewer, focused on **high decoupling**, **architectural scalability**, and **optimized SwiftUI performance**.

 | App Icon | Dark Mode | 
 | :--: | :--: |
 | <img src="WallaRobots/Resources/Assets.xcassets/AppIcon.appiconset/WallaRobots-iOS-Default-1024x1024%401x.png" width="150" alt="App Icon"> | <img src="WallaRobots/Resources/Assets.xcassets/AppIcon.appiconset/WallaRobots-iOS-Dark-1024x1024%401x.png" width="150" alt="App Icon"> |

---

## 🚀 Architecture & Technical Decisions

### 1. MVVM + Clean Architecture
Since the presentation layer is built entirely with **SwiftUI**, I chose **MVVM** as the primary design pattern due to its seamless integration with the framework's reactive data flow.

* **Abstraction:** Data access is abstracted through the `RobotServiceProtocol`, following Clean Architecture principles.
* **Dependency Injection:** This structure decouples network logic from the UI. For **Xcode Previews** and unit testing, I inject a `FakeRobotService` using local JSON data, ensuring a fast development cycle independent of external services.

### 2. Rendering Optimization (View Identity)
A key performance decision was extracting the `RobotRow` into a **standalone struct**.

By decoupling cells from the main list's body, SwiftUI's rendering engine can better manage **View Identity**. This optimizes `body` computation and prevents unnecessary row repaints during search interactions, ensuring a 60 FPS fluid scroll even with large datasets.

### 3. Data Flow & State Management
I have implemented a state hierarchy based on Apple's modern best practices:

* **`@StateObject`**: Initialized in the root view (`RobotListView`) to ensure the ViewModel persists correctly and does not reset during the view's lifecycle.
* **`@EnvironmentObject`**: Instead of passing the ViewModel manually (Prop Drilling), I inject it into the environment. This keeps view initializers clean and allows deep components (like pagination logic within cells) to access the same data instance effortlessly.

---

## 🛠️ Technologies & Strategies

### 1. Hybrid Image Management
I opted for a mixed approach to demonstrate versatility and tool proficiency:
* **Kingfisher (List):** Used in the main feed to leverage **disk and memory persistent caching**, avoiding redundant downloads. It also handles **automatic cancellation** (stopping downloads when a cell moves off-screen), optimizing bandwidth and battery life.
* **AsyncImage (Detail):** Used for the detail view to demonstrate mastery of native Apple frameworks when complex caching logic is not required.

### 2. Concurrency & Reactivity
* **Swift 6 & MainActor:** The project is configured for Swift 6 concurrency mode, ensuring **thread safety** by isolating properties on the `MainActor`.
* **Combine (Debounced Search):** A 0.3-second `debounce` operator is implemented for search queries. This enhances UX by preventing expensive filter operations on every keystroke.

---

## 🧪 Testing

A baseline but robust testing strategy has been implemented:
* **Unit Testing (Swift Testing & XCTest):** Focused on ViewModel logic, validating initial load, filtering, and pagination behavior.
* **Integration (Swift Testing):** Focused on the entire ViewModel state, when performing several actions simulating the user interaction including debouncing when searching and pagination.
* **UI Testing (XCUITest):** Integration tests to ensure navigation flow between list and detail views and data consistency.
* **Snapshot Testing:** Using swift-snapshot-testing by [Pointfree](https://github.com/pointfreeco/swift-snapshot-testing) to test some screens using snapshots.

---

## ⚙️ Continuous Integration (CI/CD)

Automated workflows via **GitHub Actions** ensure project stability on every `Pull Request` and `push` to master:

* **SwiftLint Workflow:** Automated code style analysis to ensure contributions adhere to defined best practices and maintain a clean, uniform codebase.
* **Unit & UI Testing Workflow:** Automated test execution on macOS 26 with Xcode 26.3. The workflow builds and runs tests on an iPhone 17 simulator, blocking merges if any test fails.

![SwiftLint](https://github.com/cabreramouzo/WallaRobots/actions/workflows/lint.yml/badge.svg)
![iOS CI](https://github.com/cabreramouzo/WallaRobots/actions/workflows/build_test.yml/badge.svg)

---

## 🌳 Git Strategy
This project follows a branching model inspired by **Git Flow**:
* `master`: Stable, production-ready code.
* `feature/`: New functionalities (Search, Pagination).
* `improvement/`: Architectural refactors and performance optimizations.
* `fix/`: Bug fixes and UI adjustments.

Configured GIT-LFS to optimize the size of the repository (snapshot images).

*Branches have been intentionally preserved to showcase the incremental development process.*

---

## 🎨 Credits & Data Sources
* **Icon Design:** Custom app icon created using Apple [Icon Composer](https://developer.apple.com/icon-composer/).
* **Image API:** Using [Robohash](https://robohash.org/) for dynamic robot avatar generation.
* **Data Source:** Due to the original Marvel API's unavailability, a remote endpoint with a dummy employee dataset from previous training stages was used.

---

## 📱 Screenshots
| List View | Detail View | Search | Offline View |
| :---: | :---: | :---: |  :---: |
| <img src="WallaRobots/Resources/Screenshots/RobotList.png" width="200" alt="Robot list"> | <img src="WallaRobots/Resources/Screenshots/RobotDetail.png" width="200" alt="Robot Detail"> | <img src="WallaRobots/Resources/Screenshots/Search.png" width="200" alt="Search view"> | <img src="WallaRobots/Resources/Screenshots/NoInternet.png" width="200" alt="No Internet view"> |

---

## ⚙️ Requirements & Setup
* **iOS:** 17.0+
* **Swift:** 6.0 (Strict Concurrency compatible)
* **Xcode Previews:** The `test_robots.json` file is included in the App's **Target Membership** to ensure Previews work correctly with mock data.

---

### Installation
1. Clone the repository.
2. Open `WallaRobots.xcodeproj`.
3. Build and Run. Dependencies (Kingfisher) are managed automatically via Swift Package Manager.


<details>
	<summary><b>🇪🇸 Versión en Español 🇪🇸</b></summary>

# 🤖 WallaRobots Challenge

Esta aplicación es una implementación para un listado y visualizador de detalles de robots, enfocada en el alto desacoplamiento, la limpieza arquitectónica y un rendimiento optimizado en SwiftUI.

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
* **Integration (Swift Testing):** Centrado en el estado global del ViewModel, cuando se ejecutan múltiples operaciones conjuntamente, que simulan una interacción completa del usuario, como buscar, debouncing y la paginación.
* **UI Testing (XCUITest):** Pruebas de interfaz para asegurar el flujo de navegación entre la lista y las pantallas de detalle, verificando la consistencia de los datos.
* **Snapshot Testing:** Se ha usado swift-snapshot-testing de [Pointfree](https://github.com/pointfreeco/swift-snapshot-testing) para testear las diferentes vistas.

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

También se ha configurado GIT-LFS para optimizar el tamaño del repositoio (imágenes snapshots).

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
3. Compila y ejecuta. El proyecto gestiona las dependencias (Kingfisher y otras) mediante Swift Package Manager automáticamente.
</details>