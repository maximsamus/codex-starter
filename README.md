# Codex Starter

Русский шаблон для настройки проекта в Codex: правила `AGENTS.md`, сценарий первого запуска и проверки безопасности. Подходит для отдельного учебного проекта или подготовки своей рабочей копии.

Это форк [arseniy-io/codex-starter](https://github.com/arseniy-io/codex-starter). В оригинальной MIT-лицензии указан **Artemii Miller / Школа Смысло-кодинга**. Авторство оригинала сохранено; локальные дополнения - Maxim Samus.

## Минимальный запуск

Нужны Git, Python 3 для проверок и установленный Codex с настроенным доступом.

```bash
git clone https://github.com/maximsamus/codex-starter.git moy-proekt
cd moy-proekt
python3 scripts/starter-lint.py
codex
```

В открывшемся Codex напишите:

> Это учебный проект: страница со списком книг. Проведи меня через первый запуск. Ничего не публикуй, не подключай платежи и не меняй настройки компьютера.

Codex должен прочитать `AGENTS.md`, проверить состояние в `.codex/autopilot-state.yml` и предложить настройку по `AUTOPILOT.md`. Это сценарий работы с агентом; поведение модели зависит от выбранного клиента и версии.

Если нужны запуск клиента и первый запрос, есть [инструкция по работе с Codex](https://claudebase.ru/stati/codex-kak-polzovatsya/?utm_source=github&utm_medium=referral&utm_campaign=codex-starter&utm_content=readme-guide).

## Что есть в шаблоне

- `AGENTS.md` - правила работы агента. `PROJECT_STATE.md` - краткое состояние проекта.
- `AUTOPILOT.md` и `POST_AUTOPILOT.md` - два этапа настройки.
- `templates/` и `examples/` - шаблоны и учебные примеры.
- `scripts/` - локальные проверки структуры и безопасности.
- `.codex/` - конфигурация, состояние настройки и hook-policy.
- `prompts/` - задания под отдельные этапы работы; начинайте с `prompts/INDEX.md`.
- `plans/` и `retrospectives/` - планы и итоги работы.
- `ai-clone/` и `mastery/` - пустые шаблоны контекста; заполненного личного профиля и файлов отдельных мастеров в них нет.
- `maintainer/` - старые отчёты разработки оригинала, в том числе с локальными Windows-путями. Они сохранены как часть истории и требуют отдельного просмотра перед дальнейшим распространением.

Полная карта - в [STRUCTURE.md](./STRUCTURE.md). В `examples/coffeeshop/business/` есть учебные бизнес-данные. Корневая папка `business/` создаётся при настройке и игнорируется Git. В ней `life-metrics.md` хранит проверенные показатели, а `raw/` - исходные материалы пользователя.

## Проверки

Из корня шаблона:

```bash
python3 scripts/starter-lint.py
bash scripts/security-audit.sh
bash scripts/user-project-safety-check.sh
```

Первая команда проверяет структуру, локальные ссылки и hook-policy. После заполнения пользовательской копии применяйте `python3 scripts/starter-lint.py --onboarded`: это другой режим проверки.

Shell-скрипты дают дополнительную проверку известных шаблонов секретов. Их успешный результат не заменяет просмотр файлов перед публикацией.

## Перед переносом в свой проект

Проверьте `git remote -v`: по умолчанию `origin` ведёт на репозиторий шаблона. Заполненные личные и бизнес-файлы храните приватно, секреты в Git не добавляйте.

Файлы hooks в шаблоне требуют поддержки и доверия со стороны выбранной версии Codex. Проверка Python подтверждает поведение policy-скрипта, но не доказывает, что ваш клиент его подключил. Подробности - в [TROUBLESHOOTING.md](./TROUBLESHOOTING.md).

Этот репозиторий не устанавливает клиент Codex, не включает доступ к OpenAI и не гарантирует поведение модели или лимиты.

## Официальная документация

- [Codex](https://developers.openai.com/codex)
- [Правила AGENTS.md](https://developers.openai.com/codex/guides/agents-md)
- [Скиллы](https://developers.openai.com/codex/skills)

## Лицензия

[MIT](./LICENSE). Уведомление автора оригинала и уведомление об адаптации сохранены в LICENSE.
