# WebApi EF Pizzeria

Paso a paso para la creación de Web API N-Capas con Entity Framework Core.

## 🛠️ Paso a Paso de Configuración

1. **Crear el proyecto principal:**
   - Seleccionar **ASP.NET Core Web API** y presionar *Siguiente*.
   - **Nombre del proyecto:** `PizzeriaWebAPI`
   - **Nombre de la solución:** `Pizzeria2026`
   - **Framework:** `.NET 8.0 (LTS)`

2. **Agregar las capas (Biblioteca de clases) a la solución:**
   - Clic derecho en la Solución $\rightarrow$ **Agregar** $\rightarrow$ **Nuevo proyecto**.
   - Seleccionar la plantilla **Biblioteca de clases (Class Library)** en C# / .NET 8.0.
   - **Nombre del proyecto:** `PizzeriaRepository`

3. **Referenciar las capas:**
   - Clic derecho en **Dependencias** (o Referencias) del proyecto `PizzeriaWebAPI` $\rightarrow$ **Agregar referencia de proyecto** y marcar la DLL.

4. **Crear las entidades en Domain:**
   - Crear en la carpeta `Domain` las clases `IngredientePizza` (Detalle) y `Pizza` (Maestro) configuradas con Data Annotations.

5. **Instalar paquetes NuGet:**
   - Instalar paquetes NuGet en la solución para ambos proyectos (Versión `8.0.x`):
     - `Microsoft.EntityFrameworkCore.SqlServer`
     - `Microsoft.EntityFrameworkCore.Tools`

6. **Crear el DbContext:**
   - Crear la clase `PizzeriaDbContext` heredando de `DbContext`.

7. **Crear Capa de Datos (Repository):**
   - Crear interfaz `IPizzaRepository` y su implementación asíncrona `PizzaRepository`.

8. **Configurar `appsettings.json` y `Program.cs`:**
   - Borrar el controlador de ejemplo `WeatherForecast`.
   - `appsettings.json`: Agregar la cadena de conexión (`ConnectionString`).
   - `Program.cs`: Agregar las referencias al repositorio/contexto y registrar la Inyección de Dependencias.

9. **Crear Capa de Negocio:**
   - Crear la clase `PizzaService` e inyectar `IPizzaRepository`.

10. **Crear Controlador REST:**
    - Crear `PizzasController.cs` heredando de `ControllerBase` e inyectando `PizzaService`.

---

## 🚀 Endpoints Expuestos

```http
GET    /api/pizzas
GET    /api/pizzas/{id}
POST   /api/pizzas
PUT    /api/pizzas/{id}
DELETE /api/pizzas/{id}
