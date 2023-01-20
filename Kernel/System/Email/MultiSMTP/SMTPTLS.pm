# --
# Copyright (C) 2021-2022 Znuny GmbH, https://znuny.org/
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Changes Copyright (C) 2011 - 2023 Perl-Services.de, https://www.perl-services.de
# Changes Copyright (C) 2017 WestDevTeam, http://westdev.by
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Email::MultiSMTP::SMTPTLS;

use strict;
use warnings;

# ---
# PS
# ---
# use parent qw(Kernel::System::Email::SMTP);
use parent 'Kernel::System::Email::MultiSMTP::SMTP';
# ---

our @ObjectDependencies;

# Use Net::SSLGlue::SMTP on systems with older Net::SMTP modules that cannot handle SMTPTLS.
BEGIN {
    if ( !defined &Net::SMTP::starttls ) {
        ## nofilter(TidyAll::Plugin::OTRS::Perl::Require)
        ## nofilter(TidyAll::Plugin::OTRS::Perl::SyntaxCheck)
        require Net::SSLGlue::SMTP;
    }
}

sub _GetSMTPDefaultPort {
    my ( $Self, %Param ) = @_;

    return 587;
}

sub _GetStartTLSOptions {
    my ( $Self, %Param ) = @_;

    my %StartTLSOptions = (
        SSL_verify_mode => 0,
    );

    return %StartTLSOptions;
}

1;
