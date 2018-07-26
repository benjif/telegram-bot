unit class Telegram::Object::Message;

use Telegram::Object::Chat;

has $.chat;
has $.text;
has $.is_bot;
has $.username;

method new($json) {
  return self.bless(
    chat => Telegram::Object::Chat.new($json<chat>),
    text => $json<text>,
    is_bot => $json<from><is_bot>,
    username => $json<from><username>
  );
}
