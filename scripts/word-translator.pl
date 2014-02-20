#! perl -w
# Author:   Giacomo Mantani
# Website:  http://jake.anapnea.net
# Based on: http://www.github.com/muennich/urxvt-perls
# License:  GPLv2

# Use keyboard shortcuts and Google-Translate to translate words.

# Put this file inside your /PATH/.urxvt/etc/

# Usage: put the following lines in your .Xdefaults/.Xresources:
#   URxvt.perl-ext-common: ...,word-translator
#   URxvt.keysym.M-t: perl:word-select:select_next

# Use Meta-t to activate WORD selection mode, then use the following keys:
#   j/k:      Select & Translate next downward/upward word (also with arrow keys)
#   g/G:      Select & Translate first/last word (also with home/end key)
#   o/Return: Open selected word in dictionary.com
#   y:        
#   q/Escape: Deactivate

# Options:
#   URxvt.word-select.launcher:  Browser/command to open selected URL with

use strict;

sub on_start {
	my ($self) = @_;

	# read resource settings
	if ($self->x_resource('word-select.launcher')) {
		@{$self->{browser}} = split /\s+/, $self->x_resource('word-select.launcher');
	} else {
		@{$self->{browser}} = ('x-www-browser');
	}

	if ($self->x_resource('matcher.pattern')) {
		@{$self->{pattern}} = ($self->x_resource('matcher.pattern'));
	} elsif ($self->x_resource('matcher.pattern.1')) {
		my $current = 1;

		while ($self->x_resource("matcher.pattern.$current")) {
			push @{$self->{pattern}}, $self->x_resource("matcher.pattern.$current");
			$current++;
		}
	} else {
		@{$self->{pattern}} = qr{([a-zA-Z]+)}x;
	}

	()
}


sub line_update {
	my ($self, $row) = @_;

	my $line = $self->line($row);
	my $text = $line->t;
	my $rend = $line->r;

	for my $pattern (@{$self->{pattern}}) {
		while ($text =~ /$pattern/g) {
			my $url = $&;
			my ($beg, $end) = ($-[1], $+[1] - 1);
			--$end if $url =~ /["')]$/;

			for (@{$rend}[$beg .. $end]) {
				$_ |= urxvt::RS_Uline;
			}
			$line->r($rend);
		}
	}

	()
}


sub on_user_command {
	my ($self, $cmd) = @_;

	if ($cmd eq 'word-select:select_next') {
		if (not $self->{active}) {
			activate($self);
		}
		select_next($self, -1);
	}

	()
}


sub key_press {
	my ($self, $event, $keysym) = @_;
	my $char = chr($keysym);

	if ($keysym == 0xff1b || lc($char) eq 'q') {
		deactivate($self);
	} elsif ($char eq 'd') {
		$self->exec_async(@{$self->{browser}}, "http://dictionary.reference.com/browse/".${$self->{found}[$self->{n}]}[4]);
		deactivate($self) unless $char eq 'd';
	} elsif ($keysym == 0xff0d || $char eq 'o') {
		$self->exec_async(@{$self->{browser}}, "http://translate.google.it/#en/it/".${$self->{found}[$self->{n}]}[4]);
		deactivate($self) unless $char eq 'o';
	} elsif ($char eq 'i') {
		$self->exec_async(@{$self->{browser}}, "http://translate.google.it/#it/en/".${$self->{found}[$self->{n}]}[4]);
		deactivate($self) unless $char eq 'i';
	} elsif ($char eq 'y') {
		my $found = $self->{found}[$self->{n}];
		$self->selection_beg(${$found}[0], ${$found}[1]);
		$self->selection_end(${$found}[2], ${$found}[3]);
		$self->selection_make($event->{time});
		$self->selection_beg(1, 0);
		$self->selection_end(1, 0);
		deactivate($self);
	} elsif ($char eq 'k' || $keysym == 0xff52 || $keysym == 0xff51) {
		select_next($self, -1, $event);
	} elsif ($char eq 'K') {
		$self->{row} = $self->{row} - 5;
		delete $self->{found};
		select_next($self, -1, $event);
    } elsif ($char eq 'J') {
		$self->{row} = $self->{row} + 5;
		delete $self->{found};
		select_next($self, 1, $event);
    }elsif ($char eq 'j' || $keysym == 0xff54 || $keysym == 0xff53) {
		select_next($self, 1, $event);
	} elsif ($char eq 'M' ) {
		$self->{row} = $self->nrow/2;
		delete $self->{found};
		select_next($self, 1, $event);
    }elsif ($char eq 'g' || $keysym == 0xff50) {
		$self->{row} = $self->top_row - 1;
		delete $self->{found};
		select_next($self, 1, $event);
	} elsif ($char eq 'G' || $keysym == 0xff57) {
		$self->{row} = $self->nrow;
		delete $self->{found};
		select_next($self, -1, $event);
	}

	return 1;
}


sub on_button_press {
	my ($self, $event) = @_;

	my $mask = $self->ModLevel3Mask | $self->ModMetaMask |
	           urxvt::ShiftMask | urxvt::ControlMask;

	if ($event->{button} == $self->{button} && ($event->{state} & $mask) == 0) {
		$self->{button_pressed} = 1;
		$self->{button_col} = $event->{col};
		$self->{button_row} = $event->{row};
	}

	()
}

sub on_button_release {
	my ($self, $event) = @_;

	if ($self->{button_pressed} && $event->{button} == $self->{button}) {
		my $col = $event->{col};
		my $row = $event->{row};

		$self->{button_pressed} = 0;

		if ($col == $self->{button_col} && $row == $self->{button_row}) {
			my $line = $self->line($row);
			my $text = $line->t;

			for my $pattern (@{$self->{pattern}}) {
				while ($text =~ /$pattern/g) {
					my ($url, $beg, $end) = ($&, $-[0], $+[0]);
					--$end if $url =~ s/["')]$//;

					if ($col >= $beg && $col <= $end) {
						$self->exec_async(@{$self->{browser}}, $url);
						return 1;
					}
				}
			}
		}
	}

	()
}


sub select_next {
	# $dir < 0: up, > 0: down
	my ($self, $dir, $event) = @_;
	my $row = $self->{row};

	if (($dir < 0 && $self->{n} > 0) ||
			($dir > 0 && $self->{n} < $#{ $self->{found} })) {
		# another url on current line
		$self->{n} += $dir;
		hilight($self);
		if ($self->{autocopy}) {
			my $found = $self->{found}[$self->{n}];
			$self->selection_beg(${$found}[0], ${$found}[1]);
			$self->selection_end(${$found}[2], ${$found}[3]);
			$self->selection_make($event->{time});
			$self->selection_beg(1, 0);
			$self->selection_end(1, 0);
		}
		return;
	}

	while (($dir < 0 && $row > $self->top_row) ||
		   ($dir > 0 && $row < $self->nrow - 1)) {
		my $line = $self->line($row);
		$row = ($dir < 0 ? $line->beg : $line->end) + $dir;
		$line = $self->line($row);
		my $text = $line->t;

		for my $pattern (@{$self->{pattern}}) {
			if ($text =~ /$pattern/g) {
				delete $self->{found};

				do {
					my ($beg, $end) = ($-[0], $+[0]);
					--$end if $& =~ /['")]$/;
					push @{$self->{found}}, [$line->coord_of($beg),
							$line->coord_of($end), substr($text, $beg, $end - $beg)];
				} while ($text =~ /$pattern/g);

				$self->{row} = $row;
				$self->{n} = $dir < 0 ? $#{$self->{found}} : 0;
				hilight($self);
				if ($self->{autocopy}) {
					my $found = $self->{found}[$self->{n}];
					$self->selection_beg(${$found}[0], ${$found}[1]);
					$self->selection_end(${$found}[2], ${$found}[3]);
					$self->selection_make($event->{time});
					$self->selection_beg(1, 0);
					$self->selection_end(1, 0);
				}
				return;
			}
		}
	}

	deactivate($self) unless $self->{found};

	()
}


sub hilight {
	my ($self) = @_;

	if ($self->{found}) {
		if ($self->{row} < $self->view_start() ||
				$self->{row} >= $self->view_start() + $self->nrow) {
			# scroll selected url into visible area
			my $top = $self->{row} - ($self->nrow >> 1);
			$self->view_start($top < 0 ? $top : 0);
		}

		status_area($self);
		$self->want_refresh();
	}

	()
}


sub refresh {
	my ($self) = @_;

	if ($self->{found}) {
		$self->scr_xor_span(@{$self->{found}[$self->{n}]}[0 .. 3], urxvt::RS_RVid);
	}

	()
}


sub status_area {
	my ($self) = @_;

	my $row = $self->{row} < 0 ?
			$self->{row} - $self->top_row : abs($self->top_row) + $self->{row};
	my $text = sprintf("%d,%d ", $row + 1, $self->{n} + 1);

	if ($self->top_row == 0) {
		$text .= "All";
	} elsif ($self->view_start() == $self->top_row) {
		$text .= "Top";
	} elsif ($self->view_start() == 0) {
		$text .= "Bot";
	} else {
		$text .= sprintf("%2d%",
				($self->top_row - $self->view_start) * 100 / $self->top_row);
	}

	my $text_len = length($text);

	if ($self->{overlay_len} != $text_len) {
		delete $self->{overlay} if $self->{overlay};
		$self->{overlay} = $self->overlay(-1, -1, $text_len, 1,
				urxvt::OVERLAY_RSTYLE, 0);
		$self->{overlay_len} = $text_len;
	}

	$self->{overlay}->set(0, 0, $self->special_encode($text));
	$self->{overlay}->show();

	()
}


sub tt_write {
	return 1;
}


sub activate {
	my ($self) = @_;

	$self->{active} = 1;

	$self->{row} = $self->view_start() + $self->nrow;
	$self->{n} = 0;
	$self->{overlay_len} = 0;
	$self->{button_pressed} = 0;

	$self->{view_start} = $self->view_start();
	$self->{pty_ev_events} = $self->pty_ev_events(urxvt::EV_NONE);

	$self->enable(
		key_press     => \&key_press,
		refresh_begin => \&refresh,
		refresh_end   => \&refresh,
		tt_write      => \&tt_write,
	);

	()
}


sub deactivate {
	my ($self) = @_;

	$self->disable("key_press", "refresh_begin", "refresh_end", "tt_write");
	$self->view_start($self->{view_start});
	$self->pty_ev_events($self->{pty_ev_events});

	delete $self->{overlay} if $self->{overlay};
	delete $self->{found} if $self->{found};

	$self->want_refresh();

	$self->{active} = 0;

	()
}