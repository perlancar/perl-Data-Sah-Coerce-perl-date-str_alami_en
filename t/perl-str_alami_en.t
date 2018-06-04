#!perl

use 5.010001;
use strict;
use warnings;

use Data::Sah::Coerce qw(gen_coercer);
use Test::Exception;
use Test::More 0.98;
use Test::Needs;

subtest "basics" => sub {
    test_needs "DateTime::Format::Alami::EN";

    my $c = gen_coercer(type=>"date", coerce_rules=>["str_alami_en"], return_type=>"status+err+val");
    my $res;

    # uncoerced
    $res = $c->({});
    ok(!$res->[0]);
    is_deeply($res->[2], {});

    # fails
    $res = $c->("foo");
    ok($res->[0]);
    ok($res->[1]);
    ok(!$res->[2]);
};

subtest "coerce_to=DateTime" => sub {
    test_needs "DateTime";
    test_needs "DateTime::Format::Alami::EN";

    my $c = gen_coercer(type=>"date", coerce_to=>"DateTime", coerce_rules=>["str_alami_en"]);

    my $d = $c->("may 19, 2016");
    is(ref($d), 'DateTime');
    is($d->ymd, "2016-05-19");
};

subtest "coerce_to=Time::Moment" => sub {
    test_needs "DateTime::Format::Alami::EN";
    test_needs "Time::Moment";

    my $c = gen_coercer(type=>"date", coerce_to=>"Time::Moment", coerce_rules=>["str_alami_en"]);

    my $d = $c->("may 19, 2016");
    is(ref($d), 'Time::Moment');
    is($d->strftime("%Y-%m-%d"), "2016-05-19");
};

subtest "coerce_to=float(epoch)" => sub {
    test_needs "DateTime::Format::Alami::EN";

    my $c = gen_coercer(type=>"date", coerce_to=>"float(epoch)", coerce_rules=>["str_alami"]);

    my $d = $c->("may 19, 2016");
    ok(!ref($d));
    is($d, 1463616000);
};

done_testing;
