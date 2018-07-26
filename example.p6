use v6;

use lib 'lib';
use Telegram;

my $bot = Telegram::Bot.new('633859659:AAH108rQTzVcaPcMgj3IW0ktESb3j6rNIgI');
$bot.start(interval => 1);

my $tap = $bot.messagesTap;

react {
  whenever $tap -> $msg {
    say $msg.text;
    say $msg.chat.id;
  }
  whenever signal(SIGINT) {
    $bot.stop;
    exit;
  }
}
