# --
# Kernel/Language/de_MultiSMTP.pm - the german translation of MultiSMTP
# Copyright (C) 2011 Perl-Services.de, http://perl-services.de/
# Extensions Copyright (C) 2006-2012 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Frank(dot)Oberender(at)cape(dash)it(dot)de
#
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

# MultiSMTP-capeIT for OTRS-Framwork 2.4.x
    $Lang->{'Add a new SMTP-Account.'} = 'Füge neues SMTP-Konto hinzu.';
    $Lang->{'SMTP Management'} = 'SMTP Verwaltung';
# EO MultiSMTP-capeIT for OTRS-Framwork 2.4.x

    return 1;
}

1;
