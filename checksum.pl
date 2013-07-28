#!/opt/local/bin/perl
# Author: Ng, Tzy Luen
# Date: : Sun Jul 28 13:16:19 MYT 2013
# Desc  : a cozy sunday with sundae
#
use DBI;
use warnings;
use strict;
use Data::Dumper;

my($db,$host,$port,$user,$password,$sock) = qw(information_schema localhost 3306 root asecdbset /tmp/mysql.sock);

my $dbh = DBI->connect("DBI:mysql:$db:$host;port=$port;mysql_socket=/tmp/mysql.sock",$user,$password,
            {PrintError => 1}) or die "$DBI::errstr\n";


&checksum();

# paras:
# (source, $file.dat); where source is live and file.dat is precomputed file
# + if $file.dat is not present, it computes the source and produce the $file.dat
sub checksum {
    my $pstmt = $dbh->prepare("SELECT `table_schema`, `table_name` FROM `tables`");
    $pstmt->execute();
    while (my $row = $pstmt->fetchrow_hashref()) {
        print "$row->{'table_schema'}.$row->{'table_name'}\n";
        my $pchecksum = $dbh->prepare("CHECKSUM TABLE ".$row->{'table_schema'}.".".$row->{'table_name'});
        $pchecksum->execute();
        print Dumper $pchecksum->fetchrow_hashref();
        #if ($pchecksum->execute("$row->{'table_schema'}.$row->{'table_name'}") &&
        #    (my $_row = $pchecksum->fetchrow_hashref())) {
        #    print "$_row->{'Table'} | $_row->{'Checksum'}\n";
        #}
    }
    #my $pstmt = $dbh->prepare("CHECKSUM TABLE ");
    #$pstmt->execute();
}


#foreach $pattern (@ARGV) {
#  my ($sth,$row);
#  $rv= $sth->execute($pattern);
#  if(!int($rv)) {
#    warn "Can't get tables matching '$pattern' from $opt_database; $DBI::errstr\n"; 
#    exit(1) unless $opt_force;
#  }
#  while (($row = $sth->fetchrow_arrayref)) {
#    push(@tables, $row->[0]);
#  }
#  $sth->finish;
#}
#
#print "Converting tables:\n" if ($opt_verbose);
#foreach $table (@tables) {
#  my ($sth,$row);
#
#  # Check if table is already converted
#  $sth=$dbh->prepare("show table status like '$table'");  
#  if ($sth->execute && ($row = $sth->fetchrow_arrayref)) {
#    if (uc($row->[1]) eq uc($opt_engine)) {
#      print "$table already uses the '$opt_engine' engine;  Ignored\n";
#      next;
#    }
#  }
#  print "converting $table\n" if ($opt_verbose);
#  $table=~ s/`/``/g;
#  if (!$dbh->do("ALTER TABLE `$table` ENGINE=$opt_engine")) {
#    print STDERR "Can't convert $table: Error $DBI::errstr\n";
#    exit(1) if (!$opt_force);
#  }
#}
#
#$dbh->disconnect;
#
#sub usage {
#    print "read the source\n";
#    exit(1);
#}
