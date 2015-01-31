# BUGS AND IMPORTANT NOTES:
# - Cutoff text is almost always caused by the script's idea of what your
#   user@host is being too short. It's important for this script to know the
#   userhost EVERYONE ELSE SEES.

# - So, we NOTICE self to get a user@host on connect, on usermode changes
#   (since most cloak and vhost systems are caused by or cause a usermode
#   change), and on /upgrade. These might not be the only ways a user@host can
#   change, so there's a /splitlong get command so you can try to update the
#   user@host.
#
# - $server->{userhost} provided by irssi is not useful for this since it only
#   fills if you have joined channels, and then never updates, and cannot be
#   changed from a perl script.
#
# - /msg #foo,bar,#baz is unsupported and will split the lines a little too
#   early (but won't ever cutoff or destroy your messages).

use strict;
use warnings;
use Irssi;

our $VERSION = "0.20.47";
our %IRSSI = (
  name        => "splitlong",
  description => "Split messages and actions to not exceed length allowed by ircd",
  url         => "http://scripts.irssi.org/scripts/splitlong.pl",
  authors     => "ferret",
  contact     => "ferret(tA)explodingferret(moCtoD), ferret on irc.freenode.net",
  origin      => "original author Bjoern 'fuchs' Krombholz, bjkro\@gmx.de",
  licence     => "Public Domain",
  changed     => "2008-06-19",
  changes     => <<'EOT',
0.20.47: check winitem type for compatibility with other scripts
0.20.46: major cleanup
0.20.45: cleanup, remove 001 stuff, fix redirects
0.20.44: support /me, /msg -chatnet, aggressively get userhost
EOT
  modules     => "",
  commands    => "splitlong",
);

our %userhosts = ();

sub debug_print {
  Irssi::print "\%c$IRSSI{name}\%n: \%Rwarning2\%n: " . join( "\n  ", @_ ), MSGLEVEL_CLIENTERROR;
}
sub pretty_print {
  Irssi::print "\%c$IRSSI{name}\%n: " . join( "\n  ", @_ ), MSGLEVEL_CLIENTCRAP;
}

Irssi::settings_add_int 'splitlong', 'splitlong_safety_margin', 0;
Irssi::settings_add_str 'splitlong', 'splitlong_line_start',    "... ";
Irssi::settings_add_str 'splitlong', 'splitlong_line_end',      " ...";

# to get free tab completion
Irssi::command_bind 'splitlong help'  => undef;
Irssi::command_bind 'splitlong get'   => undef;
Irssi::command_bind 'splitlong print' => undef;
Irssi::command_bind 'splitlong'       => sub {
  my( $args, $server ) = @_;
  $args =~ s/ *$//;

  if( $args eq 'help' ) { 
    pretty_print( "version $VERSION", $IRSSI{description}, <<'EOT' );

/set splitlong_safety_margin <integer>
  If you experience cutoff, you can set this to about how many characters get
  cut off and it should fix it. I'd rather you contacted me though.
  Default: 0 (recommended unless you have issues)

/set splitlong_line_start <string>
/set splitlong_line_end <string>
  Defaults: "... ", " ...".

/splitlong get
  Get your user@host from the server and store it
  Try this first if you have problems

/splitlong print
  Prints the script's current idea of your remotely viewed user@host
  To print it for all servers, use: /foreach server /splitlong print
EOT
  }
  elsif( $args eq 'print' ) {
    print "$server->{tag}: $userhosts{$server->{tag}}";
  }
  elsif( $args eq 'get' ) {
    update_userhost( $server );
  }
  else {
    pretty_print( "for help: /splitlong help" );
  }
};



# main splitting handler
Irssi::signal_add_first 'command msg'    => sub { sig_command_msg( @_, 'msg'    ); };
Irssi::signal_add_first 'command action' => sub { sig_command_msg( @_, 'action' ); };
Irssi::signal_add_first 'command me'     => sub { sig_command_msg( @_, 'me'     ); };
sub sig_command_msg {
  my ( $cmd, $server, $winitem, $action ) = @_;

  if( $cmd =~ s/^SPLIT_WITH_SPLITLONG// ) {
    # we must have split this already
    Irssi::signal_continue $cmd, $server, $winitem;
    return;
  }

  # From /help:
  #   MSG [-<server tag>] [-channel | -nick] <targets> <message>
  #   ACTION [-<server tag>] <target> <message>
 
  # Also note that /say does /msg * <message> and text entry in a channel or
  # query window does for e.g. /msg -channel "#channel" <message>
  my ( $param, $target, $data ) = $action eq 'me'
   ? ( '', '', $cmd )
   : $cmd =~ /^((?:-\S*\s)*)(\S*\s)(.*)/;

  return unless defined $data;

  my $real_server = $server;
  if( $param =~ /^-(\S*)/ ) {
    unless( $1 eq 'nick' or $1 eq 'channel') {
      $real_server = Irssi::server_find_tag $1;
    }
  }
  
  return unless $real_server && $real_server->{connected};

  # expected values of $target are:
  # '"#channel" ', '*', 'somenick', or '#chan'
  my( $real_target ) = $target =~ /^"?(.*?)"?\s?$/;
  if( $real_target eq '*' or $real_target eq '' ) {
    # it's a /say (which is really a /msg *) or a /me
    # they don't make sense outside of a channel or query
    return unless $winitem && $winitem->{name};
    return unless $winitem->{type} eq "CHANNEL" || $winitem->{type} eq "QUERY";
    $real_target = $winitem->{name};
  }

  my $safety = Irssi::settings_get_int 'splitlong_safety_margin';
  my $lstart = Irssi::settings_get_str 'splitlong_line_start';
  my $lend   = Irssi::settings_get_str 'splitlong_line_end';

  if( not $userhosts{$real_server->{tag}} ) {
    debug_print( "no userhost for $real_server->{tag}; do /splitlong get",
      "if you see this more than once let me know" );
    return;
  }
  
  # :mynick!user@host PRIVMSG nick :message
  # 497 = 510 - length(":" . "!" . " PRIVMSG " . " :");
  my $maxlength = 497 - length( $real_server->{nick} . $userhosts{$real_server->{tag}} . $real_target );

  # 9 = length( "\01ACTION " . $msg . "\01" ) - length( $msg );
  $maxlength -= 9 if $action eq 'me' || $action eq 'action';
  $maxlength -= $safety;
  my $maxlength2 = $maxlength - length( $lend );

  if ( length( $data ) > $maxlength ) {
    my ( $pos, $datachunk );

    while ( length( $data ) > $maxlength2 ) {
      $pos = rindex( $data, " ", $maxlength2 );
      # if the rightmost space ($pos) is more than 60 chars away fom the line
      # end, split mid-word instead
      $datachunk = substr( $data, 0, $pos < 60 ? $maxlength2 : $pos ) . $lend;

      # There's no way to stop this script from recapturing the signal we
      # need to emit here, so we 'mark' it to prevent it being processed twice
      Irssi::signal_emit "command $action", 'SPLIT_WITH_SPLITLONG' . $param . $target . $datachunk, $server, $winitem;

      $data = $lstart . substr( $data, $pos < 60 ? $maxlength2 : $pos + 1 );
    }
    
    Irssi::signal_continue $param . $target . $data, $server, $winitem;
  }
}


# get userhost from server 500ms after end of motd
Irssi::signal_add_last 'event 376' => sub {
  my( $server ) = @_;
  Irssi::timeout_add_once 500, sub {
    my( $servtag ) = @_;
    update_userhost( Irssi::server_find_tag $servtag );
  }, $server->{tag};
};

# when a /umode is received from $servtag, $userhosts{$servtag} needs redoing
Irssi::signal_add_last 'user mode changed' => sub {
  my( $server ) = @_;
  update_userhost( $server );
};

# when an /upgrade has happened or the script first loads, %userhosts needs
# completely refilling
Irssi::signal_add_last 'session restore' => \&gethostallnets;
sub gethostallnets {
  update_userhost( $_ ) for Irssi::servers;
}

# fire off a notice to self, the reply of is caught by redir signal
sub update_userhost {
  my( $server ) = @_;
  unless( defined $server->{chat_type} and $server->{chat_type} eq 'IRC' ) {
    debug_print( "server '$server->{tag}' doesn't have a chat_type of IRC - try '/splitlong get' later?" );
    return;
  }

  # catch the next notice starting with 'splitlong.pl'
  # this redirect is registered just after this subroutine
  $server->redirect_event( 'SL notice', 1, ':splitlong.pl', -1,
   '', { 'event notice' => 'redir SL notice' } );

  $server->send_raw( "NOTICE $server->{nick} :splitlong.pl - you shouldn't be seeing this, contact me" );
}

# a notice to self is used to get the real userhost others would see
Irssi::Irc::Server::redirect_register 'SL notice', 1, 5,
 undef, { "event notice" => 1 }, undef;

# redirect reply signal catcher
Irssi::signal_add_first 'redir SL notice' => sub {
  my( $server, $cmd, $nick, $userhost ) = @_;
  $userhosts{$server->{tag}} = $userhost;
};

pretty_print( "version $VERSION loaded. For help: /splitlong help" );
gethostallnets(); # gets user@host for all networks

