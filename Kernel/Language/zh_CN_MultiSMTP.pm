# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2011-2017 never.min@gmail.com
# Copyright (C) 2011 - 2021 Perl-Services.de, http://perl-services.de/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
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
