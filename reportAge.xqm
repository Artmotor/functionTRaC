(: Функция вывода полного количества лет сотрудника :)

module namespace report = "http://www.iro37.ru/trac/function/report";

declare %public function report:Возраст ( $data ) {
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
                  $r/cell[@id="year"] 
                }
              </td>
              <td>
                {
(: Подсчет количества полных лет :)
                  let $t := (xs:date(current-date()) - xs:date($r/cell[@id = "year"])) div xs:dayTimeDuration('P1D') idiv 365.242199 * xs:yearMonthDuration('P1Y')
                  return  fn:years-from-duration(xs:yearMonthDuration($t))
                }
              </td>
              <td>
              {
(: Подсчет стажа работы в Лицее Перспектива :)
                 let $t := (xs:date(current-date()) - xs:date($r/cell[@id = "yearWorkOO"])) div xs:dayTimeDuration('P1D') idiv 365.242199 * xs:yearMonthDuration('P1Y')
                 let $y := fn:years-from-duration(xs:yearMonthDuration($t))
                  return
                    if ( $y < 1 )
                    then ( "Стаж в Лицее меньше одного года" )
                    else ( $y )
              }
              </td>
              <td>
                {
(: Подсчет общего педагогического стажа :)
                  let $t := (xs:date(current-date()) - xs:date($r/cell[@id = "yearWorkPedagogy"])) div xs:dayTimeDuration('P1D') idiv 365.242199 * xs:yearMonthDuration('P1Y')
                  return  fn:years-from-duration(xs:yearMonthDuration($t))
                }
              </td>
              <td>
                {
(: Подсчет общего трудового стажа :)
                  let $t := (xs:date(current-date()) - xs:date($r/cell[@id = "yearWorkTotal"])) div xs:dayTimeDuration('P1D') idiv 365.242199 * xs:yearMonthDuration('P1Y')
                  return  fn:years-from-duration(xs:yearMonthDuration($t))
                }
              </td>
            </tr>
        }
      </table>
};