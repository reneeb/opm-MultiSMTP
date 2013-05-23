# --
# Kernel/System/MultiSMTP.pm - All SMTP related functions should be here eventually
# Copyright (C) 2011-2013 Perl-Services.de
# --
# $Id: MultiSMTP.pm,v 1.1.1.1 2011/04/15 07:49:58 rb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::MultiSMTP;

use strict;
use warnings;

use Kernel::System::User;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1.1.1 $) [1];

=head1 NAME

Kernel::System::MultiSMTP - backend for product news

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::MultiSMTP;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $SMTPObject = Kernel::System::MultiSMTP->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject MainObject LogObject EncodeObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create needed objects
    $Self->{UserObject}  = Kernel::System::User->new( %{$Self} );
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    my $HasCBC = 1;
    eval{ require Crypt::CBC; 1; } or $HasCBC = 0;

    my $HasDES = 1;
    eval{ require Crypt::DES; 1; } or $HasDES = 0;

    $Self->{UseEncryption} = 0;
    if ( $HasCBC && $HasDES ) {
        $Self->{UseEncryption} = 1;
    }

    $Self->{EncryptionKey}    = $Self->{ConfigObject}->Get( 'MultiSMTP::EncryptionKey' ) || 'Key';
    $Self->{EncryptionSalt}   = $Self->{ConfigObject}->Get( 'MultiSMTP::Salt' )          || 'Salt';
    $Self->{EncryptionModule} = 'Crypt::DES';
    
    return $Self;
}

=item SMTPAdd()

to add a news 

    my $ID = $SMTPObject->SMTPAdd(
        Host     => 'your.smtp.tld',
        User     => 'SMTPUser',
        Password => 'secret',
        Type     => 'SMTP', # or SMTP/S
        Comments => 'A comment about this entry',
        Port     => 25,
        Emails   => [ 'test@test.tld', 'otrs@test.tld' ],
        ValidID  => 1,
        UserID   => 123,
    );

=cut

sub SMTPAdd {
    my ( $Self, %Param ) = @_;

    my @NeededFields = qw(User Password Emails Type ValidID UserID Port Host);

    # remove user and password from needed fields when this is an anonymous account
    if ( $Param{Anonymous} ) {
        $Param{User} = '';
        $Param{Password} = '';

        splice @NeededFields, 0, 2;
    }

    # check needed stuff
    for my $Needed (@NeededFields) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( ref $Param{Emails} ne 'ARRAY' ) {
        $Param{Emails} = [ $Param{Emails} ],
    }

    if ( $Self->{UseEncryption} ) {
        my $Cipher = Crypt::CBC->new(
            -key    => $Self->{EncryptionKey},
            -cipher => $Self->{EncryptionModule},
            -salt   => $Self->{EncryptionSalt},
        );

        $Param{Password} = $Cipher->encrypt_hex( $Param{Password} );
    }

    # insert new smtp
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO ps_multi_smtp '
            . '(host, smtp_user, smtp_password, encrypted, type, create_time, create_by, '
            . ' valid_id, change_time, change_by, port, comments) '
            . 'VALUES (?, ?, ?, ?, ?, current_timestamp, ?, ?, current_timestamp, ?, ?, ?)',
        Bind => [
            \$Param{Host},
            \$Param{User},
            \$Param{Password},
            \$Self->{UseEncryption},
            \$Param{Type},
            \$Param{UserID},
            \$Param{ValidID},
            \$Param{UserID},
            \$Param{Port},
            \$Param{Comments},
        ],
    );

    # get new invoice id
    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT MAX(id) FROM ps_multi_smtp WHERE host = ? AND smtp_user = ?',
        Bind  => [ \$Param{Host}, \$Param{User} ],
        Limit => 1,
    );

    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # log notice
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "SMTP '$ID' created successfully ($Param{UserID})!",
    );

    # add mail addresses
    my $SQLMails = 'INSERT INTO ps_multi_smtp_address (smtp_id, address) VALUES (?,?)';
    for my $Address ( @{ $Param{Emails} } ) {
        $Self->{DBObject}->Do(
            SQL => $SQLMails,
            Bind => [ \$ID, \$Address ],
        );
    }

    return $ID;
}


=item SMTPUpdate()

to update news 

    my $Success = $SMTPObject->SMTPUpdate(
        ID       => 3,
        Host     => 'your.smtp.tld',
        User     => 'SMTPUser',
        Password => 'secret',
        Type     => 'SMTP', # or SMTP/S
        Port     => 25,
        Comments => 'A comment',
        Emails   => [ 'test@test.tld', 'otrs@test.tld' ],
        ValidID  => 1,
        UserID   => 123,
    );

=cut

sub SMTPUpdate {
    my ( $Self, %Param ) = @_;

    my @NeededFields = qw(User Password Emails Type ValidID UserID Port Host);

    # remove user and password from needed fields when this is an anonymous account
    if ( $Param{Anonymous} ) {
        $Param{User} = '';
        $Param{Password} = '';

        splice @NeededFields, 0, 2;
    }

    # check needed stuff
    for my $Needed (@NeededFields) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( ref $Param{Emails} ne 'ARRAY' ) {
        $Param{Emails} = [ $Param{Emails} ],
    }

    if ( $Self->{UseEncryption} ) {
        my $Cipher = Crypt::CBC->new(
            -key    => $Self->{EncryptionKey},
            -cipher => $Self->{EncryptionModule},
            -salt   => $Self->{EncryptionSalt},
        );

        $Param{Password} = $Cipher->encrypt_hex( $Param{Password} );
    }

    # insert new news
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE ps_multi_smtp SET host = ?, smtp_user = ?, smtp_password = ?, type = ?, port = ?, '
            . 'encrypted = ?, valid_id = ?, change_time = current_timestamp, change_by = ?, '
            . 'comments = ? '
            . 'WHERE id = ?',
        Bind => [
            \$Param{Host},
            \$Param{User},
            \$Param{Password},
            \$Param{Type},
            \$Param{Port},
            \$Self->{UseEncryption},
            \$Param{ValidID},
            \$Param{UserID},
            \$Param{Comments},
            \$Param{ID},
        ],
    );

    $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ps_multi_smtp_address WHERE smtp_id = ?',
        Bind => [ \$Param{ID} ],
    );

    # add mail addresses
    my $SQLMails = 'INSERT INTO ps_multi_smtp_address (smtp_id, address) VALUES (?,?)';
    for my $Address ( @{ $Param{Emails} } ) {
        $Self->{DBObject}->Do(
            SQL => $SQLMails,
            Bind => [ \$Param{ID}, \$Address ],
        );
    }

    return 1;
}

=item SMTPGet()

returns a hash with news data

    my %SMTPData = $SMTPObject->SMTPGet( ID => 2 );

This returns something like:

    %SMTPData = (
        ID         => 3,
        Host       => 'your.smtp.tld',
        User       => 'SMTPUser',
        Password   => 'encrypted',
        PasswordDecrypted   => 'secret',
        Comments   => 'A comment',
        Type       => 'SMTP', # or SMTP/S
        Emails     => [ 'test@test.tld', 'otrs@test.tld' ],
        CreateTime => '2010-04-07 15:41:15',
        ChangeTime => '2010-04-07 15:41:15',
        CreateBy   => 123,
        ChangeBy   => 123,
    );

=cut

sub SMTPGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ID!',
        );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT ps_multi_smtp.id, host, smtp_user, smtp_password, type, address, encrypted, '
            . 'change_time, change_by, create_time, create_by, valid_id, port, comments '
            . 'FROM ps_multi_smtp INNER JOIN ps_multi_smtp_address ON ps_multi_smtp.id = smtp_id '
            . 'WHERE ps_multi_smtp.id = ?',
        Bind  => [ \$Param{ID} ],
    );

    my %SMTP;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $SMTP{ID}         = $Data[0];
        $SMTP{Host}       = $Data[1];
        $SMTP{User}       = $Data[2];
        $SMTP{Password}   = $Data[3];
        $SMTP{Type}       = $Data[4];
        $SMTP{Encrypted}  = $Data[6];
        $SMTP{ChangeTime} = $Data[7];
        $SMTP{ChangeBy}   = $Data[8];
        $SMTP{CreateTime} = $Data[9];
        $SMTP{CreateBy}   = $Data[10];
        $SMTP{ValidID}    = $Data[11];
        $SMTP{Port}       = $Data[12];
        $SMTP{Comments}   = $Data[13];

        push @{ $SMTP{Emails} }, $Data[5];
    }

    if ( %SMTP ) {
        $SMTP{Valid}   = $Self->{ValidObject}->ValidLookup( ValidID => $SMTP{ValidID} );
        $SMTP{Creator} = $Self->{UserObject}->UserLookup( UserID => $SMTP{CreateBy} );
        $SMTP{Changer} = $Self->{UserObject}->UserLookup( UserID => $SMTP{ChangeBy} );

        if ( $SMTP{Encrypted} ) {
            my $Cipher = Crypt::CBC->new(
                -key    => $Self->{EncryptionKey},
                -cipher => $Self->{EncryptionModule},
                -salt   => $Self->{EncryptionSalt},
            );

            $SMTP{PasswordDecrypted} = $Cipher->decrypt_hex( $SMTP{Password} );
        }
        else {
            $SMTP{PasswordDecrypted} = $SMTP{Password};
        }
    }

    return %SMTP;
}

=item SMTPDelete()

deletes a news entry. Returns 1 if it was successful, undef otherwise.

    my $Success = $SMTPObject->SMTPDelete(
        ID => 123,
    );

=cut

sub SMTPDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ID!',
        );
        return;
    }

    $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ps_multi_smtp_address WHERE smtp_id = ?',
        Bind => [ \$Param{ID} ],
    );

    return $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ps_multi_smtp WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
}


=item SMTPList()

returns a hash of all news

    my %SMTPs = $SMTPObject->SMTPList();

the result looks like

    %SMTPs = (
        '1' => 'SMTP 1',
        '2' => 'Test SMTP',
    );

=cut

sub SMTPList {
    my ( $Self, %Param ) = @_;

    my $Where = '';
    my @Bind;

    if ( $Param{Valid} ) {
        my $ValidID = $Self->{ValidObject}->ValidLookup( Valid => 'valid' );
        $Where = 'WHERE valid_id = ?';
        @Bind  = ( \$ValidID );
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL  => "SELECT id, host FROM ps_multi_smtp $Where",
        Bind => \@Bind,
    );

    my %SMTP;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $SMTP{ $Data[0] } = $Data[1];
    }

    return %SMTP;
}

=item SMTPGetForAddress()

    my %SMTP = $Object->SMTPGetForAddress(
        Address => 'test@test.tld',
    );

=cut

sub SMTPGetForAddress {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Address)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT ps_multi_smtp.id, host, smtp_user, smtp_password, type, address, encrypted, '
            . 'change_time, change_by, create_time, create_by, valid_id, port, comments '
            . 'FROM ps_multi_smtp INNER JOIN ps_multi_smtp_address ON ps_multi_smtp.id = smtp_id '
            . 'WHERE address = ?',
        Bind  => [ \$Param{Address} ],
        Limit => 1,
    );

    my %SMTP;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %SMTP = (
            ID         => $Data[0],
            Host       => $Data[1], 
            User       => $Data[2],
            Password   => $Data[3],
            Type       => $Data[4],
            Email      => $Data[5],
            Encrypted  => $Data[6],
            ChangeTime => $Data[7],
            ChangeBy   => $Data[8],
            CreateTime => $Data[9],
            CreateBy   => $Data[10],
            ValidID    => $Data[11],
            Port       => $Data[12],
            Comments   => $Data[13],
        );
    }

    if ( %SMTP ) {
        $SMTP{Valid}   = $Self->{ValidObject}->ValidLookup( ValidID => $SMTP{ValidID} );
        $SMTP{Creator} = $Self->{UserObject}->UserLookup( UserID => $SMTP{CreateBy} );
        $SMTP{Changer} = $Self->{UserObject}->UserLookup( UserID => $SMTP{ChangeBy} );

        if ( $SMTP{Encrypted} ) {
            my $Cipher = Crypt::CBC->new(
                -key    => $Self->{EncryptionKey},
                -cipher => $Self->{EncryptionModule},
                -salt   => $Self->{EncryptionSalt},
            );

            $SMTP{PasswordDecrypted} = $Cipher->decrypt_hex( $SMTP{Password} );
        }
        else {
            $SMTP{PasswordDecrypted} = $SMTP{Password};
        }
    }

    return %SMTP;
}

=item SystemAddressList()

    my %List = $Object->SystemAddressList();

returns a list of all system addresses that are not already mapped to a SMTP.

=cut

sub SystemAddressList {
    my ( $Self, %Param ) = @_;

    my $SQL = 'SELECT value0, value1 FROM system_address';

    return if !$Self->{DBObject}->Prepare(
        SQL => $SQL,
    );

    my @Addresses;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @Addresses, { address => $Row[0], name => $Row[1] };
    }

    my %List;
    for my $Address ( @Addresses ) {
        my $Email = $Address->{address};
        next if !$Param{$Email} && $Self->SMTPGetForAddress( Address => $Email );
        $List{$Email} = sprintf "%s (%s)", $Email, $Address->{name};
    }

    return %List;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.1.1.1 $ $Date: 2011/04/15 07:49:58 $

=cut
