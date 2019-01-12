(: Функция вывода полного количества лет сотрудника :)

module namespace report = "http://www.iro37.ru/trac/api/report";

declare %public function report:зачисление ( $domain, $data ) {
     <table class="table table-striped">
        <tr>
          <th>№ пп</th>
          <th>ФИО</th>
          <th>Дата рождения</th>
          <th>Количество полных лет</th>
          <th>Стаж работы в Лицее Перспектива</th>
          <th>Общий педагогический стаж</th>
          <th>Общий трудовой стаж</th>
        </tr>
        {
          for $r in $data/table/row
          let $inn := $r/cell[@id="inn"]/text() 
          
          let $school := 
            try {
              fetch:xml (
                web:create-url ( "http://localhost:8984/trac/api/Data/public/" || $domain || "/"|| "eduOrg",
                  map { "q" :  "id:" || $inn }  )
              )/table/row[1]
            }
            catch * {
            }
          order by $r/cell[@id="familyName"]
          count $n
          return
            <tr>
              <td>{$n}</td>
              <td>
                {string-join ( $r/cell[@id=("familyName", "givenName", "secondName","familyName")]/text() , " ")}
              </td>
              <td>
                {
(: Выводит дату рождения :)
                  $school/cell[@id=( "city__type__full" )] || " " ||
                  $r/cell[@id="year"] 
                }
              </td>
              <td>
                {
(: Подсчет количества полных лет :)
                  let $t := (xs:date(current-date()) - xs:date($r/cell[@id = "year"])) div xs:dayTimeDuration('P1D') idiv 365.242199 * xs:yearMonthDuration('P1Y')
                  return  fn:years-from-duration(xs:yearMonthDuration($t))
                };
              </td>
              <td>
              {
(: Подсчет стажа работы в Лицее Перспектива :)
                 let $t := (xs:date(current-date()) - xs:date($r/cell[@id = "yearWorkOO"])) div xs:dayTimeDuration('P1D') idiv 365.242199 * xs:yearMonthDuration('P1Y')
                  return  fn:years-from-duration(xs:yearMonthDuration($t))
              };
              </td>
              <td>
                {
(: Подсчет общего педагогического стажа :)
                  let $t := (xs:date(current-date()) - xs:date($r/cell[@id = "yearWorkPedagogy"])) div xs:dayTimeDuration('P1D') idiv 365.242199 * xs:yearMonthDuration('P1Y')
                  return  fn:years-from-duration(xs:yearMonthDuration($t))
                };
              </td>
              <td>
                {
(: Подсчет общего трудового стажа :)
                  let $t := (xs:date(current-date()) - xs:date($r/cell[@id = "yearWorkTotal"])) div xs:dayTimeDuration('P1D') idiv 365.242199 * xs:yearMonthDuration('P1Y')
                  return  fn:years-from-duration(xs:yearMonthDuration($t))
                };
              </td>
            </tr>
        }
      </table>
};