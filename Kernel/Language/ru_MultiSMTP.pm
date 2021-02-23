# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2011 - 2021 Perl-Services.de; http://perl-services.de/
# Copyright (C) 2017 WestDevTeam; http://westdev.by/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

package Kernel::Language::ru_MultiSMTP;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation} || {};

    # Kernel/Config/Files/MultiSMTP.xml
    $Lang->{'Frontend module registration for the MultiSMTP interface.'} = 'Регистрация модуля MultiSMTP.';
    $Lang->{'Manage SMTP settings.'} = 'Менеджер SMTP настроек.';
    $Lang->{'SMTP settings'} = 'SMTP настройки';
    $Lang->{'The salt for password encryption. It has to have exactly 8 bytes!'} = 'Соль для шифрования паролей. Он должен иметь ровно 8 байтов!';
    $Lang->{'The key for password encryption.'} = 'Ключ для шифрования паролей.';
    $Lang->{'The fallback mechanism when MultiSMTP fails.'} = 'Механизм возврата при сбое MultiSMTP.';
    $Lang->{'Enable debugging mode of MultiSMTP.'} = 'Включить режим отладки MultiSMTP.';
    $Lang->{'Debug MultiSMTP'} = 'Отладка MultiSMTP';
    $Lang->{'Debug MultiSMTP and Net::SMTP'} = 'Отладка MultiSMTP и Net::SMTP';

    # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPForm.tt
    $Lang->{'SMTP Management'} = 'Управление SMTP';
    $Lang->{'Add/Change SMTP'} = 'Добавить/изменить SMTP';
    $Lang->{'Anonymous SMTP'} = 'Анонимный SMTP';
    $Lang->{'Emails'} = 'Электронные почтовые адреса';

    # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPList.tt
    $Lang->{'Add SMTP'} = 'Добавить SMTP';
    $Lang->{'ID'} = 'ID';
    $Lang->{'Creator'} = 'Создатель';
    $Lang->{'No matches found.'} = 'Совпадений не найдено.';
    $Lang->{'edit'} = 'редактировать';
    $Lang->{'delete'} = 'удалить';
}

1;
