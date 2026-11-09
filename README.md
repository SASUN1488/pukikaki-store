# PukiKakiOS Store

Каталог магазина приложений для оболочки PukiKakiOS (портативная консоль на RK3566, Debian arm64 под оболочкой).

## Как устроено
- `catalog.json` — список приложений. Консоль скачивает его при наличии интернета: новое приложение = новая запись здесь.
- `icons/` — значки 128×128.
- `scripts/` — установщики для приложений, которых нет в репозиториях Debian (`APPDIR` — папка приложения).
- `tools/nkstore` — установщик на консоли (bash + jq + curl, внутри Debian): `update`, `install <id>`, `remove <id>`, `installed`.
  Прогресс для оболочки — строки `@P <проценты> <текст>`, итог — `@OK` / `@ERR <текст>`.

## Запись приложения
```json
{
  "id": "scummvm", "name": "ScummVM", "category": "games",
  "summary": "Коротко", "description": "Подробно",
  "icon": "icons/scummvm.png", "size_mb": 70,
  "status": "beta | soon (необязательно)",
  "install": {"type": "apt", "packages": ["scummvm"]}            // или {"type": "script", "script": "scripts/x.sh"}
  "run": {"mode": "game | kiosk", "cmd": "команда", "input": "gamepad | keyboard | mouse"}
}
```
- `mode: game` — приложение само рисует на весь экран (SDL/DRM); `kiosk` — запускается в Wayland-киоске cage.
- `input` — как кнопки консоли видит приложение: геймпад, клавиатура или мышь (стик — курсор).
