import re


GRANT_RE = re.compile(r"^GRANT\s+(.+?)\s+ON\s+(.+?)\s+TO\s+", re.IGNORECASE)
SCHEMA_SCOPE_RE = re.compile(r"^`?([A-Za-z0-9_]+)`?\.\*$")


def _normalize_privilege(privilege):
    text = str(privilege or "").strip().upper()
    if text in {"ALL", "ALL PRIVILEGES"}:
        return "ALL PRIVILEGES"
    return text


def _split_privileges(privileges_text):
    return {
        _normalize_privilege(part)
        for part in str(privileges_text or "").split(",")
        if str(part or "").strip()
    }


def _parse_scope(scope_text):
    scope = str(scope_text or "").strip()
    if scope == "*.*":
        return {"scope_type": "global", "database": None}
    match = SCHEMA_SCOPE_RE.fullmatch(scope)
    if match:
        return {"scope_type": "schema", "database": match.group(1)}
    return {"scope_type": "other", "database": scope}


def fetch_current_grants(cursor):
    cursor.execute("SHOW GRANTS FOR CURRENT_USER")
    grants = []
    for row in cursor.fetchall():
        statement = str(row[0] or "").strip()
        match = GRANT_RE.match(statement)
        if not match:
            continue
        grant = _parse_scope(match.group(2))
        grant["statement"] = statement
        grant["privileges"] = _split_privileges(match.group(1))
        grant["with_grant_option"] = " WITH GRANT OPTION" in statement.upper()
        grants.append(grant)
    return grants


def _scope_matches(grant, database=None, require_global=False):
    if require_global:
        return grant["scope_type"] == "global"
    if grant["scope_type"] == "global":
        return True
    if database is None:
        return False
    return grant["scope_type"] == "schema" and grant["database"] == database


def _privileges_cover(grant, required_privileges, require_grant_option=False):
    if require_grant_option and not grant["with_grant_option"]:
        return False
    if "ALL PRIVILEGES" in grant["privileges"]:
        return True
    normalized = {_normalize_privilege(item) for item in required_privileges}
    return normalized.issubset(grant["privileges"])


def describe_current_grants(grants):
    if not grants:
        return "No parsable grants returned by SHOW GRANTS FOR CURRENT_USER."
    return "\n".join(grant["statement"] for grant in grants)


def ensure_can_create_databases(cursor):
    grants = fetch_current_grants(cursor)
    for grant in grants:
        if _scope_matches(grant, require_global=True) and _privileges_cover(grant, {"CREATE"}):
            return
    raise PermissionError(
        "Current MySQL account does not have CREATE on *.* required to create databases.\n"
        + describe_current_grants(grants)
    )


def ensure_can_manage_users(cursor, required_schema_privileges):
    grants = fetch_current_grants(cursor)

    has_create_user = any(
        _scope_matches(grant, require_global=True)
        and _privileges_cover(grant, {"CREATE USER"})
        for grant in grants
    )
    if not has_create_user:
        raise PermissionError(
            "Current MySQL account does not have CREATE USER on *.* required to manage users.\n"
            + describe_current_grants(grants)
        )

    missing = []
    for database_name, privileges in sorted((required_schema_privileges or {}).items()):
        normalized = {_normalize_privilege(item) for item in privileges if str(item or "").strip()}
        if not normalized:
            continue
        allowed = any(
            _scope_matches(grant, database=database_name)
            and _privileges_cover(grant, normalized, require_grant_option=True)
            for grant in grants
        )
        if not allowed:
            missing.append((database_name, ", ".join(sorted(normalized))))

    if missing:
        details = "\n".join(
            f"- {database_name}: requires WITH GRANT OPTION for {privileges}"
            for database_name, privileges in missing
        )
        raise PermissionError(
            "Current MySQL account cannot grant the requested privileges.\n"
            f"{details}\n"
            f"{describe_current_grants(grants)}"
        )
