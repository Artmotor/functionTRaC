(: Функция вывода полного количества лет сотрудника :)

module namespace report = "http://www.iro37.ru/trac/api/report/reportAge";

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
                 $r/cell[ @id = "year" ]
                }
              </td>
              <td>
                {
(: Подсчет количества полных лет :)
                  let $date :=  $r/cell[ @id = "year" ] 
                  return 
                    report:countDuration( $date ) 
                }
              </td>
              <td>
              {
(: Подсчет стажа работы в Лицее Перспектива :)
                  let $date :=  $r/cell[ @id = "yearWorkOO" ] 
                  return 
                    report:countDuration( $date )
              }
              </td>
              <td>
                {
(: Подсчет общего педагогического стажа :)
                  let $date :=  $r/cell[ @id = "yearWorkPedagogy" ] 
                  return 
                    report:countDuration( $date )
                }
              </td>
              <td>
                {
(: Подсчет общего трудового стажа :)
                   let $date :=  $r/cell[ @id = "yearWorkTotal" ] 
                  return 
                    report:countDuration( $date )
                }
              </td>
            </tr>
        }
      </table>
};
(: -------------  функция расчет периода в годах от текущей даты ----------------- :)
declare 
  %private
function report:countDuration ( $date as xs:string ) {
  try { 
    let $t :=( xs:date(current-date() ) -  xs:date( $date ) ) div xs:dayTimeDuration('P1D') idiv 365.242199 * xs:yearMonthDuration('P1Y') 
    let $duration := fn:years-from-duration( xs:yearMonthDuration( $t ) )
    return  
      if ( $duration = 0 )
      then ( "меньше 1 года" )
      else ( $duration )
   }
   catch* { "н/д" }

};