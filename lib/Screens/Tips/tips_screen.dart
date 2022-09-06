import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('Why use a password generator?'),
          children: [
            ListTile(
              title: Text(
                  'It is a lot more secure to have a unique passwords for each website. Using a generator helps with that by using a master password that ultimately creates a unique password depending on the website it is used for. Moreover, since the generators use hashing functions, they are unidirectional. It is extremely difficult to figure out the master password even if a hacker gets access to the generated password.'),
            ),
            ListTile(
              title: Text('You only have to remember your master password.'),
            )
          ],
        ),
        ExpansionTile(
          title: Text(
              'What\s the difference between a Password Generator and Password Manager?'),
          children: [
            ListTile(
              title: Text(
                  'A Password manager stores your passwords and helps you by autofilling the password fields. Passwords must be stored on the cloud to be accessible across all your devices. '),
            ),
            ListTile(
              title: Text(
                  'A Password generator is completely offline. No passwords are stored. No communication is done to any server or provider. All algorithms are ran on your device.'),
            ),
            ListTile(
              title: Text(
                  'From a pure security perspective, a password generator is a lot better as there is no risk of a third party fault. When using a password manager, you are susceptible to hackers intercepting your connection.'),
            )
          ],
        ),
        ExpansionTile(
          title: Text('What is the difference between SGP and KGPassGen?'),
          children: [
            ListTile(
              title: Text(
                  'KGPassGen uses the same underlying algorithm as SGP with small but critical adjustments. It is an improved version that fits today\'s standards of security.'),
            ),
            ListTile(
              title: Text(
                  'The default length for SGP generated passwords is 10 characters. The defaut length for KGPassGen generated passwords is 15 characters.'),
            ),
            ListTile(
              title: Text(
                  'The default number of hops for SGP generated passwords is 10 hops. The defaut number of hops for KGPassGen generated passwords is 15 hops.'),
            ),
            ListTile(
              title: Text(
                  'Generated password using SGP must contain: a lowercase character, an uppercase character, a number. Generated password using KGPassGen must contain: a lowercase character, an uppercase character, a number and a special character.'),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Should I use KGPassGen or SGP?'),
          children: [
            ListTile(
              title: Text(
                  'If you are prepared to change all your previous passwords then it is highly suggested to use KGPassGen. The addition of special characters helps secure your account further.'),
            )
          ],
        ),
        ExpansionTile(
          title: Text('Am I totally secure if I use this?'),
          children: [
            ListTile(
              title: Text(
                  'Short answer? No. Nothing is absolutely 100% secure. That does not mean that you should not try to be as secure as possible. It is highly recommended to toggle on "Validate passwords" in the settings page to make sure that your master password is secure by itself. After all, if your master password is compromised, your passwords will be at risk of being cracked.'),
            )
          ],
        )
      ],
    );
  }
}
