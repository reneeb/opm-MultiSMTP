# --
# Kernel/System/Email/MultiSMTP.pm - the global email send module
# Copyright (C) 2013 - 2014 Perl-Services.de, http://perl-services.de
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
    for my $Needed (qw(Header Body ToArray)) {
        if ( !$Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # try to parse the sender address from header
    if ( !$Param{From} ) {
        ($Param{From}) = ${ $Param{Header} } =~ m{^ From: \s+ ([^\n]+) }xms;
    }

    if ( $Self->{Debug} ) {
        $LogObject->Log(
            Priority => 'notice',
            Message  => 'From: ' . $Param{From},
        );
    }

    my $SMTPObject;
    if ( !$Param{From} ) {

        # use standard SMTP module as fallback
        my $Module  = $ConfigObject->Get('MultiSMTP::Fallback');
        $SMTPObject = $Kernel::OM->Get( $Module );
        my $Success = $SMTPObject->Send( %Param );
        return $Success;
    }

    my $ParserObject = Kernel::System::EmailParser->new(
        Mode  => 'Standalone',
        Debug => 0,
    );

    my $PlainFrom = $ParserObject->GetEmailAddress(
        Email => $Param{From},
    );

    my %SMTP = $MSMTPObject->SMTPGetForAddress(
        Address => $PlainFrom,
    );

    if ( $Self->{Debug} ) {
        $LogObject->Log(
            Priority => 'notice',
            Message  => 'From: ' . ( $PlainFrom // '' ) . ' // SMTP: ' . ( $SMTP{ID} // '' ),
        );
    }

    if ( !%SMTP ) {

        # use standard SMTP module as fallback
        my $Module  = $ConfigObject->Get('MultiSMTP::Fallback');
        $SMTPObject = $Kernel::OM->Get( $Module );
        my $Success = $SMTPObject->Send( %Param );
        return $Success;
    }

    $SMTP{Password} = $SMTP{PasswordDecrypted};
    $SMTP{Type} =~ s/\W//g;

    my $Module = 'Kernel::System::Email::MultiSMTP::' . $SMTP{Type};
    $Kernel::OM->ObjectParamAdd(
        $Module => \%SMTP,
    );

    $SMTPObject  = $Kernel::OM->Get($Module);

    if ( $Self->{Debug} ) {
        $LogObject->Log(
            Priority => 'notice',
            Message  => "Use MultiSMTP $Module",
        );

        $LogObject->Log(
            Priority => 'notice',
            Message  => sprintf "Use SMTP %s/%s (%s)", $SMTP{Host}, $SMTP{User}, $SMTP{ID},
        );
    }

    return if !$SMTPObject;
    
    my $Success = $SMTPObject->Send( %Param );

    return $Success;
}

1;
