use v6;

use lib 'lib';
use Telegram;

my $bot = Telegram::Bot.new('633859659:AAH108rQTzVcaPcMgj3IW0ktESb3j6rNIgI');
$bot.start(interval => 1);

my $tap = $bot.messagesTap;

react {
  whenever $tap -> $msg {
    given $msg<text> {
      when .?starts-with("m: ") {
        when .chars < 150 {
          try {
            my $code = .substr(3);
            my $runCode = run 'perl6', '-e', $code, :out; #EVAL(.substr(3));
            my $response = $runCode.out.slurp(:close);
            $response .= subst(/<-alnum>/, *.ord.fmt("%%%02X"), :g);
            $bot.send(chat_id => $msg<chat><id>, text => $response);
          }
        }
        default {
          say "Too long";
        }
      }
    }
  }
  whenever signal(SIGINT) {
    $bot.stop;
    exit;
  }
}
