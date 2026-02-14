# ASCP-Connect Mobile - Environment Variables

## Configuration de l'API

L'application mobile se connecte au backend SCH via l'URL configurée dans `lib/core/constants/app_constants.dart`.

### URL par défaut
```dart
defaultValue: 'https://sch-backend-production.up.railway.app'
```

### Changer l'URL de l'API

#### Option 1: Via --dart-define (Recommandé)
```bash
flutter run --dart-define=API_BASE_URL=https://sch-backend-production.up.railway.app
```

#### Option 2: Modifier app_constants.dart
Changez la valeur `defaultValue` dans le fichier:
```dart
static const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:3000', // Votre URL ici
);
```

### Environnements

**Production (Railway)**
```bash
flutter run --dart-define=API_BASE_URL=https://sch-backend-production.up.railway.app
```

**Développement Local**
```bash
# Android Emulator / Physical Device
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000

# iOS Simulator
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3000
```

### Vérifier la connexion

L'app affichera des messages d'erreur si elle ne peut pas se connecter au backend:
- "Pas de connexion internet. Mode offline activé." (Pas de réseau)
- "Délai de connexion dépassé" (Timeout)
- "Email ou mot de passe incorrect" (401 - Backend OK, credentials invalides)

### Endpoints utilisés

- `POST /api/auth/login` - Authentification
- `POST /api/auth/logout` - Déconnexion
- `GET /api/auth/me` - Profil utilisateur
- `POST /api/auth/refresh` - Refresh token

### Notes

- L'URL de production est maintenant configurée par défaut
- Le backend doit accepter les requêtes CORS depuis l'app mobile
- Les tokens JWT sont stockés de manière sécurisée avec `flutter_secure_storage`
