#!/usr/bin/env python3
import json
from datetime import datetime
from pathlib import Path
import types
import sys

BASE_DIR = Path(__file__).resolve().parent
INPUT_JSON = BASE_DIR / "dados-inventados" / "dados-br.json"
OUTPUT_DIR = BASE_DIR / "dados-inventados"
SUUID_SEED = "tst"
SUUID_LENGTH = 36

try:
    from suuid import gen_suuid
except ModuleNotFoundError as exc:
    if exc.name != "src":
        raise
    src_module = types.ModuleType("src")
    logger_module = types.ModuleType("src.logger")
    logger_module.logger = None
    sys.modules["src"] = src_module
    sys.modules["src.logger"] = logger_module
    from suuid import gen_suuid

STATE_NAMES = {
    "AC": "Acre",
    "AL": "Alagoas",
    "AP": "Amapa",
    "AM": "Amazonas",
    "BA": "Bahia",
    "CE": "Ceara",
    "DF": "Distrito Federal",
    "ES": "Espirito Santo",
    "GO": "Goias",
    "MA": "Maranhao",
    "MT": "Mato Grosso",
    "MS": "Mato Grosso do Sul",
    "MG": "Minas Gerais",
    "PA": "Para",
    "PB": "Paraiba",
    "PR": "Parana",
    "PE": "Pernambuco",
    "PI": "Piaui",
    "RJ": "Rio de Janeiro",
    "RN": "Rio Grande do Norte",
    "RS": "Rio Grande do Sul",
    "RO": "Rondonia",
    "RR": "Roraima",
    "SC": "Santa Catarina",
    "SP": "Sao Paulo",
    "SE": "Sergipe",
    "TO": "Tocantins",
}


def normalize_digits(value):
    if not value:
        return ""
    return "".join(ch for ch in value if ch.isdigit())


def sql_escape(value):
    return value.replace("\\", "\\\\").replace("'", "''")


def sql_value(value):
    if value is None:
        return "NULL"
    return f"'{sql_escape(str(value))}'"


def generate_id():
    return gen_suuid(SUUID_SEED, SUUID_LENGTH)


def parse_date(value):
    if not value:
        return None
    try:
        return datetime.strptime(value, "%d/%m/%Y").date().isoformat()
    except ValueError:
        return None


def add_person_data(rows, person_id, key, value, value_type="string"):
    if value is None:
        return
    if isinstance(value, str) and value.strip() == "":
        return
    data_id = generate_id()
    rows.append((data_id, person_id, key, str(value), value_type))


def insert_block(table, columns, rows):
    if not rows:
        return []
    cols = ", ".join(f"`{col}`" for col in columns)
    lines = [f"INSERT INTO `{table}` ({cols}) VALUES"]
    for idx, row in enumerate(rows):
        values = ", ".join(sql_value(value) for value in row)
        suffix = "," if idx < len(rows) - 1 else ";"
        lines.append(f"  ({values}){suffix}")
    return lines


def main():
    data = json.loads(INPUT_JSON.read_text(encoding="utf-8"))

    contact_types = {
        "email": generate_id(),
        "mobile": generate_id(),
        "phone": generate_id(),
    }

    states = {}
    cities = {}
    banks = {}
    persons = []
    persons_individual = []
    persons_data = []
    customers = []
    addresses = []
    contacts = []
    banks_accounts = []
    customer_has_addresses = []
    customer_has_contacts = []
    customer_has_banks_accounts = []

    for entry in data:
        state_acronym = (entry.get("estado") or "").strip().upper()
        city_name = (entry.get("localidade") or "").strip() or "Cidade desconhecida"
        if state_acronym:
            state_id = states.get(state_acronym)
            if not state_id:
                state_id = generate_id()
                states[state_acronym] = state_id
            city_key = (state_acronym, city_name)
            if city_key not in cities:
                city_id = generate_id()
                cities[city_key] = (city_id, state_id, city_name, None)
        else:
            state_id = None
            city_id = None

        cpf_digits = normalize_digits(entry.get("cpf"))
        person_id = generate_id()
        persons.append((person_id, None, "individual", 2))
        persons_individual.append(
            (person_id, None, None, 0, cpf_digits, entry.get("nomeCompleto"))
        )

        birth_date = parse_date(entry.get("dataNascimento"))
        add_person_data(persons_data, person_id, "birth_date", birth_date, "date")

        gender = entry.get("genero")
        if gender == "Masculino":
            gender_value = 1
        elif gender == "Feminino":
            gender_value = 2
        else:
            gender_value = 3
        add_person_data(persons_data, person_id, "gender", gender_value, "int")

        add_person_data(persons_data, person_id, "race_color", entry.get("racaCor"))
        add_person_data(
            persons_data, person_id, "sexual_orientation", entry.get("orientacaoSexual")
        )
        add_person_data(
            persons_data, person_id, "gender_identity", entry.get("identidadeGenero")
        )
        add_person_data(persons_data, person_id, "blood_type", entry.get("tipoSanguineo"))
        add_person_data(persons_data, person_id, "nickname", entry.get("apelido"))
        add_person_data(persons_data, person_id, "mother_name", entry.get("mae"))
        add_person_data(persons_data, person_id, "father_name", entry.get("pai"))

        add_person_data(persons_data, person_id, "rg", entry.get("rg"))
        add_person_data(persons_data, person_id, "cnh", entry.get("cnh"))
        add_person_data(
            persons_data, person_id, "cnh_category", entry.get("cnhCategoria")
        )
        add_person_data(
            persons_data, person_id, "titulo_eleitor", entry.get("tituloEleitor")
        )
        add_person_data(persons_data, person_id, "pis", entry.get("pis"))
        add_person_data(persons_data, person_id, "cns", entry.get("cns"))
        add_person_data(persons_data, person_id, "passaporte", entry.get("passaporte"))
        add_person_data(
            persons_data, person_id, "certidao_nascimento", entry.get("certidaoNascimento")
        )
        add_person_data(
            persons_data, person_id, "certidao_casamento", entry.get("certidaoCasamento")
        )
        add_person_data(
            persons_data, person_id, "certidao_obito", entry.get("certidaoObito")
        )

        card_exp = parse_date(entry.get("cartaoDataExpiracao"))
        add_person_data(persons_data, person_id, "cartao_numero", entry.get("cartaoNumero"))
        add_person_data(
            persons_data, person_id, "cartao_bandeira", entry.get("cartaoBandeira")
        )
        add_person_data(persons_data, person_id, "cartao_cvv", entry.get("cartaoCVV"))
        add_person_data(
            persons_data, person_id, "cartao_data_expiracao", card_exp, "date"
        )
        add_person_data(
            persons_data, person_id, "cartao_nome_titular", entry.get("cartaoNomeTitular")
        )

        add_person_data(persons_data, person_id, "company_nome", entry.get("nomeEmpresa"))
        add_person_data(persons_data, person_id, "company_cnpj", entry.get("cnpj"))
        add_person_data(
            persons_data, person_id, "company_cnpj_alfanumerico", entry.get("cnpjAlfanumerico")
        )
        add_person_data(
            persons_data, person_id, "company_ie", entry.get("inscricaoEstadual")
        )
        add_person_data(persons_data, person_id, "placa_antiga", entry.get("placaAntiga"))
        add_person_data(
            persons_data, person_id, "placa_mercosul", entry.get("placaMercosul")
        )
        add_person_data(persons_data, person_id, "renavam", entry.get("renavam"))

        customer_id = generate_id()
        customers.append((customer_id, person_id, None, None, "active"))

        if city_name and state_acronym:
            city_id = cities[(state_acronym, city_name)][0]
            address_id = generate_id()
            street = entry.get("logradouro") or "Endereco desconhecido"
            addresses.append(
                (
                    address_id,
                    city_id,
                    "Principal",
                    street,
                    entry.get("numero"),
                    None,
                    entry.get("bairro"),
                    entry.get("cep"),
                )
            )
            customer_has_addresses.append((customer_id, address_id))

        email = entry.get("email")
        if email:
            contact_id = generate_id()
            contacts.append((contact_id, contact_types["email"], email))
            customer_has_contacts.append((customer_id, contact_id))

        mobile = entry.get("celular")
        if mobile:
            contact_id = generate_id()
            contacts.append((contact_id, contact_types["mobile"], mobile))
            customer_has_contacts.append((customer_id, contact_id))

        phone = entry.get("telefone")
        if phone:
            contact_id = generate_id()
            contacts.append((contact_id, contact_types["phone"], phone))
            customer_has_contacts.append((customer_id, contact_id))

        bank_code = normalize_digits(entry.get("contaCodigoBanco"))
        bank_name = entry.get("contaNomeBanco")
        if bank_code and bank_name:
            bank_code = bank_code.zfill(3)
            if bank_code not in banks:
                bank_id = generate_id()
                banks[bank_code] = (bank_id, bank_name, bank_code)
            bank_id = banks[bank_code][0]
            agency = entry.get("contaAgencia")
            agency_dv = entry.get("contaAgenciaDv")
            if agency_dv:
                agency_number = f"{agency}-{agency_dv}"
            else:
                agency_number = agency
            account = entry.get("contaNumero")
            account_dv = entry.get("contaNumeroDv")
            if account_dv:
                account_number = f"{account}-{account_dv}"
            else:
                account_number = account

            bank_account_id = generate_id()
            banks_accounts.append(
                (bank_account_id, bank_id, agency_number, account_number, "C")
            )
            customer_has_banks_accounts.append((customer_id, bank_account_id))

    sql_lines = []
    sql_lines.append("SET NAMES utf8mb4;")
    sql_lines.append("START TRANSACTION;")

    state_rows = [
        (states[acronym], acronym, STATE_NAMES.get(acronym, acronym), None)
        for acronym in sorted(states.keys())
    ]
    sql_lines.extend(insert_block("states", ["id", "acronym", "name", "ibge_code"], state_rows))

    city_rows = [cities[key] for key in sorted(cities.keys())]
    sql_lines.extend(insert_block("cities", ["id", "state_id", "name", "ibge_code"], city_rows))

    contact_type_rows = [
        (contact_types["email"], "email"),
        (contact_types["mobile"], "mobile"),
        (contact_types["phone"], "phone"),
    ]
    sql_lines.extend(
        insert_block("contacts_types", ["id", "name"], contact_type_rows)
    )

    bank_rows = [banks[code] for code in sorted(banks.keys())]
    sql_lines.extend(insert_block("banks", ["id", "name", "code"], bank_rows))

    sql_lines.extend(
        insert_block("persons", ["id", "parent_id", "type", "paper"], persons)
    )
    sql_lines.extend(
        insert_block(
            "persons_individual",
            ["id", "occupation_id", "naturalness_city_id", "is_pep", "document", "name"],
            persons_individual,
        )
    )
    sql_lines.extend(
        insert_block(
            "persons_data",
            ["id", "person_id", "key", "value", "type"],
            persons_data,
        )
    )
    sql_lines.extend(
        insert_block(
            "customers",
            ["id", "person_id", "seller_id", "promoter_id", "status"],
            customers,
        )
    )

    sql_lines.extend(
        insert_block(
            "addresses",
            [
                "id",
                "city_id",
                "name",
                "street",
                "number",
                "complement",
                "neighborhood",
                "zip_code",
            ],
            addresses,
        )
    )
    sql_lines.extend(
        insert_block("contacts", ["id", "contact_type_id", "value"], contacts)
    )
    sql_lines.extend(
        insert_block(
            "banks_accounts",
            ["id", "bank_id", "agency_number", "account_number", "account_type"],
            banks_accounts,
        )
    )
    sql_lines.extend(
        insert_block(
            "customer_has_addresses", ["customer_id", "address_id"], customer_has_addresses
        )
    )
    sql_lines.extend(
        insert_block(
            "customer_has_contacts", ["customer_id", "contact_id"], customer_has_contacts
        )
    )
    sql_lines.extend(
        insert_block(
            "customer_has_banks_accounts",
            ["customer_id", "bank_account_id"],
            customer_has_banks_accounts,
        )
    )

    sql_lines.append("COMMIT;")
    sql_lines.append("")

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_path = OUTPUT_DIR / f"{timestamp}.sql"
    output_path.write_text("\n".join(sql_lines), encoding="utf-8")

    print(f"SQL written to {output_path}")


if __name__ == "__main__":
    main()
