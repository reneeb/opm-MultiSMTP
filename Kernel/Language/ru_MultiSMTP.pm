# --
# Kernel/Language/ru_MultiSMTP.pm - the Russian translation of MultiSMTP
# Copyright (C) 2011-2017 Perl-Services.de; http://perl-services.de/
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

    # Kernel/Config/Files/MultiSMTP.xml
    $Self->{Translation}->{'Frontend module registration for the MultiSMTP interface.'} = 'Регистрация модуля MultiSMTP.';
    $Self->{Translation}->{'Manage SMTP settings.'} = 'Менеджер SMTP настроек.';
    $Self->{Translation}->{'SMTP settings'} = 'SMTP настройки';
    $Self->{Translation}->{'The salt for password encryption. It has to have exactly 8 bytes!'} = 'Соль для шифрования паролей. Он должен иметь ровно 8 байтов!';
    $Self->{Translation}->{'The key for password encryption.'} = 'Ключ для шифрования паролей.';
    $Self->{Translation}->{'The fallback mechanism when MultiSMTP fails.'} = 'Механизм возврата при сбое MultiSMTP.';
    $Self->{Translation}->{'Enable debugging mode of MultiSMTP.'} = 'Включить режим отладки MultiSMTP.';
    $Self->{Translation}->{'Debug MultiSMTP'} = 'Отладка MultiSMTP';
    $Self->{Translation}->{'Debug MultiSMTP and Net::SMTP'} = 'Отладка MultiSMTP и Net::SMTP';

    # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPForm.tt
    $Self->{Translation}->{'SMTP Management'} = 'Управление SMTP';
    $Self->{Translation}->{'Add/Change SMTP'} = 'Добавить/изменить SMTP';
    $Self->{Translation}->{'Anonymous SMTP'} = 'Анонимный SMTP';
    $Self->{Translation}->{'Emails'} = 'Электронные почтовые адреса';

    # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPList.tt
    $Self->{Translation}->{'Add SMTP'} = 'Добавить SMTP';
    $Self->{Translation}->{'ID'} = 'ID';
    $Self->{Translation}->{'Creator'} = 'Создатель';
    $Self->{Translation}->{'No matches found.'} = 'Совпадений не найдено.';
    $Self->{Translation}->{'edit'} = 'редактировать';
    $Self->{Translation}->{'delete'} = 'удалить';
}

1;
