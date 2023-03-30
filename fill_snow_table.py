#!/usr/bin/env python3
import snowflake.connector
import os
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives.asymmetric import dsa
from cryptography.hazmat.primitives import serialization
with open("/home/ubuntu/.ssh/elina_tf_test_user.p8", "rb") as key:
    p_key= serialization.load_pem_private_key(
        key.read(),
        None,
        backend=default_backend()
    )

pkb = p_key.private_bytes(
    encoding=serialization.Encoding.DER,
    format=serialization.PrivateFormat.PKCS8,
    encryption_algorithm=serialization.NoEncryption())

ctx = snowflake.connector.connect(
    user='elina_tf_test_user',
    account='bk68410.ca-central-1.aws',
    private_key=pkb,
    warehouse='ELINA_TF_WH',
    database='ELINA_TF_DB',
    schema='ELINA_TF_SC'
    )

# Gets the version
cs = ctx.cursor()
try:
    cs.execute("SELECT current_version()")
    cs.execute(
            "INSERT INTO ELINA_TF_TABLE "
            "VALUES(123, 'Elina testing string1', TIMESTAMP '2023-03-31T21:33:15')")
finally:
    cs.close()
ctx.close()
