from Models.Base import *
from Models.Users import Users
from peewee import PrimaryKeyField, CharField, TextField, BooleanField, DateTimeField, ForeignKeyField
import datetime

class Computers(Base):
    id = PrimaryKeyField()
    user_id = ForeignKeyField(Users, backref='computers')
    pc_name = CharField(max_length=100)
    ip_address = CharField(max_length=45)
    mac_address = CharField(max_length=17, null=True)
    operating_system = CharField(max_length=100)
    specifications = TextField(null=True)
    is_active = BooleanField(default=True)
    created_at = DateTimeField()
    last_seen = DateTimeField(null=True)

    class Meta:
        table_name = 'computers'
        db_table = 'computers'

if __name__ == "__main__":
    pass