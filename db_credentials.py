import json
from pathlib import Path


ROOT_ENV_PATH = Path(__file__).resolve().parent.parent / ".env"
FALLBACK_CREDENTIALS_PATH = Path(__file__).resolve().parent / "my-credentials.json"


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
