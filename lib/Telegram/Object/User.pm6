unit class Telegram::Object::User;

has $.id;
has $.is_bot;
has $.username;

method new($json) {
  return self.bless(
    id => $json<id>,
    is_bot => $json<is_bot>,
    username => $json<username>
  );
}
