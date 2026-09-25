# WebApi_EF_Pizzeria_Vacio
Paso a Paso para creación de Web Api con DLL:
1- Crear el proyecto principal:
	Seleccionar ASP.NET Core Web API y le das a Siguiente.
	Nombre del proyecto: PizzeriaWebAPI
	Nombre de la solución: Pizzeria2026.
	Marco: .NET 8.0 (LTS).
2- Agregar las capas (Bibliotecas de clases) a la misma solución:
	Hacer clic derecho sobre la Solución recién creada → Agregar → Nuevo proyecto.
	Seleccionar la plantilla Biblioteca de clases (Class Library) en C# / .NET 8.0.
	Nombre del proyecto: PizzeriaRepository.
3- Referenciar las capas:
	Hacer clic derecho en Dependencias (o Referencias) del proyecto PizzeriaWebAPI → Agregar referencia de proyecto y marcás la biblioteca de clases.
4- Crear en Domain las clases: IngredientePizza (Detalle) y Pizza (Maestro) con Data Annotations.
5- Instalar paquetes NuGet en la solución->para ambos proyectos – Version 8.0.x
6- Crear PizzeriaDbContext
7- Crear interfaz e implementación (Async)
8- Configurar appsettings.json y Program.cs (de la WebApi)
	borrar WeatherForecast
	appsetting.json: agregamos cadena de conexión.
	Program.cs: agregar las referencias a nuestro repositorio/contexto y a registrar la inyección de dependencias.
9- Creamos el PizzaService
10- Creamos el Controlador PizzasController.cs (API en blanco) 
Crear el controlador PizzasController.cs heredando de ControllerBase e inyectando PizzaService para exponer los endpoints:
	GET /api/pizzas
	GET /api/pizzas/{id}
	POST /api/pizzas
	PUT /api/pizzas/{id}
	DELETE /api/pizzas/{id}
// Con EF: 
Chau DataHelper
Chau SPparameter
Chau SP para CRUD
.. la vida mas simple.
