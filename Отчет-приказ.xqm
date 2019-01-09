module namespace report = "http://www.iro37.ru/trac/api/report";


declare %public function report:зачисление ( $domain, $data ) {
     <table class="table table-striped">
        <tr>
          <th>№ пп</th>
          <th>ФИО</th>
          <th>Должность, место работы</th>
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
                {string-join ( $r/cell[@id=("familyName", "givenName", "secondName")]/text() , " ")}
              </td>
              <td>
                {
                  $school/cell[@id=( "city__type__full" )] || " " ||
                  $school/cell[@id=( "mo" )] || " " ||
                  $school/cell[@id=( "area__type__full" )] || ", " ||
                  $school/cell[@id=( "label" )] || ", " ||
                  $r/cell[@id="position"] 
                }
              </td>
            </tr>
        }
      </table>
};
