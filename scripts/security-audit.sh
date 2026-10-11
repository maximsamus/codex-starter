#!/usr/bin/env bash
# scripts/security-audit.sh
#
# Проверяет starter-template перед публикацией на GitHub:
# - нет инфраструктурных идентификаторов автора методологии
# - нет email / имён из окружения автора и его студентов
# - нет секретов в виде формальных паттернов
# - нет запрещённых файлов (.env, .env.local, .codex/config.local.toml)
#
# Запуск:
#   bash scripts/security-audit.sh
#
# Код выхода: 0 - чисто, 1 - найдены проблемы.
#
# Для реального пользовательского проекта после AUTOPILOT используй:
#   bash scripts/user-project-safety-check.sh

set -u

FAIL=0
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

red()   { printf "\033[31m%s\033[0m\n" "$*"; }
green() { printf "\033[32m%s\033[0m\n" "$*"; }
yellow(){ printf "\033[33m%s\033[0m\n" "$*"; }
hdr()   { printf "\n\033[1m=== %s ===\033[0m\n" "$*"; }

check() {
  local label="$1"
  shift
  local result
  # Исключаем scripts/ (сам аудит), .github/hooks/ (pre-commit hook использует те же regex-паттерны легитимно)
  result=$(grep -rnE "$@" . --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=scripts --exclude-dir=hooks 2>/dev/null)
  if [ -n "$result" ]; then
    red "FAIL: $label"
    echo "$result"
    FAIL=1
  else
    green "OK: $label"
  fi
}

hdr "1. Инфраструктура автора"
check "SSH IP / Docker UUID / платформенная БД / Coolify" \
  "46\.21\.244\.60|a6aoywq9ikx5et2jgwwm2vpe|platform_user|platform_db|COOLIFY_|YANDEX_CLOUD|ssh\s+root@"

hdr "2. Email сторонних лиц (студенты, клиенты)"
check "email-адреса (gmail/yandex/mail/list/inbox)" \
  "[a-z0-9._+-]+@(gmail|yandex|mail|list|inbox)\.(com|ru)"

hdr "3. Cohort / внутренние URL платформы"
check "COHORT_SLUG и disk.yandex.ru ссылки на слайды" \
  "COHORT_SLUG|\{COHORT|disk\.yandex\.ru/i/"

hdr "4. Формальные секреты"
check "API-ключи, токены в парах key=value" \
  -i "(api[_-]?key|secret|password|token|bearer)\s*[:=]\s*[\"'][^\"']{10,}"
check "Stripe / OpenAI live-ключи" \
  "sk-[a-zA-Z0-9]{20,}|sk_live_|sk_test_|BEGIN.*PRIVATE KEY"

hdr "5. Запрещённые файлы"
if [ -f .env ];                           then red "FAIL: .env present"; FAIL=1;                 else green "OK: no .env"; fi
if [ -f .env.local ];                     then red "FAIL: .env.local present"; FAIL=1;           else green "OK: no .env.local"; fi
if [ -f .codex/config.local.toml ];       then red "FAIL: .codex/config.local.toml"; FAIL=1; else green "OK: no config.local.toml"; fi

hdr "РЕЗУЛЬТАТ"
if [ $FAIL -eq 0 ]; then
  green "Все проверки пройдены - шаблон можно публиковать."
  exit 0
else
  red "Найдены проблемы - смотри выше. НЕ публикуй до исправления."
  exit 1
fi
