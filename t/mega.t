#!perl -w

use strict;
use Test qw(plan ok);

plan tests => 4;

use Tkx;

my $delay = shift || 1;

my $mw = Tkx::widget->new(".");
$mw->configure(-border => 10);

$mw->c_label(-text => "Foo")->g_pack;
$mw->c_foo(-name => "myfoo", -text => "Bar")->g_pack;

my $f = $mw->c_frame(-border => 5, -background => "#555555");
$f->g_pack;

my $foo = $f->c_foo(-text => "Other", -foo => 42);
$foo->g_pack;
ok($foo->cget("-foo"), 42);

$foo = $mw->_kid("myfoo");
ok(ref($foo), "Foo");
ok($foo->cget("-foo"), undef);
$foo->configure(-background => "yellow", -foo => 1);
ok($foo->cget("-foo"), 1);

Tkx::after($delay * 1000, sub {
    $mw->g_destroy;
});

Tkx::MainLoop;

sub j { join(":", @_) }


BEGIN {
    package Foo;
    use base 'Tkx::widget';
    Tkx::widget->_Mega("foo");

    sub _Populate {
	my($class, $widget, $path, %opt) = @_;

	my $parent = $class->new($path)->_parent;
	my $self = $parent->c_frame(-name => $path);

	$self->_data->{foo} = $opt{-foo};

	$self->c_label(-name => "lab", -text => delete $opt{-text})->g_pack(-side => "left");
	$self->c_entry->g_pack(-side => "left", -fill => "both", -expand => 1);

	$self->_class($class);
	$self;
    }

    sub _ipath {
	my $self = shift;
	"$self.lab";  # delegate
    }

    sub m_configure {
	my($self, %opt) = @_;
	if (exists $opt{-foo}) {
	    $self->_data->{foo} = delete $opt{-foo};
	}
	return $self->SUPER::m_configure(%opt);
    }

    sub m_cget {
	my($self, $opt) = @_;
	if ($opt eq "-foo") {
	    return $self->_data->{foo};
	}

	return $self->SUPER::m_cget($opt);
    }
}