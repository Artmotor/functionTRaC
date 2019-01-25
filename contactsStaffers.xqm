(: Функция вывода контактов сотрудников :)

module namespace report = "http://www.iro37.ru/trac/api/report";

declare %public function report:контакты ( $domain, $data ) {
     <table class="table table-striped">
        <tr>
          <th>№ пп</th>
          <th>ФИО</th>
          <th>Телефон</th>
          <th>Электронная почта</th>
          <th>Домашний адрес</th>
          <th>Адрес регистрации</th>
          <th>Дополнительные контакты</th>
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
(: -Телефон- :)
                  string-join ( $r/cell[@id="telephon"] /text() , " ")
                }
              </td>
              <td>
                {
(: -Элетронная почта- :)
                 string-join ( $r/cell[@id="email"] /text() , " ")
                }
              </td>
                <td>
                {
(: -Домашний адрес- :)
                 string-join ( $r/cell[@id="adress"] /text() , " ")
                }
              </td>
                <td>
                {
(: -Регистрация адрес- :)
                 string-join ( $r/cell[@id="adress1"] /text() , " ")
                }
            </td>
            <td>
                {
(: -Дополнительные контакты- :)
                 string-join ( $r/cell[@id="face"] /text() , " ")
                }
            </td>
            </tr>
        }
      </table>
};
