# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::Language::hu_MultiSMTP;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation} || {};

    # Kernel/Config/Files/MultiSMTP.xml
    $Lang->{'Frontend module registration for the MultiSMTP interface.'} =
        'Előtétprogram-modul regisztráció a MultiSMTP felülethez.';
    $Lang->{'Manage SMTP settings.'} = 'SMTP-beállítások kezelése.';
    $Lang->{'SMTP settings'} = 'SMTP-beállítások';
    $Lang->{'The salt for password encryption. It has to have exactly 8 bytes!'} =
        'A só a jelszó titkosításához. Pontosan 8 bájtból kell állnia!';
    $Lang->{'The key for password encryption.'} = 'A kulcs a jelszó titkosításához.';
    $Lang->{'The fallback mechanism when MultiSMTP fails.'} = 'A tartalék mechanizmus, ha a MultiSMTP sikertelen.';
    $Lang->{'Enable debugging mode of MultiSMTP.'} = 'A MultiSMTP hibakeresési módjának engedélyezése.';
    $Lang->{'Debug MultiSMTP'} = 'MultiSMTP hibakeresése';
    $Lang->{'Debug MultiSMTP and Net::SMTP'} = 'MultiSMTP és Net::SMTP hibakeresése';

    # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPForm.tt
    $Lang->{'SMTP Management'} = 'SMTP kezelés';
    $Lang->{'Add/Change SMTP'} = 'SMTP hozzáadása vagy megváltoztatása';
    $Lang->{'Anonymous SMTP'} = 'Névtelen SMTP';
    $Lang->{'Emails'} = 'E-mailek';

    # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPList.tt
    $Lang->{'Add SMTP'} = 'SMTP hozzáadása';
    $Lang->{'ID'} = 'Azonosító';
    $Lang->{'Creator'} = 'Létrehozó';
    $Lang->{'No matches found.'} = 'Nincs találat.';
    $Lang->{'edit'} = 'szerkesztés';
    $Lang->{'delete'} = 'törlés';
}

1;
