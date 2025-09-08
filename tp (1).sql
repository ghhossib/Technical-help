-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Сен 08 2025 г., 20:09
-- Версия сервера: 10.4.32-MariaDB
-- Версия PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `tp`
--

-- --------------------------------------------------------

--
-- Структура таблицы `computers`
--

CREATE TABLE `computers` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pc_name` varchar(100) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `mac_address` varchar(17) DEFAULT NULL,
  `operating_system` varchar(100) NOT NULL,
  `specifications` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `last_seen` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `computers`
--

INSERT INTO `computers` (`id`, `user_id`, `pc_name`, `ip_address`, `mac_address`, `operating_system`, `specifications`, `is_active`, `created_at`, `last_seen`) VALUES
(2, 1, 'asd-asd', '123.123.123', 'asd', 'sad', 'asd', 1, '2025-09-08 21:04:40', NULL),
(3, 2, '123', '123', '123', '123', '123', 1, '2025-09-08 21:05:41', NULL),
(4, 5, 'NIGGA-PC', '12.33.23.23', NULL, 'sdd', NULL, 1, '2025-09-08 22:28:48', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `permissions` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `permissions`, `created_at`) VALUES
(1, 'admin', 'Администратор системы', 'all', '2025-09-07 16:28:27'),
(2, 'sysadmin', 'Системный администратор', 'manage_tickets,view_all_tickets,assign_tickets', '2025-09-07 16:28:28'),
(3, 'user', 'Обычный пользователь', 'create_tickets,view_own_tickets', '2025-09-07 16:28:28');

-- --------------------------------------------------------

--
-- Структура таблицы `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `status` enum('open','in_progress','resolved','cancelled') DEFAULT 'open',
  `priority` enum('low','medium','high','critical') DEFAULT 'medium',
  `user_id` int(11) NOT NULL,
  `computer_id` int(11) NOT NULL,
  `assigned_to` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `resolved_at` datetime DEFAULT NULL,
  `closed_at` datetime DEFAULT NULL,
  `assigned_to_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `tickets`
--

INSERT INTO `tickets` (`id`, `title`, `description`, `status`, `priority`, `user_id`, `computer_id`, `assigned_to`, `created_at`, `updated_at`, `resolved_at`, `closed_at`, `assigned_to_id`) VALUES
(1, 'фыв', 'фыв', 'cancelled', 'medium', 2, 3, NULL, '2025-09-08 21:05:52', '2025-09-08 23:05:49', NULL, NULL, NULL),
(2, 'asd', 'asdasd', 'resolved', 'low', 2, 3, NULL, '2025-09-08 21:26:15', '2025-09-08 22:26:44', NULL, NULL, NULL),
(3, 'asd', 'asdasdasd', 'open', 'medium', 2, 3, NULL, '2025-09-08 21:39:36', '2025-09-08 21:39:36', NULL, NULL, NULL),
(4, 'ПРОБЛЕМА', 'АУАУАУ', 'in_progress', 'critical', 2, 3, NULL, '2025-09-08 21:42:26', '2025-09-08 22:43:33', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ticket_messages`
--

CREATE TABLE `ticket_messages` (
  `id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `is_internal` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `ticket_status_history`
--

CREATE TABLE `ticket_status_history` (
  `id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `old_status` varchar(20) DEFAULT NULL,
  `new_status` varchar(20) NOT NULL,
  `changed_by` int(11) NOT NULL,
  `changed_at` datetime DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role_id` int(11) NOT NULL DEFAULT 3,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `last_login` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `first_name`, `last_name`, `phone`, `email`, `role_id`, `is_active`, `created_at`, `last_login`) VALUES
(1, 'admin', '$2b$12$MnlDujdn/j3S1UcQwqZ1MuxE2Gz8OVmfup9j7bTOclFQsGZnoe85u', 'Администратор', 'Системы', '+7-999-000-00-00', 'admin@company.com', 1, 1, '2025-09-07 16:28:28', '2025-09-08 23:09:32'),
(2, 'adm2in', '$2b$12$X2Qjy0VxzVldtayRYLp6DeJ.aqaBmg7jcn4yzzD0FXRp7Wjg6Hc5O', 'asd', 'asd', '123123', 'asdas@dasd', 3, 1, '2025-09-08 20:55:04', '2025-09-08 23:06:34'),
(4, 'adm3in', '$2b$12$8CAaQ.reqffjjAM1Zydkwu3gbAE77/acN.Y9c0IP6k1kuYDMXdITm', 'a2sd', 'as2d', '1232123', 'asd2as@dasd', 2, 1, '2025-09-08 21:55:50', '2025-09-08 23:08:08'),
(5, 'sd', '$2b$12$ltIwqKDD6j6HnoOPxbeuue5GHZLbb9/whZZbFzFAPkWghMiTplPeK', 'dd', 'dd', 'dd', 'dd@mail.rui', 3, 1, '2025-09-08 22:28:29', '2025-09-08 22:29:02');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `computers`
--
ALTER TABLE `computers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_ip` (`ip_address`),
  ADD KEY `idx_pc_name` (`pc_name`);

--
-- Индексы таблицы `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `idx_name` (`name`);

--
-- Индексы таблицы `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_priority` (`priority`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_computer_id` (`computer_id`),
  ADD KEY `idx_assigned_to` (`assigned_to`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Индексы таблицы `ticket_messages`
--
ALTER TABLE `ticket_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ticket_id` (`ticket_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Индексы таблицы `ticket_status_history`
--
ALTER TABLE `ticket_status_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ticket_id` (`ticket_id`),
  ADD KEY `idx_changed_at` (`changed_at`),
  ADD KEY `changed_by` (`changed_by`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_role_id` (`role_id`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `computers`
--
ALTER TABLE `computers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `ticket_messages`
--
ALTER TABLE `ticket_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `ticket_status_history`
--
ALTER TABLE `ticket_status_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `computers`
--
ALTER TABLE `computers`
  ADD CONSTRAINT `computers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tickets_ibfk_2` FOREIGN KEY (`computer_id`) REFERENCES `computers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tickets_ibfk_3` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `ticket_messages`
--
ALTER TABLE `ticket_messages`
  ADD CONSTRAINT `ticket_messages_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ticket_messages_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `ticket_status_history`
--
ALTER TABLE `ticket_status_history`
  ADD CONSTRAINT `ticket_status_history_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ticket_status_history_ibfk_2` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
