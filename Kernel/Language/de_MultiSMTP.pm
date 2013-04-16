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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{Creator} = 'Ersteller';

    $Lang->{'Add SMTP'}             = 'SMTP hinzufügen';
    $Lang->{'SMTP settings'}        = 'SMTP-Einstellungen';
    $Lang->{'Manage SMTP settings'} = 'SMTP-Einstellungen verwalten';
    $Lang->{'Add/Change SMTP'}      = 'SMTP hinzufügen/bearbeiten';
    $Lang->{'Type is mandatory'}    = 'Typ wird benötigt';
    $Lang->{'A host is required'}   = 'Ein Hostname wird benötigt';
    $Lang->{'User is mandatory'}    = 'Ein Benutzername wird benötigt';
    $Lang->{'Port is mandatory'}    = 'Eine Port-Angabe wird benötigt';
    $Lang->{'Email is mandatory'}   = 'E-Mail-Adressen werden benötigt';
    

    return 1;
}

1;
