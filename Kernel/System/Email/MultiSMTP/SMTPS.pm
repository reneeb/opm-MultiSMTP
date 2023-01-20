# --
# Copyright (C) 2021-2022 Znuny GmbH, https://znuny.org/
# Changes Copyright (C) 2011 - 2023 Perl-Services.de, https://www.perl-services.de
# Changes Copyright (C) 2017 WestDevTeam, http://westdev.by
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email::MultiSMTP::SMTPS;

use strict;
use warnings;

# ---
# PS
# ---
#use parent qw(Kernel::System::Email::SMTP);
use parent 'Kernel::System::Email::MultiSMTP::SMTP';
# ---

our @ObjectDependencies;

sub _GetSMTPDefaultPort {
    my ( $Self, %Param ) = @_;

    return 465;
}

sub _GetSSLOptions {
    my ( $Self, %Param ) = @_;

    my %SSLOptions = (
        SSL             => 1,
        SSL_verify_mode => 0,
    );

    return %SSLOptions;
}

1;
