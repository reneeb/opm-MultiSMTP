# --
# Kernel/Language/de_MultiSMTP.pm - the German translation of MultiSMTP
# Copyright (C) 2011 - 2016 Perl-Services.de, http://perl-services.de/
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
    $Lang->{'None'} = '';
    $Lang->{'Debug MultiSMTP'} = 'Debugge MultiSMTP';
    $Lang->{'Debug MultiSMTP and Net::SMTP'} = 'Debugge MultiSMTP und Net::SMTP';

    # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPForm.tt
    $Lang->{'SMTP Management'} = '';
    $Lang->{'Actions'} = '';
    $Lang->{'Go to overview'} = '';
    $Lang->{'Add/Change SMTP'} = 'SMTP hinzufügen/bearbeiten';
    $Lang->{'Anonymous SMTP'} = '';
    $Lang->{'Host'} = 'Hostname';
    $Lang->{'A host is required.'} = 'Ein Hostname wird benötigt.';
    $Lang->{'Port'} = 'Port';
    $Lang->{'Port is mandatory.'} = 'Eine Port-Angabe wird benötigt.';
    $Lang->{'User'} = 'Benutzer';
    $Lang->{'User is mandatory.'} = 'Ein Benutzername wird benötigt.';
    $Lang->{'Password'} = '';
    $Lang->{'Password is mandatory.'} = '';
    $Lang->{'Emails'} = 'E-Mails';
    $Lang->{'Email is mandatory.'} = 'E-Mail-Adressen werden benötigt.';
    $Lang->{'Type'} = 'Typ';
    $Lang->{'Type is mandatory.'} = 'Typ wird benötigt.';
    $Lang->{'Validity'} = '';
    $Lang->{'Comment'} = '';
    $Lang->{'Save'} = '';
    $Lang->{'or'} = '';
    $Lang->{'Cancel'} = '';

    # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPList.tt
    $Lang->{'Add SMTP'} = 'SMTP hinzufügen';
    $Lang->{'List'} = '';
    $Lang->{'ID'} = '';
    $Lang->{'Date'} = '';
    $Lang->{'Creator'} = 'Ersteller';
    $Lang->{'Action'} = '';
    $Lang->{'No matches found.'} = '';
    $Lang->{'edit'} = '';
    $Lang->{'delete'} = '';
}

1;
