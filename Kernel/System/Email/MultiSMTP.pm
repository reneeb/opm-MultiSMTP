# --
# Copyright (C) 2013 - 2023 Perl-Services.de, https://perl-services.de
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email::MultiSMTP;

use strict;
use warnings;

use Kernel::System::EmailParser;
our @ObjectDependencies = qw(
    Kernel::System::MultiSMTP
    Kernel::System::Email::SMTP
    Kernel::System::Email::SMTPS
    Kernel::System::Email::SMTPTLS
    Kernel::System::Email::MultiSMTP::SMTP
    Kernel::System::Email::MultiSMTP::SMTPS
    Kernel::System::Email::MultiSMTP::SMTPTLS
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    $Self->{Debug}   = $ConfigObject->Get( 'MultiSMTP::Debug' );

    return $Self;
}

sub Check {
    return (Successful => 1, MultiSMTP => shift );
}

sub Send {
    my ( $Self, %Param ) = @_;

    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MSMTPObject  = $Kernel::OM->Get('Kernel::System::MultiSMTP');

    # check needed stuff
    for my $Needed (qw(Header Body)) {
        if ( !$Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( $Self->{Debug} ) {
        $LogObject->Log(
            Priority => 'debug',
            Message  => 'Header: ' . ${ $Param{Header} },
        );
    }

    my $UseSenderFromMail = $ConfigObject->Get('MultiSMTP::UseSenderFromMail');

    # try to parse the sender address from header
    if ( !$Param{From} || $UseSenderFromMail ) {
        ($Param{From}) = ${ $Param{Header} } =~ m{
            ^ From: \s+
                (
                    (?:[^\n]+ )
                    (?: \n ^ \s+ [^\n]+ )*
                )
        }xms;
    }

    if ( $Self->{Debug} ) {
        $LogObject->Log(
            Priority => 'debug',
            Message  => 'From: ' . $Param{From},
        );
    }

    my $ErrorMessage = 'Error preparing to send message';
    if ( $Param{From} ) {
        my $ParserObject = Kernel::System::EmailParser->new(
            Mode  => 'Standalone',
            Debug => 0,
        );

        my $PlainFrom = $ParserObject->GetEmailAddress(
            Email => $Param{From},
        );

        my %SMTP = $MSMTPObject->SMTPGetForAddress(
            Address => $PlainFrom,
            Valid   => 1,
        );

        if ( $Self->{Debug} ) {
            $LogObject->Log(
                Priority => 'debug',
                Message  => 'From: ' . ( $PlainFrom // '' ) . ' // SMTP: ' . ( $SMTP{ID} // '' ),
            );
        }

        if ( %SMTP ) {
            $SMTP{Password} = $SMTP{PasswordDecrypted};
            $SMTP{Type} =~ s/\W//g;

            if ( $Self->{Debug} && $Self->{Debug} == 2 ) {
                $LogObject->Log(
                    Priority => 'debug',
                    Message  => 'SMTP debugging enabled',
                );

                $SMTP{Debug} = 3;
            }

            my $Module = 'Kernel::System::Email::MultiSMTP::' . $SMTP{Type};
            $Kernel::OM->ObjectParamAdd(
                $Module => \%SMTP,
            );

            my $SMTPObject  = $Kernel::OM->Create($Module);

            if ($SMTPObject->{User} ne $SMTP{User}) {
                if ( $Self->{Debug} ) {
                    $LogObject->Log(
                        Priority => 'debug',
                        Message  => "Set new SMTP-Server Information",
                    );
                }

                $SMTPObject->{MailHost} = $SMTP{Host};
                $SMTPObject->{SMTPPort} = $SMTP{Port};
                $SMTPObject->{User}     = $SMTP{User};
                $SMTPObject->{Password} = $SMTP{Password};
            }

            if ( $Self->{Debug} ) {
                $LogObject->Log(
                    Priority => 'debug',
                    Message  => "Use MultiSMTP $Module",
                );

                $LogObject->Log(
                    Priority => 'debug',
                    Message  => sprintf "Use SMTP %s/%s (%s)", $SMTP{Host}, $SMTP{User}, $SMTP{ID},
                );
            }

            return if !$SMTPObject;

            my $Success = $SMTPObject->Send( %Param );

            return $Success;
        }
        else{
            $ErrorMessage .= ": not found smtp for adress $PlainFrom";
        }
    }
    else{
        $ErrorMessage .= ': param From empty';
    }

    my $UseFallback = $ConfigObject->Get('MultiSMTP::UseFallback') || 1;

    if($UseFallback){
        # use standard SMTP module as fallback
        my $Module  = $ConfigObject->Get('MultiSMTP::Fallback');
        return $Kernel::OM->Get( $Module )->Send( %Param );
    }
    else
    {
        return (
            Successful => 0,
            Message    => $ErrorMessage
        );
    }

}

1;
