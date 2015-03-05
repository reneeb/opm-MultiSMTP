# --
# Kernel/Language/zh_CN_MultiSMTP.pm - the Chinese translation of MultiSMTP
# Copyright (C) 2011-2014 never.min@gmail.com
# Copyright (C) 2011-2014 Perl-Services.de, http://perl-services.de/
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

    $Self->{Translation}->{'Add SMTP'}             = '增加 SMTP';
    $Self->{Translation}->{'SMTP settings'}        = 'SMTP 配置';
    $Self->{Translation}->{'Manage SMTP settings'} = '管理发送邮件服务器';
    $Self->{Translation}->{'Add/Change SMTP'}      = '增加或修改发送邮件服务器';
    $Self->{Translation}->{'Type is mandatory'}    = '类型';
    $Self->{Translation}->{'A host is required'}   = '邮件服务器地址是必须的';
    $Self->{Translation}->{'User is mandatory'}    = '用户名';
    $Self->{Translation}->{'Port is mandatory'}    = '端口';
    $Self->{Translation}->{'Email is mandatory'}   = '邮件地址';
    $Self->{Translation}->{'SMTP Management'}      = '邮件服务器管理';
    $Self->{Translation}->{'Emails'}               = '邮件地址';


}

1;
