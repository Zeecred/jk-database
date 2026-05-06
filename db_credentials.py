import json
from pathlib import Path


ROOT_ENV_PATH = Path(__file__).resolve().parent.parent / ".env"
FALLBACK_CREDENTIALS_PATH = Path(__file__).resolve().parent / "my-credentials.json"
MYSQL_ADMIN_KEYS = (
    "MYSQL_ADMIN_HOST",
    "MYSQL_ADMIN_PORT",
    "MYSQL_ADMIN_USER",
    "MYSQL_ADMIN_PASSWORD",
)


def load_env_map(path):
    env_path = Path(path)
    if not env_path.exists():
        return {}
    result = {}
    for raw in env_path.read_text(encoding="utf-8", errors="ignore").splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        result[key.strip()] = value.strip().strip('"').strip("'")
    return result


def load_json_file(path):
    json_path = Path(path)
    if not json_path.exists():
        return {}
    with json_path.open(encoding="utf-8") as handle:
        return json.load(handle)


def _pick_first(values):
    for value in values:
        if value is None:
            continue
        text = str(value).strip()
        if text != "":
            return text
    return None


def load_db_credentials():
    env_map = load_env_map(ROOT_ENV_PATH)
    fallback = load_json_file(FALLBACK_CREDENTIALS_PATH)
    admin_values = {key: env_map.get(key) for key in MYSQL_ADMIN_KEYS}
    admin_present = [key for key, value in admin_values.items() if value is not None]

    if admin_present:
        missing_admin = [key for key in MYSQL_ADMIN_KEYS if not str(admin_values.get(key) or "").strip()]
        if missing_admin:
            missing_text = ", ".join(missing_admin)
            raise RuntimeError(
                f"MYSQL_ADMIN_* variables must all be present and non-empty in {ROOT_ENV_PATH}. "
                f"Missing: {missing_text}."
            )
        return {
            "host": admin_values["MYSQL_ADMIN_HOST"].strip(),
            "port": int(admin_values["MYSQL_ADMIN_PORT"]),
            "username": admin_values["MYSQL_ADMIN_USER"].strip(),
            "password": admin_values["MYSQL_ADMIN_PASSWORD"],
        }

    host = _pick_first([
        env_map.get("MYSQL_HOST"),
        env_map.get("DB_HOST"),
        fallback.get("host"),
    ])
    port = _pick_first([
        env_map.get("MYSQL_EXPOSED_PORT"),
        env_map.get("MYSQL_PORT"),
        env_map.get("DB_PORT"),
        fallback.get("port"),
    ])
    username = _pick_first([
        env_map.get("MYSQL_ROOT_USER"),
        env_map.get("MYSQL_USER"),
        env_map.get("DB_USERNAME"),
        fallback.get("username"),
    ])
    password = _pick_first([
        env_map.get("MYSQL_ROOT_PASSWORD"),
        env_map.get("MYSQL_PASSWORD"),
        env_map.get("DB_PASSWORD"),
        fallback.get("password"),
    ])

    missing = [name for name, value in {
        "host": host,
        "port": port,
        "username": username,
        "password": password,
    }.items() if value is None]
    if missing:
        missing_text = ", ".join(missing)
        raise RuntimeError(
            f"Missing DB credentials: {missing_text}. "
            f"Expected them in {ROOT_ENV_PATH} or {FALLBACK_CREDENTIALS_PATH}."
        )

    return {
        "host": host,
        "port": int(port),
        "username": username,
        "password": password,
    }
