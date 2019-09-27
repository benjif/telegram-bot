use v6;

use lib 'lib';
use Telegram;

my $bot = Telegram::Bot.new('<Your bot token here>');
$bot.start(1);

my $tap = $bot.messagesTap;

react {
  whenever $tap -> $msg {
    say "Received \"{$msg.text}\" from {$msg.sender.username} on {$msg.date}.";
  }
  whenever signal(SIGINT) {
    $bot.stop;
    exit;
  }
}
