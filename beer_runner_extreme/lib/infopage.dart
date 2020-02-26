import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget
{
  @override 
  Widget build(BuildContext context)
  {
    return Scaffold
    (  
      body: SafeArea
      ( 
        child: ListView
        (
          padding: EdgeInsets.all(16.0),
          children: <Widget>
          [
            Text("Sovellus täytää kaikkien vaatimusten funktionaalisuuden."),
            Text(""),
            Text("* = puute / mahdollinen puute, tarkemmat kommentit @ readme.txt."),
            Text(""),
            Text("1. Rekisteröinti - toteutettu."),
            Text("2. Sisäänkirjautuminen - toteutettu."),
            Text("3. Salasanan muutos - toteutettu."),
            Text("4. Uloskirjautuminen - toteutettu."),
            Text("5. Splashscreen - toteutettu."),
            Text("6. Suoritusnäkymä - puutteellinen*."),
            Text("7. Suorituksen lisääminen - puutteellnen*."),
            Text("8. Suorituksen muokkaaminen - puutteellinen*."),
            Text("9. Suorituksen poistaminen - toteutettu."),
            Text("10. Logo suoritukselle - toteutettu."),
            Text("11. Valokuva suoritukselle - toteutettu."),
            Text("12. Sovelluksen välilehditys - toteutettu."),
            Text("13. Omien tietojen muokkaus - puutteellinen*."),
            Text("14. Lajien lataus serveriltä - toteutettu."),
            Text("n. Toteutettujen ominaisuuksien lista - toteutettu."),
          ],
        )
      )
    );
  }
}