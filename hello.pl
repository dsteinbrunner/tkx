#!/usr/bin/perl -w

use strict;
use yTk;

my $mw = yTk::widget->new(".");
my $b;

$b = $mw->n_button(
    -text => "Hello, world!",
    -command => sub {
	$b->configure(
	    -state => "disabled",
	    -background => "red");
	yTk::after(3000, [\&yTk::destroy, $mw]);
    });

$b->e_pack;

yTk::package_require("BWidget");
$mw->n_ArrowButton->e_pack;
$mw->n_ArrowButton->e_pack;
$mw->n_ArrowButton->e_pack;

my $f = $mw->n_frame(-width => 30, -height => 30, -background => "white", -name => "xxx");
$f->e_pack;
$f->n_ArrowButton->e_pack;

yTk::package_require("Iwidgets");
$mw->n_iwidgets__calendar->e_pack;

$b->e_DynamicHelp__add(-text => "Click here to exit");

print "NAME:" . $b->e_winfo_name . "\n";

yTk::MainLoop();
