use v6;

use lib 'lib';
use Telegram;

my $bot = Telegram::Bot.new('<Your bot token here>');
$bot.start(1);

my $tap = $bot.messagesTap;

react {
  whenever $tap -> $msg {
    $bot.sendMessage($msg.chat.id, "Hello, {$msg.sender.firstname}");
  }
  whenever signal(SIGINT) {
    $bot.stop;
    exit;
  }
}
