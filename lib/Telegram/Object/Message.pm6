unit class Telegram::Object::Message;

use Telegram::Object::Chat;
use Telegram::Object::User;

has $.chat;
has $.text;
has $.sender;

method new($json) {
  return self.bless(
    chat => Telegram::Object::Chat.new($json<chat>),
    sender => Telegram::Object::User.new($json<from>),
    text => ?$json<text> ?? $json<text> !! ''
  );
}
