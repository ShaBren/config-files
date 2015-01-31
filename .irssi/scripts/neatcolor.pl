use Irssi;
use strict;

use vars qw($VERSION %IRSSI);

$VERSION="0.1";
%IRSSI = (
	authors=> 'BC-bd, Nei',
	name=> 'neatcolor',
	description=> 'colourise nicks',
	license=> 'GPL v2',
);

# based on nm.pl by BC-bd
# inspired by nickcolor.pl by Timo Sirainen and Ian Peters
# DO NOT LOAD IF YOU ARE ALREADY USING nm!
#
#########
# USAGE
###
# 
# use
# 
# 	/neatcolor help
#
# for help on available commands
#
#########
# OPTIONS
#########

my $help = "
/set neat_colors <string>
    Use these colors when colorizing nicks, eg:

        /set neat_colors yYrR

    See the file formats.txt on an explanation of what colors are
    available.

/set neat_right_mode <ON|OFF>
    * ON  : print the mode of the nick e.g @%+ after the nick
    * OFF : print it left of the nick 

/set neat_melength <number>
    * number : number of spaces to substract from /me padding

/set neat_ignorechars <str>
    * str : regular expression used to filter out unwanted characters in
            nicks. this can be used to assign the same color for similar
            nicks, e.g. foo and foo_:

                /set neat_ignorechars [_]

";

my (%saved_colors, @colors, $alignment, $sign, %commands);

# a new nick was created
sub sig_newNick
{
	my ($channel, $nick) = @_;

	return if (exists($saved_colors{$nick->{nick}}));

	$saved_colors{$nick->{nick}} = "%".nick_to_color($nick->{nick});
}

# something changed
sub sig_changeNick
{
	my ($channel, $nick, $old_nick) = @_;

	# if no saved color exists, we already handled this nickchange. irssi
	# generates one signal per channel the nick is in, so if you share more
	# than one channel with this nick, you'd lose the coloring.
	return unless exists($saved_colors{$old_nick});

	# we need to update the saved colorors hash independent of nick length
	$saved_colors{$nick->{nick}} = $saved_colors{$old_nick};
	delete $saved_colors{$old_nick};
}

# based on simple_hash from nickcolor.pl
sub nick_to_color($) {
	my ($string) = @_;
	chomp $string;

	my $ignore = Irssi::settings_get_str("neat_ignorechars");
	$string =~ s/$ignore//g;

	my $counter = 5381;
	foreach my $char (split(//, $string)) {
		$counter *= 33;
		$counter ^= ord $char;
	}

	return $colors[$counter % ($#colors + 1)];
}

sub color_left($) {
	Irssi::command('^format pubmsg {pubmsgnick $2 {pubnick '.$_[0].'$0}}$1');
	Irssi::command('^format pubmsg_channel {pubmsgnick $2 {pubnick '.$_[0].'$0}}$1');
}

sub color_right($) {
	Irssi::command('^format pubmsg {pubmsgnick {pubnick '.$_[0].'$0}$2}$1');
	Irssi::command('^format pubmsg_channel {pubmsgnick {pubnick '.$_[0].'$0}$2}$1');
}

sub sig_public {
	my ($server, $msg, $nick, $address, $target) = @_;

	&$alignment($saved_colors{$nick});
}

sub sig_setup {
	@colors = Irssi::settings_get_str('neat_colors') =~ /(x..|.)/ig;

	# check left or right alignment
	if (Irssi::settings_get_bool('neat_right_mode') == 0) {
		$alignment = \&color_left;
	} else {
		$alignment = \&color_right;
	}
	
	&$alignment('%w');
}

# make sure that every nick has an assigned color
sub assert_colors() {
	foreach (Irssi::channels()) {
		foreach ($_->nicks()) {
			next if (exists($saved_colors{$_->{nick}}));

			$saved_colors{$_->{nick}} = "%".nick_to_color($_->{nick});
		}
	}
}

# load colors from file
sub load_colors() {
	open(FID, "<".$ENV{HOME}."/.irssi/saved_colors") || return;

	while (<FID>) {
		chomp;
		my ($k, $v) = split(/:/);

		# skip broken lines, those may have been introduced by nm.pl
		# version 0.3.7 and earlier
		if ($k eq '' || $v eq '') {
			neat_log(Irssi::active_win(), "Warning, broken line in saved_colors file, skipping '$k:$v'");
			next;
		}

		$saved_colors{$k} = $v;
	}

	close(FID);
}

# save colors to file
sub save_colors() {
	open(FID, ">".$ENV{HOME}."/.irssi/saved_colors");

	print FID $_.":".$saved_colors{$_}."\n" foreach (keys(%saved_colors));

	close(FID);
}

# log a line to a window item
sub neat_log($@) {
	my ($witem, @text) = @_;

	$witem->print("neatcolor.pl: ".$_) foreach(@text);
}

# show available colors
sub cmd_neatcolor_colors($) {
	my ($witem, undef, undef) = @_;

	neat_log($witem, "Available colors: ".join("", map { "%".$_.$_ } @colors));
}

# display the configured color for a nick
sub cmd_neatcolor_get() {
	my ($witem, $nick, undef) = @_;

	if (!exists($saved_colors{$nick})) {
		neat_log($witem, "Error: no such nick '$nick'");
		return;
	}

	neat_log($witem, "Color for ".$saved_colors{$nick}.$nick);
}

# display help
sub cmd_neatcolor_help() {
	my ($witem, $cmd, undef) = @_;

	if ($cmd) {
		if (!exists($commands{$cmd})) {
			neat_log($witem, "Error: no such command '$cmd'");
			return;
		}

		if (!exists($commands{$cmd}{verbose})) {
			neat_log($witem, "No additional help for '$cmd' available");
			return;
		}

		neat_log($witem, ( "", "Help for ".uc($cmd), "" ) );
		neat_log($witem, @{$commands{$cmd}{verbose}});
		return;
	}

	neat_log($witem, split(/\n/, $help));
	neat_log($witem, "Available options for /neatcolor");
	neat_log($witem, "    ".$_.": ".$commands{$_}{text}) foreach(sort(keys(%commands)));

	my @verbose;
	foreach (sort(keys(%commands))) {
		push(@verbose, $_) if exists($commands{$_}{verbose});
	}

	neat_log($witem, "Verbose help available for: '".join(", ", @verbose)."'");
}

# list configured nicks
sub cmd_neatcolor_list() {
	my ($witem, undef, undef) = @_;

	neat_log($witem, "Configured nicks: ".join(", ", map { $saved_colors{$_}.$_ } sort(keys(%saved_colors))));
}

# reset a nick to its default color
sub cmd_neatcolor_reset() {
	my ($witem, $nick, undef) = @_;

	if ($nick eq '--all') {
		%saved_colors = ();
		assert_colors();
		neat_log($witem, "Reset all colors");
		return;
	}

	if (!exists($saved_colors{$nick})) {
		neat_log($witem, "Error: no such nick '$nick'");
		return;
	}

	$saved_colors{$nick} = "%".nick_to_color($nick);
	neat_log($witem, "Reset color for ".$saved_colors{$nick}.$nick);
}

# save configured colors to disk
sub cmd_neatcolor_save() {
	my ($witem, undef, undef) = @_;

	save_colors();

	neat_log($witem, "color information saved");
}

# set a color for a nick
sub cmd_neatcolor_set() {
	my ($witem, $nick, $color) = @_;

	my @found = grep(/$color/, @colors);
	if ($#found) {
		neat_log($witem, "Error: trying to set unknown color '%$color$color%n'");
		cmd_neatcolor_colors($witem);
		return;
	}

	if ($witem->{type} ne "CHANNEL" && $witem->{type} ne "QUERY") {
		neat_log($witem, "Warning: not a Channel/Query, can not check nick!");
		neat_log($witem, "Remember, nicks are case sensitive to neatcolor.pl");
	} else {
		my @nicks = grep(/^$nick$/i, map { $_->{nick} } ($witem->nicks()));

		if ($#nicks < 0) {
			neat_log($witem, "Warning: could not find nick '$nick' here");
		} else {
			if ($nicks[0] ne $nick) {
				neat_log($witem, "Warning: using '$nicks[0]' instead of '$nick'");
				$nick = $nicks[0];
			}
		}
	}

	$saved_colors{$nick} = "%".$color;
	neat_log($witem, "Set color for $saved_colors{$nick}$nick");
}

%commands = (
	colors => {
		text => "show available colors",
		verbose => [
			"COLORS",
			"",
			"displays all available colors",
			"",
			"You can restrict/define the list of available colors ".
			"with the help of the neat_colors setting"
		],
		func => \&cmd_neatcolor_colors,
	},
	get => {
		text => "retrieve color for a nick",
		verbose => [
			"GET <nick>",
			"",
			"displays color used for <nick>"
		],
		func => \&cmd_neatcolor_get,
	},
	help => {
		text => "print this help message",
		func => \&cmd_neatcolor_help,
	},
	list => {
		text => "list configured nick/color pairs",
		func => \&cmd_neatcolor_list,
	},
	reset => {
		text => "reset color to default",
		verbose => [
			"RESET --all|<nick>",
			"",
			"resets the color used for all nicks or for <nick> to ",
			"its internal default",
		],
		func => \&cmd_neatcolor_reset,
	},
	save => {
		text => "save color information to disk",
		verbose => [
			"SAVE",
			"",
			"saves color information to disk, so that it survives ".
			"an irssi restart.",
			"",
			"Color information will be automatically saved on /quit",
		],
		func => \&cmd_neatcolor_save,
	},
	set => {
		text => "set a specific color for a nick",
		verbose => [
			"SET <nick> <color>",
			"",
			"use <color> for <nick>",
			"",
			"This command will perform a couple of sanity checks, ".
			"when called from a CHANNEL/QUERY window",
			"",
			"EXAMPLE:",
			"  /neatcolor set bc-bd r",
			"",
			"use /neatcolor COLORS to see available colors"
		],
		func => \&cmd_neatcolor_set,
	},
);

# the main command callback that gets called for all neatcolor commands
sub cmd_neatcolor() {
	my ($data, $server, $witem) = @_;
	my ($cmd, $nick, $color) = split (/ /, $data);

	$cmd = lc($cmd);

	# make sure we have a valid witem to print text to
	$witem = Irssi::active_win() unless ($witem);

	if (!exists($commands{$cmd})) {
		neat_log($witem, "Error: unknown command '$cmd'");
		&{$commands{"help"}{"func"}}($witem) if (exists($commands{"help"}));
		return;
	}

	&{$commands{$cmd}{"func"}}($witem, $nick, $color);
}

Irssi::settings_add_bool('misc', 'neat_right_mode', 0);
Irssi::settings_add_str('misc', 'neat_colors', 'rRgGybBmMcCX42X3AX5EX4NX3HX3CX32');
Irssi::settings_add_str('misc', 'neat_ignorechars', '');

Irssi::command_bind('neatcolor', 'cmd_neatcolor');

Irssi::signal_add('nicklist new', 'sig_newNick');
Irssi::signal_add('nicklist changed', 'sig_changeNick');
Irssi::signal_add('message public', 'sig_public');
Irssi::signal_add('setup changed', 'sig_setup');
Irssi::signal_add_last('setup reread', 'sig_setup');

sig_setup;

load_colors();
assert_colors();

# we need to add this signal _after_ the colors have been loaded, to make sure
# no race condition exists wrt color saving
Irssi::signal_add('gui exit', 'save_colors');
