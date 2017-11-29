# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# Changes Copyright (C) 2011-2016 Perl-Services.de, http://perl-services.de
# Changes Copyright (C) 2017 WestDevTeam, http://westdev.by
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email::MultiSMTP::SMTP;

use strict;
use warnings;

use Net::SMTP;

use parent 'Kernel::System::Email::SMTP';

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::CommunicationLog',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # debug
    $Self->{Debug} = $Param{Debug} || 0;
    if ( $Self->{Debug} > 2 ) {

        # shown on STDERR
        $Self->{SMTPDebug} = 1;
    }

    # ---
    # PS
    # ---
    # get config data
    $Self->{FQDN}     = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    $Self->{MailHost} = $Param{Host};
    $Self->{SMTPPort} = $Param{Port};
    $Self->{User}     = $Param{User};
    $Self->{Password} = $Param{Password};
    # ---

    return $Self;
}

sub Check {
    my ( $Self, %Param ) = @_;

    $Param{CommunicationLogObject}->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    my $Return = sub {
        my %LocalParam = @_;
        $Param{CommunicationLogObject}->ObjectLogStop(
            ObjectLogType => 'Connection',
            Status        => $LocalParam{Success} ? 'Successful' : 'Failed',
        );

        return %LocalParam;
    };

    my $ReturnSuccess = sub { return $Return->( @_, Success => 1, ); };
    my $ReturnError   = sub { return $Return->( @_, Success => 0, ); };

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # ---
    # PS
    # ---
    #    # get config data
    #    $Self->{FQDN}     = $ConfigObject->Get('FQDN');
    #    $Self->{MailHost} = $ConfigObject->Get('SendmailModule::Host')
    #        || die "No SendmailModule::Host found in Kernel/Config.pm";
    #    $Self->{SMTPPort} = $ConfigObject->Get('SendmailModule::Port');
    #    $Self->{User}     = $ConfigObject->Get('SendmailModule::AuthUser');
    #    $Self->{Password} = $ConfigObject->Get('SendmailModule::AuthPassword');
    # ---

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Debug',
        Key           => 'Kernel::System::Email::MultiSMTP::'.$Self->{Type},
        Value         => 'Testing connection to SMTP service (3 attempts max.).',
    );

    # 3 possible attempts to connect to the SMTP server.
    # (MS Exchange Servers have sometimes problems on port 25)
    my $SMTP;

    my $TryConnectMessage = sprintf
        "%%s: Trying to connect to '%s%s' on %s with SMTP type '%s'.",
        $Self->{MailHost},
        ( $Self->{SMTPPort} ? ':' . $Self->{SMTPPort} : '' ),
        $Self->{FQDN},
        $Self->{Type},
    ;

    TRY:
    for my $Try ( 1 .. 3 ) {

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Debug',
            Key           => 'Kernel::System::Email::MultiSMTP::'.$Self->{Type},
            Value         => sprintf( $TryConnectMessage, $Try, ),
        );

        # connect to mail server
        eval {
            $SMTP = $Self->_Connect(
                MailHost  => $Self->{MailHost},
                FQDN      => $Self->{FQDN},
                SMTPPort  => $Self->{SMTPPort},
                SMTPDebug => $Self->{SMTPDebug},
            );
            return 1;
        } || do {
            my $Error = $@;
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => sprintf(
                    "SMTP, connection try %s, unexpected error captured: %s",
                    $Try,
                    $Error,
                ),
            );
        };

        last TRY if $SMTP;

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Debug',
            Key           => 'Kernel::System::Email::MultiSMTP::'.$Self->{Type},
            Value         => "$Try: Connection could not be established. Waiting for 0.3 seconds.",
        );

        # sleep 0,3 seconds;
        select( undef, undef, undef, 0.3 );    ## no critic
    }

    # return if no connect was possible
    if ( !$SMTP ) {

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Error',
            Key           => 'Kernel::System::Email::MultiSMTP::'.$Self->{Type},
            Value         => "Could not connect to host '$Self->{MailHost}'. ErrorMessage: $!",
        );

        return $ReturnError->(
            ErrorMessage => "Can't connect to $Self->{MailHost}: $!!",
        );
    }

    # Enclose SMTP in a wrapper to handle unexpected exceptions
    $SMTP = $Self->_GetSMTPSafeWrapper(
        SMTP => $SMTP,
    );

    # use smtp auth if configured
    if ( $Self->{User} && $Self->{Password} ) {

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Debug',
            Key           => 'Kernel::System::Email::MultiSMTP::'.$Self->{Type},
            Value         => "Using SMTP authentication with user '$Self->{User}' and (hidden) password.",
        );

        if ( !$SMTP->( 'auth', $Self->{User}, $Self->{Password} ) ) {

            my $Code  = $SMTP->( 'code', );
            my $Error = $Code . ', ' . $SMTP->( 'message', );

            $SMTP->( 'quit', );

            $Param{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Error',
                Key           => 'Kernel::System::Email::MultiSMTP::'.$Self->{Type},
                Value         => "SMTP authentication failed (SMTP code: $Code, ErrorMessage: $Error).",
            );

            return $ReturnError->(
                ErrorMessage => "SMTP authentication failed: $Error!",
                Code         => $Code,
            );
        }
    }

    return $ReturnSuccess->(
        SMTP => $SMTP,
    );
}

1;
