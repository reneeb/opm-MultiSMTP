# --
# Kernel/System/Email/MultiSMTP/SMTPTLS.pm - email send backend for SMTP/TLS
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# Changes Copyright (C) 2011-2014 Perl-Services.de, http://perl-services.de
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email::MultiSMTP::SMTPTLS;

use strict;
use warnings;

use Net::SSLGlue::SMTP;

use base qw(Kernel::System::Email::MultiSMTP::SMTP);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

sub _Connect {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(MailHost FQDN)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # set up connection connection
    my $SMTP = Net::SMTP->new(
        $Param{MailHost},
        Hello   => $Param{FQDN},
        Port    => $Param{SMTPPort} || 587,
        Timeout => 30,
        Debug   => $Param{SMTPDebug},
    );

    return if !$SMTP;

    $SMTP->starttls(
        SSL_verify_mode => 0,
    );

    return $SMTP;
}

1;
