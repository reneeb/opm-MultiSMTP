# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Kernel/Language/de_MultiSMTP.pm - the German translation of MultiSMTP
# Copyright (C) 2011 - 2021 Perl-Services.de, http://perl-services.de/
# Changes Copyright (C) 2017 WestDevTeam, http://westdev.by
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

package Kernel::Language::de_MultiSMTP;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation} || {};

    # Kernel/Config/Files/MultiSMTP.xml
    $Lang->{'Frontend module registration for the MultiSMTP interface.'} = '';
    $Lang->{'Manage SMTP settings.'} = 'SMTP-Einstellungen verwalten';
    $Lang->{'SMTP settings'} = 'SMTP-Einstellungen';
    $Lang->{'The salt for password encryption. It has to have exactly 8 bytes!'} = '';
    $Lang->{'The key for password encryption.'} = '';
    $Lang->{'The fallback mechanism when MultiSMTP fails.'} = '';
    $Lang->{'Enable debugging mode of MultiSMTP.'} = '';
    $Lang->{'Debug MultiSMTP'} = 'Debugge MultiSMTP';
    $Lang->{'Debug MultiSMTP and Net::SMTP'} = 'Debugge MultiSMTP und Net::SMTP';

    # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPForm.tt
    $Lang->{'SMTP Management'} = '';
    $Lang->{'Add/Change SMTP'} = 'SMTP hinzufügen/bearbeiten';
    $Lang->{'Anonymous SMTP'} = '';
    $Lang->{'Emails'} = 'E-Mails';

    # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPList.tt
    $Lang->{'Add SMTP'} = 'SMTP hinzufügen';
    $Lang->{'ID'} = '';
    $Lang->{'Creator'} = 'Ersteller';
    $Lang->{'No matches found.'} = '';
    $Lang->{'edit'} = '';
    $Lang->{'delete'} = '';
}

1;
