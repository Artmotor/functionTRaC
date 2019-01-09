import module namespace report = "http://www.iro37.ru/trac/api/report" at "Отчет-приказ.xqm";

let $domain := "ood"
let $user := "poa"
let $data := db:open("trac-dev")/domains/domain["ood"]/data/user[ @id= $user]/table [@type="Data" and @aboutType = "student"][ @id = "astro2"]

let $report := report:зачисление ( $domain, <table>{$data}</table> ) 

return $report