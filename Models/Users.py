from Models.Base import *
from Models.Roles import Roles
from flask_login import UserMixin
from peewee import PrimaryKeyField, CharField, BooleanField, DateTimeField, ForeignKeyField
import datetime

class Users(UserMixin, Base):
    id = PrimaryKeyField()
    username = CharField(unique=True, max_length=50)
    password = CharField(max_length=255)
    first_name = CharField(max_length=50)
    last_name = CharField(max_length=50)
    phone = CharField(max_length=20)
    email = CharField(unique=True, max_length=100)
    role_id = ForeignKeyField(Roles, backref='users')
    is_active = BooleanField(default=True)
    created_at = DateTimeField()
    last_login = DateTimeField(null=True)

    class Meta:
        table_name = 'users'
        db_table = 'users'

    def get_full_name(self):
        return f"{self.first_name} {self.last_name}"

if __name__ == "__main__":
    pass