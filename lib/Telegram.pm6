unit package Telegram;

use Cro::HTTP::Client;

constant $baseUrl = "https://api.telegram.org/bot";

class Bot {
  has $.token;

  has $!client;
  has $!lastUpdateId;
  has $!on = False;

  has $!messages = Supplier.new;

  method new(Str $token) {
    self.bless(:$token);
  }
  method TWEAK {
    $!client = Cro::HTTP::Client.new:
      base-uri => $baseUrl ~ $!token ~ '/',
      content-type => 'application/json',
      follow => False;
  }
  method send(:$chat_id!, :$text!) {
    my $response = await $!client.get('sendMessage?chat_id=' ~ $chat_id ~ '&text=' ~ $text);
    my $json = await $response.body;
  }
  method !update {
    my $response = await $!client.get('getUpdates?limit=10&allowed_updates=message&offset=' ~ (?$!lastUpdateId ?? $!lastUpdateId !! ''));
    CATCH {
      when X::Cro::HTTP::Error {
        die "Problem getting updates. Response code: {.response.status}";
      }
    }

    my $json = await $response.body;
    warn "Returned JSON is malformed" if $json<ok>:exists && !$json<ok>;

    my $lastResult = $json<result>[$json<result>.elems - 1]<update_id>;

    my $change = False;

    if ?$!lastUpdateId {
      $change = True if $!lastUpdateId != $lastResult;
    }

    $!lastUpdateId = $lastResult;
    if $change {
      $!messages.emit($json<result>[$json<result>.elems - 1]<message>);
    }
  }
  method start(:$interval = 2) {
    $!on = True;
    start {
      while $!on {
        self!update;
        sleep $interval;
      }
    }
  }
  method stop {
    $!on = False;
  }
  method messagesTap {
    return $!messages.Supply;
  }
}
