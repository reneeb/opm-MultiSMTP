# --
# Kernel/Language/de_MultiSMTP.pm - the German translation of MultiSMTP
# Copyright (C) 2011 - 2023 Perl-Services.de, https://www.perl-services.de/
# Changes Copyright (C) 2017 WestDevTeam, http://westdev.by
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
    $Lang->{'SMTP Management'} = 'SMTP Verwaltung';
    $Lang->{'Add/Change SMTP'} = 'SMTP hinzufügen/bearbeiten';
    $Lang->{'Emails'} = 'E-Mails';
    $Lang->{'Authentication Type'} = 'Art d. Authentifizierung';

    # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPList.tt
    $Lang->{'Add SMTP'} = 'SMTP hinzufügen';
    $Lang->{'Creator'} = 'Ersteller';
}

1;
