# Spanish version 🇪🇸
# 🤖 WallaRobots Challenge

Esta aplicación es una implementación técnica para un listado y visualizador de detalles de robots, enfocada en el alto desacoplamiento, la limpieza arquitectónica y un rendimiento optimizado en SwiftUI.

 | App Icon | Dark | 
 | :--: | :--: |
 | <img src="WallaRobots/Resources/Assets.xcassets/AppIcon.appiconset/WallaRobots-iOS-Default-1024x1024%401x.png" width="150" alt="App Icon"> | <img src="WallaRobots/Resources/Assets.xcassets/AppIcon.appiconset/WallaRobots-iOS-Dark-1024x1024%401x.png" width="150" alt="App Icon"> |
---

## 🚀 Decisiones de Arquitectura

### 1. MVVM + Patrón de Repositorio
Se ha utilizado el patrón **MVVM** junto con una capa de servicio para garantizar una clara separación de responsabilidades:
* **Capa de Servicio:** El acceso a los datos se abstrae mediante el protocolo `RobotServiceProtocol`, lo que facilita la inyección de dependencias.
* **Patrón de Repositorio:** Se utiliza un servicio de datos que puede ser sustituido por un simulacro (*mock*) (`FakeRobotService`) para las pruebas unitarias y las Xcode Previews, garantizando un entorno de desarrollo determinista.

### 2. Optimización de Renderizado (Identidad de la Vista)
Una decisión clave fue extraer la celda `RobotRow` a un **`struct` independiente**:
* **Rendimiento:** Al desacoplar la celda del cuerpo principal de la lista, permitimos que el motor de renderizado de SwiftUI realice comparaciones de igualdad sobre el modelo de datos. Esto evita la ejecución redundante del `body` en las celdas que no han sufrido cambios durante las actualizaciones de estado (como el filtrado por búsqueda), garantizando un scroll fluido y sin saltos.

### 3. Gestión de Estado y Propagación de Datos
Se ha implementado una jerarquía de estado robusta basada en las últimas buenas prácticas de Apple:
* **`@StateObject`**: Inicializado en la vista raíz (`RobotListView`) para asegurar que el ViewModel persista correctamente durante todo el ciclo de vida de la pantalla.
* **`@EnvironmentObject`**: Las subvistas (como `RobotRow`) sintonizan el ViewModel a través del entorno. Esto evita el **Prop Drilling** (pasar dependencias a través de múltiples inicializadores de forma innecesaria) y asegura que todas las celdas interactúen con la misma instancia para la paginación sincronizada.

---

## 🛠️ Tecnologías y Estrategias

### 1. Gestión Híbrida de Imágenes
Se ha optado por un enfoque mixto para demostrar versatilidad y un conocimiento profundo de las herramientas:
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

## 🌳 Estrategia de Git
Este proyecto sigue un modelo de ramificación inspirado en **Git Flow**:
* `master`: Código estable y listo para producción.
* `feature/`: Nuevas funcionalidades (Búsqueda, Paginación).
* `improvement/`: Refactorizaciones arquitectónicas y optimizaciones de rendimiento.
* `fix/`: Corrección de errores y ajustes de interfaz.

*Se han mantenido las ramas de forma intencionada para mostrar el proceso de desarrollo incremental y la evolución arquitectónica del proyecto.*

---

## 🎨 Créditos y Origen de Datos
* **API de Imágenes:** Se ha utilizado [Robohash](https://robohash.org/) para la generación dinámica de los avatares de los robots.
* **Fuente de Datos:** Debido a la inactividad de la API original de Marvel, se ha optado por utilizar un endpoint remoto con un dataset de empleados ficticio utilizado previamente en mi etapa de formación.

---

## 📱 Capturas de pantalla
| Vista Lista | Vista detalle | Búqueda | Vista sin conexión |
| :---: | :---: | :---: |  :---: |
| <img src="WallaRobots/Resources/Screenshots/RobotList.png" width="200" alt="Robot list"> | <img src="WallaRobots/Resources/Screenshots/RobotDetail.png" width="200" alt="Robot Detail"> | <img src="WallaRobots/Resources/Screenshots/Search.png" width="200" alt="Search view"> | <img src="WallaRobots/Resources/Screenshots/NoInternet.png" width="200" alt="No Internet view"> |

---

## ⚙️ Requisitos y Configuración
* **iOS:** 16.0+
* **Swift:** 6.0 (Compatible con Concurrencia Estricta)
* **Xcode Previews:** El archivo `test_robots.json` está incluido en el **Target Membership** de la App para asegurar que las Previews funcionen correctamente con datos de prueba.

---

### Instrucciones de Instalación
1. Clona el repositorio.
2. Abre `WallaRobots.xcodeproj`.
3. Compila y ejecuta. El proyecto gestiona las dependencias (Kingfisher) mediante Swift Package Manager automáticamente.

# English version 🇬🇧
# 🤖 WallaRobots Challenge

This application is a technical implementation for a robot listing and detail viewer, focused on high decoupling, architectural cleanliness, and optimized SwiftUI performance.

---

## 🚀 Architectural Decisions

### 1. MVVM + Repository Pattern
The **MVVM** pattern was used alongside a service layer to ensure a clear separation of concerns:
* **Service Layer:** Data access is abstracted via the `RobotServiceProtocol`, facilitating dependency injection.
* **Repository Pattern:** A data service is used that can be substituted by a mock (`FakeRobotService`) for unit testing and Xcode Previews, ensuring a deterministic development environment.

### 2. Rendering Optimization (View Identity)
To ensure a smooth, stutter-free scroll, the `RobotRow` was extracted into a **standalone `struct`**:
* **Performance:** By decoupling the cell from the main list body, we allow the SwiftUI rendering engine to perform equality comparisons on the data model. This prevents redundant `body` execution for cells that haven't changed during state updates (such as search filtering).

### 3. State Management & Data Propagation
* **`@StateObject`**: Manages the ViewModel lifecycle in the main view.
* **`@EnvironmentObject`**: Used to inject the ViewModel into the cells. This avoids **Prop Drilling** (passing dependencies through multiple initializers unnecessarily) and ensures all cells interact with the same instance for synchronized pagination.

---

## 🛠️ Technologies & Strategies

### 1. Hybrid Image Management
A mixed approach was chosen to demonstrate versatility and deep understanding of the tools:
* **Kingfisher (List):** Used in the list to leverage its **persistent disk and memory caching**, avoiding redundant downloads. It also benefits from **automatic cancellation** (stopping downloads when a cell scrolls out of view), optimizing bandwidth and battery life.
* **AsyncImage (Detail):** The native framework is used in the detail view to demonstrate mastery of standard Apple tools when complex caching logic is not required.

### 2. Concurrency & Reactivity
* **Swift 6 & MainActor:** The project is configured for Swift 6 concurrency mode, ensuring thread safety through property isolation on the `MainActor`.
* **Combine (Search Debouncing):** A 0.3-second `debounce` operator is implemented for searches. This improves user experience by avoiding expensive calculations on every keystroke.

---

## 🧪 Testing

A basic but solid testing strategy was implemented:
* **Unit Testing (Swift Testing & XCTest):** Focused on ViewModel logic, validating initial loading, filtering, and the correct behavior of pagination.
* **UI Testing (XCUITest):** Interface tests to ensure the navigation flow between the list and detail screens, verifying data consistency.

---

## 🌳 Git Strategy
This project follows a **Git Flow** inspired branching model:
* `master`: Stable production-ready code.
* `feature/`: New functionalities (Search, Pagination).
* `improvement/`: Architectural refactors and performance optimizations.
* `fix/`: Bug fixes and UI adjustments.

*Branches have been intentionally preserved to showcase the incremental development process and architectural evolution of the project.*

---

## 🎨 Credits & Data Sources
* **Image API:** [Robohash](https://robohash.org/) was used for the dynamic generation of robot avatars.
* **Data Source:** Due to the unavailability of the original Marvel API, I opted for a remote endpoint featuring a employees dataset previously used during my academy training.

---

## 📱 Screenshots
| List View | Detail View | Search | Network Error |
| :---: | :---: | :---: |  :---: |
| <img src="WallaRobots/Resources/Screenshots/RobotList.png" width="200" alt="Robot list"> | <img src="WallaRobots/Resources/Screenshots/RobotDetail.png" width="200" alt="Robot Detail"> | <img src="WallaRobots/Resources/Screenshots/Search.png" width="200" alt="Search view"> | <img src="WallaRobots/Resources/Screenshots/NoInternet.png" width="200" alt="No Internet view"> |

## ⚙️ Requirements & Setup
* **iOS:** 16.0+
* **Swift:** 6.0
* **Xcode Previews:** The `test_robots.json` file is included in the App's **Target Membership** to ensure Previews function correctly with mock data.

---

### Installation Instructions
1. Clone the repository.
2. Open `WallaRobots.xcodeproj`.
3. Build and run. The project manages dependencies (Kingfisher) via Swift Package Manager automatically.
