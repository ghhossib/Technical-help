from Models.Tickets import Tickets

class TicketsController:
    @classmethod
    def get(cls):
        return Tickets.select()

    @classmethod
    def show(cls, id):
        return Tickets.get_or_none(Tickets.id == id)

    @classmethod
    def show_by_user(cls, user_id):
        return Tickets.select().where(Tickets.user_id == user_id).order_by(Tickets.created_at.desc())

    @classmethod
    def add(cls, title, description, user_id, computer_id, priority='medium'):
        Tickets.create(
            title=title,
            description=description,
            user_id=user_id,
            computer_id=computer_id,
            priority=priority
        )

    @classmethod
    def update(cls, id, **fields):
        for key, value in fields.items():
            Tickets.update({key: value}).where(Tickets.id == id).execute()

    @classmethod
    def get_stats(cls):
        return {
            'total': Tickets.select().count(),
            'open': Tickets.select().where(Tickets.status == 'open').count(),
            'in_progress': Tickets.select().where(Tickets.status == 'in_progress').count(),
            'resolved': Tickets.select().where(Tickets.status == 'resolved').count(),
            'cancelled': Tickets.select().where(Tickets.status == 'cancelled').count()
        }