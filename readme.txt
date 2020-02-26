oskari sihvonen
etx13sp @ savonia amk
2020


mobiiliohjelmoinnin harjoitustyö


lokaalia testaamista varten suoritettavat toimenpiteet:

- tietokannan luonti, tietokanta = makkara ja loput löytyy makkara.sql:stä
- lokaalin ip-osoitteen asetus jsonfucker.dart (client) sekä BeerMonastery/Program.cs (server) -tiedostoihin
- tietokannan yhteyspolun päivitys jos kantaa ei luotu osoitteeseen (localdb)\mssqllocaldb
- mahdollisia dart-pakettien ym. -kirjastojen asennusta, softa osannee hakea ne pubspecin perusteella
- softaa ei ole portattu androidx:lle, toivottavasti mahdollinen uudempi alusta ei rampauta softaa
- luo kansio beer Android-laitteen/emulaattorin polkuun /storage/self/primary/[tähän beer] kuvien tallentamiseksi laitteelle, ko. kansio muistaakseni emuloi ulkoista muistikorttia
- oma kansioni sai rw-oikeudet suoraan, kannattanee kuitenkin katsoa että sellaiset siihen on
- serveri päälle ennen komentojen lähettämistä sinne, muuten haamukomennot pistävät kaiken sekaisin, ei mitään mikä ei rebootilla oikenisi tosin

toteutetut toiminnot:

- kaikki minm. puutteilla.

tarkemmat kommentit:

- yleisesti voisi sanoa sovelluksen olevan toimiva prototyyppi tavoitellusta sovelluksesta, jonka avulla voidaan esitellä tavoitesovelluksen funktionaalisuutta, ns. poc.
- on ihan mallia perinteinen esittelysofta, kun tietää mitä tekee, toimii, muuten varmaan syöttää jotain väärää dataa ja vähintään saadaan kivaa erroria.
- kaikki sivujen väliset siirtymät eivät ole loogisia ja sujuvia.
- sovellus sisältää useita selkeitä puutteita sekä virheitä, mitkä tekevät sen käyttöönotosta reaalimaailmaan mahdottoman ajatuksen.
- mutta tarkoituksena olikin tehdä proto eikä valmista softaa.
- päivämäärien pyörittäminen on vastenmielistä.

- kuvat tallentuvat serverin juureen BeerMonastery\BeerMonastery\bin\Debug\netcoreapp2.1\Images\[activityID].png
- kuvat tallentuvat laitteelle /storage/self/primary/beer/ kansioon

vaatimuskohtaiset kommentit (57/59):

1. Rekisteröinti ja neljä vaadittua tietoa. Kaikki vaaditaan ja lyödään kantaan. 
    Ei puutteita.

2. Sisäänkirjautuminen. Käyttäjätunnus-salasana -pari tarkistetaan serveriltä. 
    Ei puutteita.

3. Salasanan vaihto. Tarkistetaan uuden salasanan oikeinkirjoitusasu ja kutsutaan serveriä. 
    Ei puutteita.

4. Uloskirjautuminen, jonka jälkeen on kirjauduttava sisään uudestaan. Uloskirjautuminen tapahtuu palaamalla takaisin vasemman yläkulman nuolesta. 
    Ei puutteita.

5. Splashscreen. Tämähän on automaattisesti Flutterilla, demonstraation vuoksi kuitenkin muutettu kuvaa. 
    Ei puutteita.

6. Suoritusten listanäkymä. Suoritukset haetaan kannasta ja vaaditut tiedot näytetään. 
    Mahdollinen puute: lajien aliolioittamisen puute ja tästä johtuva keston ja matkan yhdistäminen mittaus-kentän alle.
    Puute: päivämäärän käsittely tekstinä ajan sijaan. 

7. Suorituksen lisääminen. Pyydetään vaaditut tiedot ja lyödään ne kantaan.
    Mahdollinen puute: lajien aliolioittamisen puute ja tästä johtuva keston ja matkan yhdistäminen mittaus-kentän alle.
    Puute: päivämäärän käsittely tekstinä ajan sijaan.

8. Suorituksen muokkaaminen. Kaikkia suorituksen tietoja pystyy muokkaamaan.
    Mahdollinen puute: lajien aliolioittamisen puute ja tästä johtuva keston ja matkan yhdistäminen mittaus-kentän alle.
    Puute: päivämäärän käsittely tekstinä ajan sijaan.

9. Suorituksen poistaminen. Suoritus voidaan poistaa ja käyttäjältä varmistetaan poistaminen.
    Ei puutteita.

10. Logo suoritukselle. Käyttäjä voi valita kolmesta täysin asiaan sopimattomasta logosta. Logon voi vaihtaa.
    Ei puutteita.

11. Valokuva sovellukselle. Kuva voidaan lisätä ja hakea serveriltä. Jokseenkin prototyyppimaisen epäselvästi toteutettu, mutta täysin funktionaalinen.
    Ei puutteita.

12. Sovelluksen välilehditys. Yllä kolme vaadittua välilehteä, infolehdellä aivan liikaa funktionaalisuutta epäselvästi esitettynä mutta prototyyppi.
    Ei puutteita.

13. Omien tietojen muokkaus. Vaadittuja tietoja voi muokata.
    Puute: päivämäärän käsittely tekstinä ajan sijaan.

14. Lajien hakeminen tietokannasta. Niin tehdään.
    Ei puutteita.
