from Models.Users import Users
from bcrypt import hashpw, gensalt, checkpw

class UsersController:
    @classmethod
    def get(cls):
        return Users.select()

    @classmethod
    def show(cls, id):
        return Users.get_or_none(Users.id == id)

    @classmethod
    def show_by_username(cls, username):
        return Users.get_or_none(Users.username == username)

    @classmethod
    def add(cls, username, password, first_name, last_name, phone, email, role_id):
        hash_password = hashpw(password.encode('utf-8'), gensalt())
        Users.create(
            username=username,
            password=hash_password.decode('utf-8'),
            first_name=first_name,
            last_name=last_name,
            phone=phone,
            email=email,
            role_id=role_id
        )

    @classmethod
    def update(cls, id, **fields):
        for key, value in fields.items():
            if key == 'password':
                value = hashpw(value.encode('utf-8'), gensalt()).decode('utf-8')
            Users.update({key: value}).where(Users.id == id).execute()

    @classmethod
    def delete(cls, id):
        Users.delete().where(Users.id == id).execute()

    @classmethod
    def auth(cls, username, password):
        user = Users.get_or_none(Users.username == username)
        if user and user.is_active:
            return checkpw(password.encode('utf-8'), user.password.encode('utf-8'))
        return False
if __name__ == "__main__":
    UsersController.add('adm3in','adm3in','a2sd','as2d','1232123','asd2as@dasd','2')