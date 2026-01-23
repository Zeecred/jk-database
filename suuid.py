import math
import random
import time
import hashlib
import uuid
from datetime import datetime
from zoneinfo import ZoneInfo
from src.logger import logger


def calc_entropy(s: str) -> float:
    freq = {}
    for char in s:
        freq[char] = freq.get(char, 0) + 1
    entropy = 0.0
    total = len(s)
    for count in freq.values():
        p = count / total
        entropy -= p * math.log2(p)
    return entropy

def gen_uuid() -> str:
    return str(uuid.uuid4())

def dec2hex(number: str) -> str:
    n = int(number)
    return hex(n)[2:].upper()

def gen_suuid(prefix: str = '', max_len: int = 18) -> str:
    charset = "qwertyuiopasdfghjklzxcvbnm" + \
              "QWERTYUIOPASDFGHJKLZXCVBNM" + \
              "0123456789_"
    prefix = prefix.rjust(2, '0')

    now = datetime.now(ZoneInfo("UTC"))
    day_of_year = now.timetuple().tm_yday
    btime = int(time.strftime('%H')) * 3600 + int(time.strftime('%M')) * 60 + int(time.strftime('%S'))
    bmetric = int(btime / 86.4)  # Swatch Internet Time

    ts = f"{now.year % 100:02d}{day_of_year:03d}{bmetric:03d}"
    ts_hex = dec2hex(ts)
    ret = prefix + ts_hex

    while len(ret) < max_len:
        ret += random.choice(charset)

    return ret[:max_len]

# Exemplo e entropia
def print_entropy_test():
    largo = 20
    print("\nGerando SUUID")
    print(f"# - {'SUUID'.ljust(largo)} - Entropia")
    e = 0
    for i in range(10):
        suuid = gen_suuid("xyz", largo)
        entropy = calc_entropy(suuid)
        e += entropy
        print(f"{i} - {suuid} - {entropy:.4f}")
    print(f"Entropia média = {e / 10:.4f}")

    largo = 12
    print("\nGerando md5(SUUID)")
    print(f"# - {'SUUID'.ljust(32)} - Entropia")
    e = 0
    for i in range(10):
        suuid = gen_suuid("xyz", largo)
        md5_suuid = hashlib.md5(suuid.encode()).hexdigest()
        entropy = calc_entropy(md5_suuid)
        e += entropy
        print(f"{i} - {md5_suuid} - {entropy:.4f}")
    print(f"Entropia média = {e / 10:.4f}")

    print("\nGerando UUID canônico")
    print(f"# - {'UUID'.ljust(36)} - Entropia")
    e = 0
    for i in range(10):
        uid = gen_uuid()
        entropy = calc_entropy(uid)
        e += entropy
        print(f"{i} - {uid} - {entropy:.4f}")
    print(f"Entropia média = {e / 10:.4f}")

if __name__ == "__main__":
    print_entropy_test()
    suuid = gen_suuid("xyz")
    print(f"SUUID: {suuid}")
    print(f"md5(SUUID): {hashlib.md5(suuid.encode()).hexdigest()}")
    print(f"UUID canônico: {gen_uuid()}")