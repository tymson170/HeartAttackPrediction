# Heart Attact

# todo

-   [x] wykres gęstości heart rate (przed czyszeczniem danych) zrobić jako interaktywny (tip: ggplotly)

-   [x] to samo dla ckmb-troponin

-   [x] age distibution by gender and age - zmienic 0 i 1 na p/n i male/female

-   [x] wywalic str(x)

-   [x] "Distribution of Heart Disease"

    -   dodac opis
    -   labele na x'ie zmienic
    -   oś y jako density (ma wypisywać % przypadków)
    -   (opcjonalnie) dodać ilość % nad słupkiem

-   [x] wywalić tabelke z ilością % pozytywnych przypadków

-   [x] test na rowność % pozytywnych przypadków przesnieść

-   [x] wywalic ten 2 corrplot

-   [x] wybrac wykres z corrplota i jako oddzielny wykres umiescic (wybrano troponin vs ckmb w plotly)

-   [x] wywalić test na rownosc srednich wieku (albo wymyśleć wniosek/cel po co to zrobiliśmy)

-   [ ] zrobić inny test (wymyśleć jaki)

-   [x] zrobić k fold cross validation (w sekcji trenowania modelu drzewa decyzyjnego)

-   [ ] zrobić k fold cross validation dla regresji logistycznej

-   [x] zrobić cross-validation drzewa decyzyjnego w celu znalezienia najlepszych parametrów

-   [ ] w podsumowaniu porównać wartości CKMB i troponiny, jakie mamy w modelu, do oficjanych metryk stosowanych przez lekarzy do wykrycia zawalu

-   [x] dopisać że w regresji logistycznej tylko dwie zmienne są znaczące statystycznie (age i gender), ale one nie są w stanie wystarczająco dobrze wytłumaczyć czy ktoś ma zawał serca

-   [ ] napisac odpowiedzi na pytania badawcze
-   [ ] spróbować standaryzacji zmiennych

chwilowo: - do corrplotow dodac result

-   umieścić 2 modele - sieć neuronowa + prosty glm i porównać wyniki

-   pomysl na model:

    ```         
    1 Age           Gender       Heart Rate     Systolic.blood.pressure + blood sugar

    2  Age           Gender       Heart Rate     Diastoic.blood.pressure + blood sugar
    ```

-   footnotes: 1 <https://web.archive.org/web/20150224034615/http://www.nhlbi.nih.gov/health/health-topics/topics/cad/signs>

2 <https://ec.europa.eu/eurostat/web/products-statistics-in-focus/-/ks-nk-06-010>

1.  Przedstawienie zbioru danych

    1.  Źródło danych

        2.  Zawartość zbioru: informacja o ilości danych, kiedy zostały zebrane

        3.  Przedstawienie zmiennych: opis jakie są i co znaczą

2.  Cele badawcze - sprawdzenie, jakie czynniki mają wpływ na wystąpienie udaru u człowieka

3.  Przygotowanie zbioru / weryfikacja poprawnosci danych / brakujace wartosci - caly kod którym porządkujemy dane, zmieniamy wartosci na factor, może dzielimy wiek na sekcje (18-25, 26-50)

4.  Opis zbioru / statystyczna analiza opisowa - summary, statystyki opisowe,

5.  Wizualizacja - ...

6.  Analiza korespondencji - *sprawdzic czy nam to potrzebne* <https://www.statsoft.pl/textbook/stathome_stat.html?https%3A%2F%2Fwww.statsoft.pl%2Ftextbook%2Fstcoran.html>

7.  Model

    1.  Wybór modelu - wypisac ktory moze byc najlepszy

    2.  stworzenie modelu

    3.  przetrenowanie modelu

    4.  testowanie modelu

    5.  Podsumowanie efektywności modelu / jego przydatności

8.  Odpowiedź na pytania badawcze i podsumowanie
