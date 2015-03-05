# --
# Kernel/Language/de_MultiSMTP.pm - the german translation of MultiSMTP
# Copyright (C) 2011-2012 Perl-Services.de, http://perl-services.de/
# --
# $Id: de_MultiSMTP.pm,v 1.3 2011/07/13 10:45:32 rb Exp $
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

    $Self->{Translation}->{'Add SMTP'}             = 'SMTP hinzufügen';
    $Self->{Translation}->{'SMTP settings'}        = 'SMTP-Einstellungen';
    $Self->{Translation}->{'Manage SMTP settings'} = 'SMTP-Einstellungen verwalten';
    $Self->{Translation}->{'Add/Change SMTP'}      = 'SMTP hinzufügen/bearbeiten';
    $Self->{Translation}->{'Type is mandatory'}    = 'Typ wird benötigt';
    $Self->{Translation}->{'A host is required'}   = 'Ein Hostname wird benötigt';
    $Self->{Translation}->{'User is mandatory'}    = 'Ein Benutzername wird benötigt';
    $Self->{Translation}->{'Port is mandatory'}    = 'Eine Port-Angabe wird benötigt';
    $Self->{Translation}->{'Email is mandatory'}   = 'E-Mail-Adressen werden benötigt';
    
}

1;
