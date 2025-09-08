from Models.Base import *
from Models.Users import Users
from Models.Computers import Computers
from peewee import PrimaryKeyField, CharField, TextField, DateTimeField, ForeignKeyField
import datetime

class Tickets(Base):
    id = PrimaryKeyField()
    title = CharField(max_length=200)
    description = TextField()
    status = CharField(choices=[
        ('open', 'Открыт'),
        ('in_progress', 'В работе'),
        ('resolved', 'Решен'),
        ('cancelled', 'Отменен')
    ], default='open')
    priority = CharField(choices=[
        ('low', 'Низкий'),
        ('medium', 'Средний'),
        ('high', 'Высокий'),
        ('critical', 'Критический')
    ], default='medium')
    user_id = ForeignKeyField(Users, backref='tickets')
    computer_id = ForeignKeyField(Computers, backref='tickets')
    assigned_to = ForeignKeyField(Users, null=True, backref='assigned_tickets', field='id')
    created_at = DateTimeField()
    updated_at = DateTimeField()
    resolved_at = DateTimeField(null=True)
    closed_at = DateTimeField(null=True)

    class Meta:
        table_name = 'tickets'
        db_table = 'tickets'

if __name__ == "__main__":
    pass