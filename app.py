from flask import Flask, render_template, request, redirect, flash
from flask_login import LoginManager, login_user, logout_user, current_user, login_required
from Controllers.UsersController import UsersController
from Controllers.TicketsController import TicketsController
from Controllers.ComputersController import ComputersController
from Models.Users import Users
from Models.Computers import Computers
import datetime

app = Flask(__name__)
app.secret_key = "TechSupportSecretKey"

login_manager = LoginManager(app)
login_manager.login_view = 'login'


@login_manager.user_loader
def load_user(user_id):
    return UsersController.show(user_id)


# Главная страница - вход
@app.route('/', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        # Перенаправляем в зависимости от роли
        if current_user.role_id.name == 'admin':
            return redirect('/admin')
        elif current_user.role_id.name == 'sysadmin':
            return redirect('/sysadmin')
        else:
            return redirect('/user')

    message = ''
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        if UsersController.auth(username, password):
            user = UsersController.show_by_username(username)
            login_user(user)
            UsersController.update(user.id, last_login=datetime.datetime.now())
            flash('Вход выполнен успешно', 'success')

            # Редирект в зависимости от роли
            if user.role_id.name == 'admin':
                return redirect('/admin')
            elif user.role_id.name == 'sysadmin':
                return redirect('/sysadmin')
            else:
                return redirect('/user')
        else:
            message = 'Неверный логин или пароль'

    return render_template('login.html', message=message)


@app.route('/logout')
def logout():
    logout_user()
    flash('Вы вышли из системы', 'info')
    return redirect('/')


# Панель ПОЛЬЗОВАТЕЛЯ (только создание тикетов)
@app.route('/user')
@login_required
def user_panel():
    if current_user.role_id.name != 'user':
        flash('Недостаточно прав', 'danger')
        return redirect('/' + current_user.role_id.name)

    # Показываем только тикеты пользователя
    tickets = TicketsController.show_by_user(current_user.id)
    computers = ComputersController.show_by_user(current_user.id)

    return render_template('user_panel.html', tickets=tickets, computers=computers)


# Панель СИСТЕМНОГО АДМИНА (просмотр и решение тикетов)
@app.route('/sysadmin')
@login_required
def sysadmin_panel():
    if current_user.role_id.name != 'sysadmin':
        flash('Недостаточно прав', 'danger')
        return redirect('/' + current_user.role_id.name)

    # Показываем все тикеты
    tickets = TicketsController.get()
    stats = TicketsController.get_stats()

    return render_template('sysadmin_panel.html', tickets=tickets, stats=stats)


# Панель АДМИНА (все права)
@app.route('/admin')
@login_required
def admin_panel():
    if current_user.role_id.name != 'admin':
        flash('Недостаточно прав', 'danger')
        return redirect('/' + current_user.role_id.name)

    users = UsersController.get()
    computers = ComputersController.get()
    tickets = TicketsController.get()
    stats = TicketsController.get_stats()

    return render_template('admin_panel.html', users=users, computers=computers, tickets=tickets, stats=stats)


# Создание тикета (только для пользователей)
@app.route('/create_ticket', methods=['GET', 'POST'])
@login_required
def create_ticket():
    if current_user.role_id.name != 'user':
        flash('Недостаточно прав', 'danger')
        return redirect('/' + current_user.role_id.name)

    if request.method == 'POST':
        title = request.form.get('title')
        description = request.form.get('description')
        computer_id = request.form.get('computer_id')
        priority = request.form.get('priority', 'medium')

        computer = ComputersController.show(computer_id)
        if computer and computer.user_id.id == current_user.id:
            TicketsController.add(title, description, current_user.id, computer_id, priority)
            flash('Тикет успешно создан', 'success')
            return redirect('/user')
        else:
            flash('Ошибка доступа к компьютеру', 'danger')

    computers = ComputersController.show_by_user(current_user.id)
    return render_template('create_ticket.html', computers=computers)


# Просмотр тикета
@app.route('/ticket/<int:ticket_id>')
@login_required
def ticket_detail(ticket_id):
    ticket = TicketsController.show(ticket_id)

    if not ticket:
        flash('Тикет не найден', 'danger')
        return redirect('/' + current_user.role_id.name)

    # Проверка прав доступа
    if (current_user.role_id.name not in ['admin', 'sysadmin'] and
            ticket.user_id.id != current_user.id):
        flash('Доступ запрещен', 'danger')
        return redirect('/' + current_user.role_id.name)

    return render_template('ticket_detail.html', ticket=ticket)


# Обновление статуса тикета (для сисадминов и админов)
@app.route('/ticket/<int:ticket_id>/update_status', methods=['POST'])
@login_required
def update_ticket_status(ticket_id):
    if current_user.role_id.name not in ['admin', 'sysadmin']:
        flash('Недостаточно прав', 'danger')
        return redirect(f'/ticket/{ticket_id}')

    new_status = request.form.get('status')
    new_priority = request.form.get('priority')

    ticket = TicketsController.show(ticket_id)
    if ticket:
        TicketsController.update(ticket_id, status=new_status, priority=new_priority)
        flash('Тикет обновлен', 'success')
    else:
        flash('Тикет не найден', 'danger')

    return redirect(f'/ticket/{ticket_id}')


# Добавление пользователя (только для админов)
@app.route('/admin/add_user', methods=['POST'])
@login_required
def admin_add_user():
    if current_user.role_id.name != 'admin':
        flash('Недостаточно прав', 'danger')
        return redirect('/admin')

    username = request.form.get('username')
    password = request.form.get('password')
    first_name = request.form.get('first_name')
    last_name = request.form.get('last_name')
    phone = request.form.get('phone')
    email = request.form.get('email')
    role_id = request.form.get('role_id')

    UsersController.add(username, password, first_name, last_name, phone, email, role_id)
    flash('Пользователь добавлен', 'success')
    return redirect('/admin')


# Добавление компьютера (только для админов)
@app.route('/admin/add_computer', methods=['POST'])
@login_required
def admin_add_computer():
    if current_user.role_id.name != 'admin':
        flash('Недостаточно прав', 'danger')
        return redirect('/admin')

    user_id = request.form.get('user_id')
    pc_name = request.form.get('pc_name')
    ip_address = request.form.get('ip_address')
    operating_system = request.form.get('operating_system')

    ComputersController.add(user_id, pc_name, ip_address, operating_system)
    flash('Компьютер добавлен', 'success')
    return redirect('/admin')


if __name__ == "__main__":
    app.run(debug=True, host='127.0.0.1', port=5000)