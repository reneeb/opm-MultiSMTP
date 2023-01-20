# --
# Kernel/Language/ru_MultiSMTP.pm - the Russian translation of MultiSMTP
# Copyright (C) 2011 - 2023 Perl-Services.de; https://www.perl-services.de/
# Copyright (C) 2017 WestDevTeam; http://westdev.by/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details; see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file; see http://www.gnu.org/licenses/agpl.txt.
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
