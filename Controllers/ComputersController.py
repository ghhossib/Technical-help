from Models.Computers import Computers

class ComputersController:
    @classmethod
    def get(cls):
        return Computers.select()

    @classmethod
    def show(cls, id):
        return Computers.get_or_none(Computers.id == id)

    @classmethod
    def show_by_user(cls, user_id):
        return Computers.select().where(Computers.user_id == user_id, Computers.is_active == True)

    @classmethod
    def show_by_ip(cls, ip_address):
        return Computers.get_or_none(Computers.ip_address == ip_address)

    @classmethod
    def add(cls, user_id, pc_name, ip_address, operating_system, mac_address=None, specifications=None):
        Computers.create(
            user_id=user_id,
            pc_name=pc_name,
            ip_address=ip_address,
            mac_address=mac_address,
            operating_system=operating_system,
            specifications=specifications
        )

if __name__ == "__main__":
    ComputersController.add('1','asd-asd','123.123.123','sad','asd','asd')