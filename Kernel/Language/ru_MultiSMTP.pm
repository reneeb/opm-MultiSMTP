# --
# Kernel/Language/ru_MultiSMTP.pm - the Russian translation of MultiSMTP
# Copyright (C) 2011-2017 Perl-Services.de, http://perl-services.de/
# Copyright (C) 2017 WestDevTeam, http://westdev.by/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_MultiSMTP;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation} = {

        # Kernel/Config/Files/MultiSMTP.xml
        'Frontend module registration for the MultiSMTP interface.' => 'Регистрация модуля MultiSMTP.',
        'Manage SMTP settings.' => 'Менеджер SMTP настроек.',
        'SMTP settings' => 'SMTP настройки',
        'The salt for password encryption. It has to have exactly 8 bytes!' => 'Соль для шифрования паролей. Он должен иметь ровно 8 байтов!',
        'The key for password encryption.' => 'Ключ для шифрования паролей.',
        'The fallback mechanism when MultiSMTP fails.' => 'Механизм возврата при сбое MultiSMTP.',
        'Enable debugging mode of MultiSMTP.' => 'Включить режим отладки MultiSMTP.',
        'Debug MultiSMTP' => 'Отладка MultiSMTP',
        'Debug MultiSMTP and Net::SMTP' => 'Отладка MultiSMTP и Net::SMTP',

        # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPForm.tt
        'SMTP Management' => 'Управление SMTP',
        'Add/Change SMTP' => 'Добавить/изменить SMTP',
        'Anonymous SMTP' => 'Анонимный SMTP',
        'A host is required.' => 'Хост обязателен для заполнения.',
        'Port is mandatory.' => 'Порт обязателен для заполнения.',
        'User is mandatory.' => 'Пользователь обязателен для заполнения',
        'Password is mandatory.' => 'Пароль обязателен для заполнения',
        'Emails' => 'Электронные почтовые адреса',
        'Email is mandatory.' => 'Электронные почтовые адреса обязателны для заполнения.',
        'Type is mandatory.' => 'Тип обязателен для заполнения.',

        # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPList.tt
        'Add SMTP' => 'Добавить SMTP',
        'ID' => 'ID',
        'Creator' => 'Создатель',
        'No matches found.' => 'Совпадений не найдено.',
        'edit' => 'редактировать',
        'delete' => 'удалить',   
    };
}

1,
