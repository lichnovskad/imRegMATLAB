# imRegMATLAB - Automatická registrace z videa

## Verze 0.0.2

## Funkce
* **untitled** - prozatím "spouštějící" soubor, načte videa a spustí makeImSet a registrace, po sobě
* **makeImSet** - vybere nejlepší snmky z videa, používá funkce: computeFM, transformCheck
* **registrace** - registrace snímků, které získáme z makeImSet, asi by se mělo přejmenovat(?), používá createPanorama
* **repStats** - spoštěcí soubor pro repeatability, vygeneruje rozmazané dvojice(genBlur), nakonec spočítá průměr a rozptyl

## "podfunkce"
(co jsem se koukala, tak v matlabu je docela problém schovat funkce pod jeden file, nebo to naházeet do jedné  složky, 
takže v tom prozatím bude trochu nepořádek)
* **repeatability** - počítá rep. a localization error pro dvojici snímků
* **genBlur** - generuje rozmazané dvojice stejné délky a náhodné orientace bluru
* **computeFM** - počítá focus measure vsech snímků ve videu
* **transformCheck** - kontroluje, zda registrace 2 snímků proběhla úspěšně, potřebuje computeLimits, computeTforms, používá warp2Images
* **createPanorama** - vytvoří panorama, potřebuje computeLimits, computeTforms
* **computeLimits** - počítá okraje registrovaných snímků
* **computeTforms** - počítá transformační matice
* **warpTwoImages** - registruje 2 snímky a odečtením transd. snímků počítá chybu transformace
* **error_work** - pracovní file, hledám práh pro chybu transformace(viz warpTwoImages)
* **cylWarp** - přetransformuje obrázek do cylindrických souřadnic

## ostatní soubory
* **schema.jpg** - prozatimní schéma programu (taková pipeline?)
* **rep.png** - ukázka závislosti repeatability na délce bluru

## Co to je repeatability?

článek str. 15-17: https://hal.inria.fr/inria-00548302/document

## ???
* Jak rychle/pomalu je třeba se pohybovat, aby ještě fungovala registrace?
* Nechat všechna videa projít celou pipelinou
* Vliv zašumění (podobný experiment jako blur)

## Pokyny pro vypracování - zadání z bakalářky
* Seznamte se základními postupy registrace obrazů a skládání panoramat.
* Navrhněte registrační metodu vhodnou na skládání snímků videa zachycující regál v
obchodě.
* Navrhněte metodu na detekci kvality registrace.
* Analyzujte vliv rozmazání způsobené pohybem ruky na kvalitu registrace.
* Navrhněte metodu na výběr snímků z videa optimalizující prostorové pokrytí regálu a
kvalitu registrace.
* Experimentálně ověřte navržený postup na reálných videích.
* V případě, že bude k dispozici metoda na detekci zboží, tak ověřte funkčnost navrženého
postupu i s ohledem na schopnost detekovat správně zboží.
