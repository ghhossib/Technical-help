from Models.Base import *
from peewee import PrimaryKeyField, CharField, TextField, DateTimeField
import datetime

class Roles(Base):
    id = PrimaryKeyField()
    name = CharField(unique=True, max_length=50)
    description = TextField(null=True)
    permissions = TextField(null=True)
    created_at = DateTimeField()

    class Meta:
        table_name = 'roles'
        db_table = 'roles'

if __name__ == "__main__":
    pass