from Models.Roles import *

class RolesController:
    # Метод вывода всех записей таблицы Роли
    @classmethod
    def get(cls):
        return Roles.select()

    @classmethod
    def show(cls, id):
        return Roles.get_or_none(Roles.id == id)

    @classmethod
    def show_by_name(cls, name):
        return Roles.get_or_none(Roles.name == name)

    @classmethod
    def add(cls, name, description=None, permissions=None):
        Roles.create(
            name=name,
            description=description,
            permissions=permissions
        )

    @classmethod
    def update(cls, id, **fields):
        for key, value in fields.items():
            Roles.update({key: value}).where(Roles.id == id).execute()

    @classmethod
    def delete(cls, id):
        Roles.delete().where(Roles.id == id).execute()

    # Метод получения разрешений роли
    @classmethod
    def get_permissions(cls, role_id):
        role = Roles.get_or_none(Roles.id == role_id)
        if role and role.permissions:
            return role.permissions.split(',')
        return []

    # Метод проверки разрешения
    @classmethod
    def has_permission(cls, role_id, permission):
        permissions = cls.get_permissions(role_id)
        return permission in permissions or permission == 'all'

if __name__ == '__main__':
    for row in RolesController.get():
        print(row.id, row.name, row.description)