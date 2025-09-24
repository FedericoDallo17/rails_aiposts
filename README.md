# Rails AI Posts API

Una API de red social construida con Rails 8.0 que permite a los usuarios crear posts, comentar, dar likes, seguir a otros usuarios y recibir notificaciones.

## Características

### Autenticación
- Registro de usuarios
- Inicio de sesión
- Cierre de sesión
- Recuperación de contraseña
- Cambio de email
- Cambio de contraseña
- Eliminación de cuenta

### Interacciones con Posts
- Crear posts
- Comentar en posts
- Dar like a posts
- Ver lista de comentarios
- Ver lista de likes

### Interacciones de Usuario
- Seguir a otros usuarios
- Ver lista de seguidores
- Ver lista de usuarios seguidos
- Ver posts que les gustaron
- Ver posts que comentaron

### Interacciones Sociales
- Ver posts donde fueron mencionados
- Ver posts donde fueron etiquetados

### Notificaciones
- Ver lista de notificaciones
- Ver notificaciones leídas
- Ver notificaciones no leídas
- Marcar notificación como leída
- Marcar notificación como no leída

### Feed
- Ver feed (posts de usuarios seguidos)

### Búsqueda
- Buscar usuarios por nombre, username, email, ubicación
- Buscar posts por contenido, usuario, tags, comentarios
- Ordenar posts por más recientes, más antiguos, más gustados, más comentados

### Configuración
- Cambiar foto de perfil
- Cambiar foto de portada
- Cambiar biografía
- Cambiar sitio web
- Cambiar email
- Cambiar contraseña
- Eliminar cuenta

## Tecnologías Utilizadas

- **Rails 8.0**
- **Ruby 3.4.4**
- **PostgreSQL**
- **JBuilder** para respuestas JSON
- **JWT** para autenticación
- **Active Storage** para archivos
- **Active Job** para procesamiento en background
- **RSpec** y **FactoryBot** para testing
- **Swagger** para documentación API
- **Brakeman** para análisis de seguridad
- **Rubocop** para linting

## Instalación

1. Clona el repositorio
2. Instala las dependencias:
   ```bash
   bundle install
   ```

3. Configura la base de datos:
   ```bash
   rails db:create
   rails db:migrate
   ```

4. Inicia el servidor:
   ```bash
   rails server
   ```

## Uso de la API

### Autenticación

#### Registro
```bash
POST /api/v1/auth/signup
Content-Type: application/json

{
  "user": {
    "first_name": "John",
    "last_name": "Doe",
    "username": "johndoe",
    "email": "john@example.com",
    "password": "password123"
  }
}
```

#### Inicio de sesión
```bash
POST /api/v1/auth/signin
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

### Posts

#### Crear un post
```bash
POST /api/v1/posts
Authorization: Bearer <token>
Content-Type: application/json

{
  "post": {
    "content": "Este es mi primer post",
    "tags": "programming,rails"
  }
}
```

#### Obtener feed
```bash
GET /api/v1/posts/feed
Authorization: Bearer <token>
```

### Usuarios

#### Seguir a un usuario
```bash
POST /api/v1/users/{id}/follow
Authorization: Bearer <token>
```

#### Buscar usuarios
```bash
GET /api/v1/users/search?name=john
Authorization: Bearer <token>
```

### Notificaciones

#### Obtener notificaciones
```bash
GET /api/v1/notifications
Authorization: Bearer <token>
```

#### Marcar como leída
```bash
PUT /api/v1/notifications/{id}/mark_read
Authorization: Bearer <token>
```

## Documentación de la API

La documentación completa de la API está disponible en Swagger UI:
- Desarrollo: `http://localhost:3000/api-docs`

## Testing

Ejecuta los tests con:
```bash
rspec
```

## Jobs en Background

La aplicación incluye varios jobs para procesamiento en background:

- **NotificationJob**: Envía notificaciones por email, push y SMS
- **ImageProcessingJob**: Procesa imágenes en diferentes tamaños
- **CleanupJob**: Limpia datos antiguos

## Seguridad

- Autenticación JWT
- Validaciones de entrada
- Análisis de seguridad con Brakeman
- CORS configurado

## Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request
