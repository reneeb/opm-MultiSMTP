# --
# Kernel/Language/zh_CN_MultiSMTP.pm - the Chinese translation of MultiSMTP
# Copyright (C) 2011-2017 never.min@gmail.com
# Copyright (C) 2011 - 2023 Perl-Services.de, https://www.perl-services.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_MultiSMTP;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation} || {};

    # Kernel/Config/Files/MultiSMTP.xml
    $Lang->{'Frontend module registration for the MultiSMTP interface.'} = '';
    $Lang->{'Manage SMTP settings.'} = '管理发送邮件服务器';
    $Lang->{'SMTP settings'} = 'SMTP 配置';
    $Lang->{'The salt for password encryption. It has to have exactly 8 bytes!'} = '';
    $Lang->{'The key for password encryption.'} = '';
    $Lang->{'The fallback mechanism when MultiSMTP fails.'} = '';
    $Lang->{'Enable debugging mode of MultiSMTP.'} = '';
    $Lang->{'Debug MultiSMTP'} = '';
    $Lang->{'Debug MultiSMTP and Net::SMTP'} = '';

    # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPForm.tt
    $Lang->{'SMTP Management'} = '邮件服务器管理';
    $Lang->{'Add/Change SMTP'} = '增加或修改发送邮件服务器';
    $Lang->{'Anonymous SMTP'} = '';
    $Lang->{'Emails'} = '邮件地址';

    # Kernel/Output/HTML/Templates/Standard/AdminMultiSMTPList.tt
    $Lang->{'Add SMTP'} = '增加 SMTP';
    $Lang->{'ID'} = '';
    $Lang->{'Creator'} = '创建者';
    $Lang->{'No matches found.'} = '';
    $Lang->{'edit'} = '编辑';
    $Lang->{'delete'} = '删除';
}

1;
