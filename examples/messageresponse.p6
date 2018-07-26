use v6;

use lib 'lib';
use Telegram;

my $bot = Telegram::Bot.new('633859659:AAH108rQTzVcaPcMgj3IW0ktESb3j6rNIgI');
$bot.start(interval => 1);

my $tap = $bot.messagesTap;

react {
  whenever $tap -> $msg {
    say "Message: {$msg.text}";
    say "Chat: {$msg.chat.id}";
    say "Sender: {$msg.sender.username}";
  }
  whenever signal(SIGINT) {
    $bot.stop;
    exit;
  }
}
