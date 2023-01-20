# --
# Copyright (C) 2011 - 2023 Perl-Services.de, https://www.perl-services.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminMultiSMTP;

use strict;
use warnings;

our @ObjectDependencies = qw(
    Kernel::System::MultiSMTP
    Kernel::System::Valid
    Kernel::System::Web::Request
    Kernel::Output::HTML::Layout
    Kernel::Config
    Kernel::System::Log
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ValidObject  = $Kernel::OM->Get('Kernel::System::Valid');
    my $SMTPObject   = $Kernel::OM->Get('Kernel::System::MultiSMTP');

    my @Params = qw(
        ID Host User PasswordDecrypted Type ValidID UserID Port Comments
        Anonymous AuthenticationType OAuth2Name
    );

    my %GetParam;
    for my $Needed (@Params) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed ) || '';
    }

    if ( $GetParam{Anonymous} ) {
        $GetParam{User}              = '';
        $GetParam{PasswordDecrypted} = '';
    }

    my @Mails = $ParamObject->GetArray( Param => 'Emails' );
    $GetParam{Emails} = \@Mails if @Mails;

    # ------------------------------------------------------------ #
    # get data 2 form
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Edit' || $Self->{Subaction} eq 'Add' ) {
        my %Subaction = (
            Edit => 'Update',
            Add  => 'Save',
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_MaskSMTPForm(
            %GetParam,
            %Param,
            Subaction => $Subaction{ $Self->{Subaction} },
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # update action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Update' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();
 
        # server side validation
        my %Errors;
        if (
            !$GetParam{ValidID} ||
            !$ValidObject->ValidLookup( ValidID => $GetParam{ValidID} )
            )
        {
            $Errors{ValidIDInvalid} = 'ServerError';
        }

        PARAM:
        for my $Param (qw(ID Host User Type ValidID Port)) {

            next PARAM if $GetParam{Anonymous} and $Param eq 'User';

            if ( !$GetParam{$Param} ) {
                $Errors{ $Param . 'Invalid' } = 'ServerError';
            }
        }

        if ( !$GetParam{Emails} || !@{ $GetParam{Emails} } ) {
              $Errors{EmailsInvalid} = 'ServerError';
        }

        if ( %Errors ) {
            $Self->{Subaction} = 'Edit';

            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $Self->_MaskSMTPForm(
                %GetParam,
                %Param,
                %Errors,
                Subaction => 'Update',
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        my $Update = $SMTPObject->SMTPUpdate(
            %GetParam,
            Password => $GetParam{PasswordDecrypted},
            UserID   => $Self->{UserID},
        );

        if ( !$Update ) {
            return $LayoutObject->ErrorScreen();
        }
        return $LayoutObject->Redirect( OP => "Action=AdminMultiSMTP" );
    }

    # ------------------------------------------------------------ #
    # insert smtp settings
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Save' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # server side validation
        my %Errors;
        if (
            !$GetParam{ValidID} ||
            !$ValidObject->ValidLookup( ValidID => $GetParam{ValidID} )
            )
        {
            $Errors{ValidIDInvalid} = 'ServerError';
        }

        PARAM:
        for my $Param (qw(ValidID User Host Type Port)) {

            next PARAM if $GetParam{Anonymous} and $Param eq 'User';

            if ( !$GetParam{$Param} ) {
                $Errors{ $Param . 'Invalid' } = 'ServerError';
            }
        }

        if ( !$GetParam{Emails} || !@{ $GetParam{Emails} } ) {
              $Errors{EmailsInvalid} = 'ServerError';
        }

        if ( %Errors ) {
            $Self->{Subaction} = 'Add';

            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $Self->_MaskSMTPForm(
                %GetParam,
                %Param,
                %Errors,
                Subaction => 'Save',
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        my $Success = $SMTPObject->SMTPAdd(
            %GetParam,
            Password => $GetParam{PasswordDecrypted},
            UserID   => $Self->{UserID},
        );

        if ( !$Success ) {
            return $LayoutObject->ErrorScreen();
        }
        return $LayoutObject->Redirect( OP => "Action=AdminMultiSMTP" );
    }

    elsif ( $Self->{Subaction} eq 'Delete' ) {
        $SMTPObject->SMTPDelete( %GetParam );
        return $LayoutObject->Redirect( OP => "Action=AdminMultiSMTP" );
    }

    # ------------------------------------------------------------ #
    # else ! print form
    # ------------------------------------------------------------ #
    else {
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_MaskSMTPForm();
        $Output .= $LayoutObject->Footer();
        return $Output;
    }
}

sub _MaskSMTPForm {
    my ( $Self, %Param ) = @_;

    my $SMTPObject   = $Kernel::OM->Get('Kernel::System::MultiSMTP');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ValidObject  = $Kernel::OM->Get('Kernel::System::Valid');

    my %SMTP;
    if ( $Self->{Subaction} eq 'Edit' ) {
        %SMTP = $SMTPObject->SMTPGet( ID => $Param{ID} );

        for my $Key ( keys %SMTP ) {
            $Param{$Key} = $SMTP{$Key} if !$Param{$Key};
        }

        if ( !$Param{User} && !$Param{PasswordDecrypted} ) {
            $Param{AnonymousChecked} = 'checked="checked"';
            $Param{AnonymousCall}    = 'anonymous();';
        }
    }

    $Param{Port} ||= 25;

    my %SMTPAddresses;
    my @Selected = @{ $Param{Emails} || [] } ? @{ $Param{Emails} } : @{ $SMTP{Emails} || [] };
    $SMTPAddresses{$_} = 1 for @Selected;

    my %SystemAddresses = $SMTPObject->SystemAddressList(
        %SMTPAddresses,
    );

    # add AdminEmail
    # add NotificationSenderEmail
    # add PostMaster::PreFilterModule::NewTicketReject::Sender
    CONFIGKEY:
    for my $ConfigKey ( qw/AdminEmail NotificationSenderEmail PostMaster::PreFilterModule::NewTicketReject::Sender/ ) {
        my $Mail = $ConfigObject->Get( $ConfigKey );

        next CONFIGKEY if !$Mail;
        next CONFIGKEY if $SystemAddresses{$Mail};

        $SystemAddresses{$Mail} = $Mail . ' (' . $ConfigKey . ')';
    }
    
    $Param{EmailsSelect} = $LayoutObject->BuildSelection(
        Data        => \%SystemAddresses,
        Name        => 'Emails',
        Size        => 5,
        Class       => 'Modernize Validate_Required ' . ( $Param{EmailsInvalid} || '' ),
        Multiple    => 1,
        SelectedID  => \@Selected,
        HTMLQuote   => 1,
    );


    $Param{TypeSelect} = $LayoutObject->BuildSelection(
        Data       => {
            'SMTP'    => 'SMTP',
            'SMTPS'   => 'SMTP/S',
            'SMTPTLS' => 'SMTPTLS',
        },
        Name       => 'Type',
        Size       => 1,
        SelectedID => $Param{Type} || $SMTP{Type},
        HTMLQuote  => 1,
        Class      => 'Modernize',
    );


    $Param{AuthenticationTypeSelect} = $LayoutObject->BuildSelection(
        Data       => {
            'password'     => 'Password',
            'oauth2_token' => 'OAuth2 Token',
        },
        Name        => 'AuthenticationType',
        Size        => 1,
        SelectedID  => $Param{AuthenticationType} || $SMTP{AuthenticationType} || 'password',
        HTMLQuote   => 1,
        Translation => 1,
        Class       => 'Modernize',
    );

    my $ValidID = $ValidObject->ValidLookup( Valid => 'valid' );

    $Param{ValidSelect} = $LayoutObject->BuildSelection(
        Data       => { $ValidObject->ValidList() },
        Name       => 'ValidID',
        Size       => 1,
        SelectedID => $Param{ValidID} || $ValidID || 1,
        HTMLQuote  => 1,
        Class      => 'Modernize',
    );

    if ( $Self->{Subaction} ne 'Edit' && $Self->{Subaction} ne 'Add' ) {

        my %SMTPList = $SMTPObject->SMTPList();
  
        if ( !%SMTPList ) {
            $LayoutObject->Block(
                Name => 'NoSMTPFound',
            );
        }

        for my $ID ( sort keys %SMTPList ) {
            my %SMTP = $SMTPObject->SMTPGet(
                ID => $ID,
            );

            $SMTP{EmailString} = join ', ', @{ $SMTP{Emails} || [] };

            $LayoutObject->Block(
                Name => 'SMTPRow',
                Data => \%SMTP,
            );
        }
    }

    $Param{SubactionName} = 'Update';
    $Param{SubactionName} = 'Save' if $Self->{Subaction} && $Self->{Subaction} eq 'Add';

    my $TemplateFile = 'AdminMultiSMTPList';
    $TemplateFile = 'AdminMultiSMTPForm' if $Self->{Subaction};

    return $LayoutObject->Output(
        TemplateFile => $TemplateFile,
        Data         => { %Param },
    );
}

1;
