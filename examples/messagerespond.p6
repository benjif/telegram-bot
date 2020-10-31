use v6;

use lib 'lib';
use Telegram;

my $bot = Telegram::Bot.new(%*ENV<EXAMPLE_BOT_TOKEN>);
$bot.start(1);

my $tap = $bot.messagesTap;

react {
  whenever $tap -> $msg {
    $bot.sendMessage($msg.chat.id,
            "Hello, {$msg.sender.firstname}, I have {$msg.text}");
  }
  whenever signal(SIGINT) {
    $bot.stop;
    exit;
  }
}
